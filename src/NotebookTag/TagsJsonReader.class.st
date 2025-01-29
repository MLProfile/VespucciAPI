"
```st
folder := '/Users/cyril/Downloads/profile_labels_export_student_a' asFileReference.
jsonName := 'profile_labels_export_student_a.json'.

pythonModel := FamixPythonImporter import:  folder.

tagging := TagsJsonReader new
			model: pythonModel;
			yourself .

tagging readAndFix: (folder / jsonName).
```
"
Class {
	#name : 'TagsJsonReader',
	#superclass : 'Object',
	#instVars : [
		'filename',
		'model'
	],
	#category : 'NotebookTag',
	#package : 'NotebookTag'
}

{ #category : 'as yet unclassified' }
TagsJsonReader >> assignTagToModel: tags [

	| startPos endPos tag |
	startPos := tags at: 'start'.
	endPos := tags at: 'end'.
	tag := tags at: 'label'.
	
	self tagEntitiesFrom:startPos to: endPos with: tag
	 
]

{ #category : 'as yet unclassified' }
TagsJsonReader >> fixBadImportsIn: aDictionary [

	| missingImports |
	missingImports := self getBadLabeledImports.

	missingImports do: [ :import |
		| sourceText |
		sourceText := import sourceText.
		(aDictionary at: #labels)
			detect: [ :entry | ((entry at: #label) = 'Library Loading') not and: [ (entry at: #code) = sourceText ] ]
			ifFound: [ :entry |
				entry at: #oldLabel put: (entry at: #label).
				entry at: #label put: 'Library Loading' ]
			ifNone: [ self error: 'We have a missing import that does not have any entry with its source text.' ] ]
]

{ #category : 'as yet unclassified' }
TagsJsonReader >> fixLibraryAndFunctionIn: aDictionary [

	(aDictionary at: #labels)
		select: [ :entry | (entry at: #label) = 'Library Loading' ]
		thenDo: [ :entry |
			| correspondingImport function library |
			self flag: #todo. "We should factorize that to have the same comparison in #getBadLabeledImports and here."
			correspondingImport := model allImports detect: [ :import | import sourceText = (entry at: #code) ].
			function := entry at: #function.
			"If we have a from import, the function should be the imported entity. Else it should be nil"
			correspondingImport isFromImport
				ifTrue: [
					(function isNotNil and: [ function = correspondingImport importedEntity name ]) ifFalse: [
						entry at: #oldFunction put: function.
						entry at: #function put: correspondingImport importedEntity name ] ]
				ifFalse: [
					function ifNotNil: [
						entry at: #oldFunction put: function.
						entry at: #function put: nil ] ].

			library := entry at: #library.
			library = correspondingImport importedEntity libraryName ifFalse: [
				entry at: #oldLibrary put: library.
				entry at: #library put: correspondingImport importedEntity libraryName ] ]
]

{ #category : 'as yet unclassified' }
TagsJsonReader >> getBadLabeledImports [

	| imports notLabeled |
	imports := self getEntitiesWithTagNamed: 'Library Loading'.
	^ notLabeled := model allImports reject: [ :entity | imports anySatisfy: [ :import | import mooseID = entity mooseID ] ]
]

{ #category : 'as yet unclassified' }
TagsJsonReader >> getEntitiesWithTagNamed: aTagName [

	| tag entities |
	tag := model allTags findTagNamed: aTagName.
	^tag taggedEntities.

]

{ #category : 'accessing' }
TagsJsonReader >> model [

	^ model
]

{ #category : 'accessing' }
TagsJsonReader >> model: aPythonModel [

	model := aPythonModel .
]

{ #category : 'meta-object-protocol' }
TagsJsonReader >> read: json [ 
	| tags |
	json ifEmpty: [ self halt. ] ifNotEmpty: [
		
		tags := json at: 'labels'.
		tags do: [ :tag | self assignTagToModel: tag ] ]
]

{ #category : 'as yet unclassified' }
TagsJsonReader >> readAndFix: aFileReference [

	| dictionaryToFix |
	dictionaryToFix := self readFrom: aFileReference.

	self fixBadImportsIn: dictionaryToFix.
	
	self fixLibraryAndFunctionIn: dictionaryToFix.

	(aFileReference parent / 'updated_' , aFileReference basename)
		ensureDelete;
		writeStreamDo: [ :stream | stream nextPutAll: (NeoJSONWriter toString: dictionaryToFix) ]
]

{ #category : 'instance creation' }
TagsJsonReader >> readFrom: aFileReference [

	| dictionaryToFix |
	filename := aFileReference basename.
	dictionaryToFix := (NeoJSONReader on: aFileReference readStream) next.
	self read: dictionaryToFix.

	^ dictionaryToFix
]

{ #category : 'as yet unclassified' }
TagsJsonReader >> tagEntitiesFrom: startPos to: endPos with: tag [

	| entities modelTag |
	entities := (model allUsing: FamixTFileAnchor) select: [
		            :sourceAnchor |
		            sourceAnchor startLine >= (startPos asInteger) and: [
			            sourceAnchor endLine <= (endPos asInteger) ] ].

	"retunr a tag or create if not found"
	modelTag := model tagNamed: tag.

	entities do: [ :entity | entity element tagWith: modelTag ]
]

{ #category : 'as yet unclassified' }
TagsJsonReader >> tagImports [

	| modelImports modelTag |
	modelImports := model allImports.
	
	"retunr a tag or create if not found"
	modelTag := model tagNamed: 'Library Loading'.

	modelImports do: [ :entity | entity tagWith: modelTag ] 
]
