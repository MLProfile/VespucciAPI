"
## Usage 

pythonModelA := FamixPythonImporter import: '/Users/mignard/Documents/work/mooseDemo/student_a' asFileReference.

taggedModelA := TagsJsonReader new model: pythonModelA; yourself .
taggedModelA readFrom: '/Users/mignard/Documents/work/mooseDemo/student_a/profile_labels_export_tp_student_A.json' asFileReference.
modelA := taggedModelA model.


vsp := Vespucci new.
vsp notebookId: 1.
vsp taggedModel: modelA.
vsp buildFamixModelWithAttributes: modelA .
vsp exportToJSON: modelA.
vsp postImports 
"
Class {
	#name : 'Vespucci',
	#superclass : 'Object',
	#instVars : [
		'colombusClient',
		'notebookId',
		'sgType',
		'localfileReference',
		'taggedModel',
		'notebookName',
		'projectId',
		'exports',
		'seenEntities',
		'compositions'
	],
	#category : 'NotebookTag',
	#package : 'NotebookTag'
}

{ #category : 'as yet unclassified' }
Vespucci class >> fromApiComputeNotebookId: aNotebookId fromProject: aProjectId [
	"Auto build the famix model from sources downloaded on the api"

	^ self new
		  notebookId: aNotebookId;
		  projectId: aProjectId;
		  downloadAndBuildFamixModel;
		  buildFamixModelWithAttributes;
		  "Now we want to upload this json to the colombus api"exportToJSON;
		  exportImportsTo;
		  exportInvocationsTo;
		  postExportOnApi;
		  yourself
]

{ #category : 'as yet unclassified' }
Vespucci class >> fromApiExportAsJsonNotebookId: aNotebookId fromProject: aProjectId [
	"Auto build the famix model from sources downloaded on the api"

	^ String streamContents: [ :stream |
		  self new
			  notebookId: aNotebookId;
			  projectId: aProjectId;
			  downloadAndBuildFamixModel;
			  buildFamixModelWithAttributes;
			  "Now we want to upload this json to the colombus api"
				  exportToJSON;
			  exportImportsTo;
			  exportInvocationsTo;
			  postExportJsonTo: stream;
			  yourself ]
]

{ #category : 'as yet unclassified' }
Vespucci class >> fromApiExportAsJsonNotebookIdRefactored: aNotebookId fromProject: aProjectId [
	"Auto build the famix model from sources downloaded on the api"

	^ String streamContents: [ :stream |
		  self new
			  notebookId: aNotebookId;
			  projectId: aProjectId;
			  downloadAndBuildFamixModel;
			  buildFamixModelWithAttributes;
			  "Now we want to upload this json to the colombus api"
				  exportToJSON;
			  exportImportsTo; "Need refacto"
			  exportInvocations;
			  postExportJsonTo: stream;
			  yourself ]
]

{ #category : 'as yet unclassified' }
Vespucci >> allImportInAJsonExportedModel: aFileReference [
"Return each import found in the json"

| export |
export := (NeoJSONReader on: aFileReference readStream) next.
^export select: [ :e | (e at:'FM3' ifAbsent: [  ]) = 'Famix-Python-Entities.Import' ] 
]

{ #category : 'as yet unclassified' }
Vespucci >> allInvocationInAJsonExportedModel: aFileReference [
"Return each Invocation found in the json"

| export |
export := (NeoJSONReader on: aFileReference readStream) next.
^export select: [ :e | (e at:'FM3' ifAbsent: [  ]) = 'Famix-Python-Entities.Invocation' ] 
]

{ #category : 'as yet unclassified' }
Vespucci >> buildExportObjectFor: aFamixInvocation withJson: jsonDict [
	"Construit et renvoie un ApiModelNbElmntAndSg configuré 
	en fonction de l'invocation aFamixInvocation et du dictionnaire jsonDict."

	| exportObject lineStart lineEnd lineSource startPos endPos funcSource sgTypeId |
	
	"Récupération des informations sources"
	lineStart := aFamixInvocation sourceAnchor startLine.
	lineEnd   := aFamixInvocation sourceAnchor endLine.
	lineSource := aFamixInvocation sourceAnchor sourceText.
	startPos  := aFamixInvocation sourceAnchor startPos asString.
	endPos    := aFamixInvocation sourceAnchor endPos asString.

	"Extraction de la source complète si pas un stub"
	funcSource := nil.
	aFamixInvocation candidates first isStub ifFalse: [
		funcSource := aFamixInvocation candidates first sourceText
	].

	"Récupération du type SG"
	sgTypeId := colombusClient getSgTypeIdByValue: (jsonDict at: 'FM3').

	"Construction de l'objet"
	exportObject := ApiModelNbElmntAndSg new.
	exportObject type_sg_id: sgTypeId;
	             notebook_id: notebookId;
	             step_name: 'other';
	             value: jsonDict.
	funcSource 
		ifNotNil: [ exportObject source: funcSource , String cr , lineSource ]
		ifNil:    [ exportObject source: lineSource ].

	exportObject
		line_start: lineStart;
		line_end: lineEnd;
		pos_start: startPos;
		pos_end: endPos;
		library: (jsonDict at: 'library');
		function: (jsonDict at: 'function').

	^ exportObject
]

{ #category : 'as yet unclassified' }
Vespucci >> buildFamixModelWithAttributes [

	| model |
	model := taggedModel. "Surtout pas de copie ici pour le coup"

	model allImports do: [ :i |
		i importedEntity
			ifNotNil: [
				i importOf: i importedEntity name.
				i package: i importedEntity libraryName ]
			ifNil: [
				1halt.
				i importOf: 'parse_error'.
				i package: 'parse_error' ].

		i startPos: i sourceAnchor startPos asString.
		i endPos: i sourceAnchor endPos asString ].

	self flag: #todo.
	"If we have a shadowing entity, candidtes may be multiple we should probably check"
	"We also need to find a way to get the parent package of this candidate"
	"See with cyril, will be good in some time"
	model allInvocations do: [ :i |
		i function: i candidates first name.
		i arguments: i computeArgs asStringWithCr.
		i library: i computePackage asString.
		i startPos: i sourceAnchor startPos asString.
		i endPos: i sourceAnchor endPos asString ]
]

{ #category : 'accessing' }
Vespucci >> compositions [

	^ compositions
]

{ #category : 'accessing' }
Vespucci >> compositions: anObject [

	compositions := anObject
]

{ #category : 'accessing' }
Vespucci >> downloadAndBuildFamixModel [

	| fileReference |
	fileReference := colombusClient fromProjectId: projectId downloadNotebookId: notebookId.
	notebookName := fileReference basenameWithoutExtension.
	taggedModel := FamixPythonImporter import: fileReference.
]

{ #category : 'as yet unclassified' }
Vespucci >> exportComposition2: aMooseGroup [

	| famixInvocation compositeExport compositeDict componentsExports element isExportable |

	"On prend la première invocation pour constituer la partie 'composite'"
	famixInvocation := aMooseGroup first.

	compositeExport := self buildExportObjectFor: famixInvocation 
	                                   withJson: (self jsonForInvocation: famixInvocation).

	compositeDict := compositeExport asDictionary.

	"Déterminer si on exporte ou pas"
	isExportable := self shouldExport: famixInvocation.

	"On a gerer cette entite on peut donc l'ajouté a la liste"
	seenEntities add: famixInvocation mooseID.
	"On supprime l’invocation principale du group pour gérer ensuite les composantes"
	aMooseGroup remove: famixInvocation.

	"Construction du dictionnaire d’entourage"
	componentsExports := aMooseGroup collect: [:each |
		| compExport |
		compExport := self buildExportObjectFor: each withJson: (self jsonForInvocation: each).
		seenEntities add: each mooseID.
		compExport asDictionary
	].

	"On regroupe tout cela dans un dictionnaire final"
	element := Dictionary new
		at: #composite put: compositeDict;
		at: #components put: componentsExports asOrderedCollection;
		yourself.

	isExportable ifTrue: [
		compositions add: element
	].

]

{ #category : 'as yet unclassified' }
Vespucci >> exportComposition: aMooseGroup [
	"Here we will add all the items to export and there positions in compositions"

	| element json_invoc lineStart famixInvocation lineEnd funcSource sender isExportable lineSource startPos endPos sgTypeId toExport components_exports index |
	famixInvocation := aMooseGroup first.
	startPos := famixInvocation sourceAnchor startPos asString.
	endPos := famixInvocation sourceAnchor endPos asString.


	json_invoc := self
		              invocationInAJsonExportedModel: localfileReference
		              withStartPos: startPos
		              andEndPos: endPos.

	json_invoc := json_invoc first.
	lineStart := famixInvocation sourceAnchor startLine.
	lineEnd := famixInvocation sourceAnchor endLine.
	funcSource := nil.
	famixInvocation candidates first isStub ifFalse: [
		funcSource := famixInvocation candidates first sourceText ].

	sender := famixInvocation sender name.
	isExportable := notebookName = sender.
	index := seenEntities indexOf: famixInvocation mooseID.
	index = 0 ifFalse: [ isExportable := false ].

	seenEntities add: famixInvocation mooseID.
	lineSource := famixInvocation sourceAnchor sourceText.


	sgTypeId := colombusClient getSgTypeIdByValue: (json_invoc at: 'FM3').
	toExport := ApiModelNbElmntAndSg new.
	toExport type_sg_id: sgTypeId.
	toExport notebook_id: notebookId.
	toExport step_name: 'other'.
	toExport value: json_invoc.
	funcSource
		ifNotNil: [ toExport source: funcSource , '\n ' , lineSource ]
		ifNil: [ toExport source: lineSource ].
	toExport line_start: lineStart.
	toExport line_end: lineEnd.
	toExport pos_start: startPos.
	toExport pos_end: endPos.
	toExport library: (json_invoc at: 'library').
	toExport function: (json_invoc at: 'function').


	element := Dictionary new.
	element at: #composite put: toExport asDictionary.


	components_exports := OrderedCollection new.
	aMooseGroup remove: famixInvocation.

	aMooseGroup do: [ :i |
		startPos := i sourceAnchor startPos asString.
		endPos := i sourceAnchor endPos asString.


		json_invoc := self
			              invocationInAJsonExportedModel: localfileReference
			              withStartPos: startPos
			              andEndPos: endPos.

		json_invoc := json_invoc first.
		lineStart := i sourceAnchor startLine.
		lineEnd := i sourceAnchor endLine.
		funcSource := nil.
		i candidates first isStub ifFalse: [
			funcSource := i candidates first sourceText ].

		seenEntities add: i mooseID.

		lineSource := i sourceAnchor sourceText.


		sgTypeId := colombusClient getSgTypeIdByValue:
			            (json_invoc at: 'FM3').
		toExport := ApiModelNbElmntAndSg new.
		toExport type_sg_id: sgTypeId.
		toExport notebook_id: notebookId.
		toExport step_name: 'other'.
		toExport value: json_invoc.
		funcSource
			ifNotNil: [ toExport source: funcSource , '\n ' , lineSource ]
			ifNil: [ toExport source: lineSource ].
		toExport line_start: lineStart.
		toExport line_end: lineEnd.
		toExport pos_start: startPos.
		toExport pos_end: endPos.
		toExport library: (json_invoc at: 'library').
		toExport function: (json_invoc at: 'function').

		seenEntities add: i mooseID.
		components_exports add: toExport asDictionary ].




	element at: #components put: components_exports.

	isExportable ifTrue: [ compositions add: element ]
]

{ #category : 'as yet unclassified' }
Vespucci >> exportImportsTo [

	| jsonImports modelImport lineStart lineEnd sgTypeId lineSource toExport startPos endPos importingEntity isExportable |
	jsonImports := self allImportInAJsonExportedModel: localfileReference.
	modelImport := taggedModel allImports.


	jsonImports do: [ :i |
		| famixImport |
		famixImport := modelImport select: [ :importEntity |
			               importEntity sourceAnchor startPos asString
			               = (i at: 'startPos') and: [
				               importEntity sourceAnchor endPos asString
				               = (i at: 'endPos') ] ].
		"We can have multiple entities in the same sourceAnchors pos but the tag will be the same so I just lookup for the firstone"
		"tag := famixImport first tags first name."
		"tagId := colombusClient getStepIdByName: tag."
		lineStart := famixImport first sourceAnchor startLine.
		lineEnd := famixImport first sourceAnchor endLine.
		lineSource := famixImport first sourceAnchor sourceText.
		startPos := famixImport first sourceAnchor startPos asString.
		endPos := famixImport first sourceAnchor endPos asString.

		"In the case we analyse simultanously multiple source, we want to keep only the imports from the notebook"
		"Refactoring needed, notebook name should be nullable and if not present we want all the entities"
		importingEntity := famixImport first importingEntity name.
		isExportable := notebookName = importingEntity.

		sgTypeId := colombusClient getSgTypeIdByValue: (i at: 'FM3').
		toExport := ApiModelNbElmntAndSg new.
		toExport type_sg_id: sgTypeId.
		toExport notebook_id: notebookId.
		toExport step_name: 'import'.
		toExport value: i.
		toExport source: lineSource.
		toExport line_start: lineStart.
		toExport line_end: lineEnd.
		toExport pos_start: startPos.
		toExport pos_end: endPos.
		toExport library: (i at: 'package').
		toExport function: (i at: 'importOf').

		isExportable ifTrue: [ exports add: toExport asDictionary ] ].

"	^ jsonImports"
]

{ #category : 'as yet unclassified' }
Vespucci >> exportImportsTo: aStream [

	| jsonImports modelImport tag tagId lineStart lineEnd sgTypeId lineSource toExport jsonString first startPos endPos importingEntity isExportable |
	jsonImports := self allImportInAJsonExportedModel: localfileReference.
	modelImport := taggedModel allImports.

	aStream nextPutAll: '['.
	first := true.
	jsonImports do: [ :i |
		| famixImport |
		famixImport := modelImport select: [ :importEntity |
			               importEntity sourceAnchor startPos asString
			               = (i at: 'startPos') and: [
				               importEntity sourceAnchor endPos asString
				               = (i at: 'endPos') ] ].
		"We can have multiple entities in the same sourceAnchors pos but the tag will be the same so I just lookup for the firstone"
		"tag := famixImport first tags first name."
		"tagId := colombusClient getStepIdByName: tag."
		lineStart := famixImport first sourceAnchor startLine.
		lineEnd := famixImport first sourceAnchor endLine.
		lineSource := famixImport first sourceAnchor sourceText.
		startPos := famixImport first sourceAnchor startPos asString.
		endPos := famixImport first sourceAnchor endPos asString.

		"In the case we analyse simultanously multiple source, we want to keep only the imports from the notebook"
		"Refactoring needed, notebook name should be nullable and if not present we want all the entities"
		importingEntity := famixImport first importingEntity name.
		isExportable := notebookName = importingEntity.

		sgTypeId := colombusClient getSgTypeIdByValue: (i at: 'FM3').
		toExport := ApiModelNbElmntAndSg new.
		toExport type_sg_id: sgTypeId.
		toExport notebook_id: notebookId.
		toExport step_name: 'import'.
		toExport value: i.
		toExport source: lineSource.
		toExport line_start: lineStart.
		toExport line_end: lineEnd.
		toExport pos_start: startPos.
		toExport pos_end: endPos.
		toExport library: (i at: 'package').
		toExport function: (i at: 'importOf').

		isExportable ifTrue: [
			jsonString := NeoJSONWriter toString: toExport asDictionary.
			first ifFalse: [ aStream nextPut: $, ].
			aStream nextPutAll: jsonString.
			first := false ] ].

	^ jsonImports
]

{ #category : 'as yet unclassified' }
Vespucci >> exportInvocations [

	| jsonInvocations modelInvocations famixInvocation lineStart composedInvoc |

	jsonInvocations := self allInvocationInAJsonExportedModel: localfileReference.
	modelInvocations := taggedModel allInvocations.

	jsonInvocations do: [:json |
		| isExportable |
		
		
		famixInvocation := self invocationsMatchingJson: json 
		                             in: modelInvocations.
	
		lineStart := famixInvocation first sourceAnchor startLine.
	  composedInvoc := modelInvocations select: [ :i |
			                i sourceAnchor startLine = lineStart ].

		"S’il y a plusieurs invocations sur la même ligne, on gère la composition"
		(composedInvoc size > 1)
			ifTrue: [
				self exportComposition2: composedInvoc
			]
			ifFalse: [
				"3) Traitement normal d’une invocation simple"
				isExportable := self shouldExport: famixInvocation first.
				isExportable ifTrue: [
					seenEntities add: famixInvocation mooseID.
					exports add: (self buildExportObjectFor: famixInvocation first 
					                            withJson: json) asDictionary
				]
			].
	].

]

{ #category : 'as yet unclassified' }
Vespucci >> exportInvocationsTo [

	| lineStart jsonInvocation modelInvocations sgTypeId lineSource toExport startPos endPos lineEnd funcSource isExportable sender composedInvoc |
	jsonInvocation := self allInvocationInAJsonExportedModel:
		                  localfileReference.
	modelInvocations := taggedModel allInvocations.

	jsonInvocation do: [ :i |
		| famixInvocation |
		famixInvocation := modelInvocations select: [ :invocationEntity |
			                   invocationEntity sourceAnchor startPos asString
			                   = (i at: 'startPos') and: [
				                   invocationEntity sourceAnchor endPos asString
				                   = (i at: 'endPos') ] ].



		lineStart := famixInvocation first sourceAnchor startLine.
		lineEnd := famixInvocation first sourceAnchor endLine.
		funcSource := nil.
		famixInvocation first candidates first isStub ifFalse: [
			funcSource := famixInvocation first candidates first sourceText ].

		composedInvoc := modelInvocations select: [ :i |
			                 i sourceAnchor startLine = lineStart ].
		composedInvoc size > 1
			ifTrue: [ "Here we will probably want to post these elements one by one while keeping all the nnElmnt id's to build the composed one"
				self exportComposition: composedInvoc.
				isExportable := false ]
			ifFalse: [
				seenEntities add: famixInvocation mooseID. "To track seens entities to not post duplicate datas"

				"In the case we analyse simultanously multiple source, we want to keep only the invocations from the notebook"
				"Refactoring needed, notebook name should be nullable and if not present we want all the entities"
				sender := famixInvocation first sender name.
				isExportable := notebookName = sender ].


		lineSource := famixInvocation first sourceAnchor sourceText.
		startPos := famixInvocation first sourceAnchor startPos asString.
		endPos := famixInvocation first sourceAnchor endPos asString.

		sgTypeId := colombusClient getSgTypeIdByValue: (i at: 'FM3').
		toExport := ApiModelNbElmntAndSg new.
		toExport type_sg_id: sgTypeId.
		toExport notebook_id: notebookId.
		toExport step_name: 'other'.
		toExport value: i.
		funcSource
			ifNotNil: [ toExport source: funcSource , '\n ' , lineSource ]
			ifNil: [ toExport source: lineSource ].
		"	toExport source: lineSource."
		toExport line_start: lineStart.
		toExport line_end: lineEnd.
		toExport pos_start: startPos.
		toExport pos_end: endPos.
		toExport library: (i at: 'library').
		toExport function: (i at: 'function').

		isExportable ifTrue: [ exports add: toExport asDictionary ] ]
]

{ #category : 'as yet unclassified' }
Vespucci >> exportInvocationsTo: aStream [

	| tag tagId lineStart jsonInvocation modelInvocations sgTypeId lineSource toExport jsonString startPos endPos lineEnd funcSource isExportable sender |
	jsonInvocation := self allInvocationInAJsonExportedModel:
		                  localfileReference.
	modelInvocations := taggedModel allInvocations.

	jsonInvocation do: [ :i |
		| famixInvocation |
		famixInvocation := modelInvocations select: [ :invocationEntity |
			                   invocationEntity sourceAnchor startPos asString
			                   = (i at: 'startPos') and: [
				                   invocationEntity sourceAnchor endPos asString
				                   = (i at: 'endPos') ] ].

		"tag := famixInvocation first tags first name."
		"tagId := colombusClient getStepIdByName: tag."
		lineStart := famixInvocation first sourceAnchor startLine.
		lineEnd := famixInvocation first sourceAnchor endLine.
		funcSource := nil.
		famixInvocation first candidates first isStub ifFalse: [
			funcSource := famixInvocation first candidates first sourceText ].
		lineSource := famixInvocation first sourceAnchor sourceText.
		startPos := famixInvocation first sourceAnchor startPos asString.
		endPos := famixInvocation first sourceAnchor endPos asString.

		"In the case we analyse simultanously multiple source, we want to keep only the invocations from the notebook"
		"Refactoring needed, notebook name should be nullable and if not present we want all the entities"
		sender := famixInvocation first sender name.
		isExportable := notebookName = sender.

		"ToDo handle invocation composition"

		sgTypeId := colombusClient getSgTypeIdByValue: (i at: 'FM3').
		toExport := ApiModelNbElmntAndSg new.
		toExport type_sg_id: sgTypeId.
		toExport notebook_id: notebookId.
		toExport step_name: 'other'.
		toExport value: i.
		funcSource
			ifNotNil: [ toExport source: funcSource , '\n ' , lineSource ]
			ifNil: [ toExport source: lineSource ].
		"	toExport source: lineSource."
		toExport line_start: lineStart.
		toExport line_end: lineEnd.
		toExport pos_start: startPos.
		toExport pos_end: endPos.
		toExport library: (i at: 'library').
		toExport function: (i at: 'function').

		isExportable ifTrue: [
			jsonString := NeoJSONWriter toString: toExport asDictionary.
			aStream nextPut: $,.
			aStream nextPutAll: jsonString ] ].

	aStream nextPutAll: ']'.
	^ aStream
]

{ #category : 'as yet unclassified' }
Vespucci >> exportToJSON [
"We need to run self buildFamixModelWithAttributes first"

	localfileReference writeStreamDo: [ :aStream |
		taggedModel exportToJSONStream: aStream ].
	^ localfileReference
]

{ #category : 'accessing' }
Vespucci >> exports [

	^ exports
]

{ #category : 'accessing' }
Vespucci >> exports: anObject [

	exports := anObject
]

{ #category : 'as yet unclassified' }
Vespucci >> famixElementsByLine: aTaggedFamixPythonModel [

	| source dictionary model |
	model := aTaggedFamixPythonModel. "Besoin de faire une copy pour eviter de faire sauter le premier element d'un model (on l'enleve parce que c'est le module em lui meme)"
	source := (model allUsing: FamixTFileAnchor)
		          remove:
		          (model allUsing: FamixTFileAnchor) first.

	dictionary := Dictionary new.

	"Boucler sur tous les sourceAnchor de model et remplire le dictionnaire ligne->elmts"
	source do: [ :sourceAnchor | 
		(sourceAnchor startLine to: sourceAnchor endLine) do: [ :line |
			(dictionary at: line ifAbsentPut: [ OrderedCollection new ]) add:
				sourceAnchor ] ].

	^ dictionary
]

{ #category : 'initialization' }
Vespucci >> initialize [ 

	colombusClient := ColombusClient createClientWithUrl: 'http://127.0.0.1:8080/'.
	localfileReference := FileReference
		                      newTempFilePrefix: 'pythonModel-'
		                      suffix: '-export.json'.
	exports := OrderedCollection new.
	compositions := OrderedCollection new.
	seenEntities := OrderedCollection new.
]

{ #category : 'as yet unclassified' }
Vespucci >> invocationInAJsonExportedModel: aFileReference withStartPos: aStartPos andEndPos: aEndPos [
"Return each Invocation found in the json with the corresponding pos"

| export |
export := (NeoJSONReader on: aFileReference readStream) next.
^export select: [ :e | (e at:'FM3' ifAbsent: [  ]) = 'Famix-Python-Entities.Invocation' and: [((e at:'startPos' ifAbsent: [  ]) = aStartPos) and: [(e at:'endPos' ifAbsent: [  ]) = aEndPos  ] ]  ] 
]

{ #category : 'as yet unclassified' }
Vespucci >> invocationsMatchingJson: aJson in: modelInvocations [
    "Renvoie la collection de FamixInvocation dont 
    les startPos et endPos correspondent au dictionnaire JSON aJson."

    ^ modelInvocations select: [ :invocationEntity |
        (invocationEntity sourceAnchor startPos asString) = (aJson at: 'startPos')
          and: [
            (invocationEntity sourceAnchor endPos asString) = (aJson at: 'endPos')
          ]
    ]

]

{ #category : 'as yet unclassified' }
Vespucci >> jsonForInvocation: aFamixInvocation [
	| startPos endPos jsonResult |
	startPos := aFamixInvocation sourceAnchor startPos asString.
	endPos   := aFamixInvocation sourceAnchor endPos asString.

	jsonResult := self
		invocationInAJsonExportedModel: localfileReference
		withStartPos: startPos
		andEndPos: endPos.

	^ jsonResult first
]

{ #category : 'accessing' }
Vespucci >> notebookId [

	^ notebookId
]

{ #category : 'accessing' }
Vespucci >> notebookId: anObject [

	notebookId := anObject
]

{ #category : 'accessing' }
Vespucci >> notebookName [

	^ notebookName
]

{ #category : 'accessing' }
Vespucci >> notebookName: astring [

	notebookName := astring
]

{ #category : 'as yet unclassified' }
Vespucci >> postExportJsonTo: aStream [
	"After calling self exportImport or exportInvocations we can post those entities to the Colombus api"

	| fullProfileModel jsonString |
	fullProfileModel := ApiModelFullProfile new.
	fullProfileModel notebook_id: notebookId.
	fullProfileModel project_id: projectId.
	fullProfileModel name: notebookName. "ToDo: We will want another name here"
	1halt.
	fullProfileModel sous_graphs: exports.
	fullProfileModel compositions: compositions.

	jsonString := NeoJSONWriter toString: fullProfileModel asDictionary.
	aStream nextPutAll: jsonString
]

{ #category : 'as yet unclassified' }
Vespucci >> postExportOnApi [
	"After calling self exportImport or exportInvocations we can post those entities to the Colombus api"

	| fullProfileModel |
	fullProfileModel := ApiModelFullProfile new.
	fullProfileModel notebook_id: notebookId.
	fullProfileModel project_id: projectId.
	fullProfileModel name: notebookName. "ToDo: We will want another name here"
	fullProfileModel sous_graphs: exports.
	fullProfileModel compositions: compositions.

	colombusClient createFullProfile: fullProfileModel
]

{ #category : 'accessing' }
Vespucci >> projectId [

	^ projectId
]

{ #category : 'accessing' }
Vespucci >> projectId: aString [

	projectId := aString
]

{ #category : 'asserting' }
Vespucci >> shouldExport: aFamixInvocation [
	| sender index |
	sender := aFamixInvocation sender name.
	index  := seenEntities indexOf: aFamixInvocation mooseID.

	^(notebookName = sender) and: [ index = 0 ]

]

{ #category : 'accessing' }
Vespucci >> taggedModel [

	^ taggedModel 
]

{ #category : 'accessing' }
Vespucci >> taggedModel: aFamixPythonTaggedModel [

	taggedModel := aFamixPythonTaggedModel
]
