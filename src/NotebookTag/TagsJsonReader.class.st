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

{ #category : 'instance creation' }
TagsJsonReader >> readFrom: aFileReference [ 
	| reader |

	filename := aFileReference basename. 
	reader := NeoJSONReader on: aFileReference readStream.
	self read: reader next.
	reader close.


	
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
