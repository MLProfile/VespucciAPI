"
# Vespucci Builder

this class can retrive a notebook python code from Colombus API, build a FamixPythonModel with it and exports all the founded elements in this model either throught api or json.  

## Usage 
You will need a Colombus project id and a notebook Id.

To post all the elements throught API :
```language=Pharo
jsonExport := Vespucci fromApiComputeNotebookId: 'b03ac816-17b0-435d-9062-89f3d65b51f3' fromProject: '4f2b506d-0817-4b73-bcef-247f77d63985'. 
```
If you want the json export :
```language=Pharo
jsonExport := Vespucci fromApiExportAsJsonNotebookId: 'b03ac816-17b0-435d-9062-89f3d65b51f3' fromProject: '4f2b506d-0817-4b73-bcef-247f77d63985'.
```
## Export format 
```language=Json
{
  ""sous_graphs"": [
	{
      ""line_end"": int,
      ""library"": string,
      ""notebook_id"": uuid,
      ""type_sg_id"": uuid,
      ""function"": string,
      ""value"": { Famix subgraph json export},
      ""pos_end"": string,
      ""line_start"": int,
      ""step_name"": string,
      ""source"": string,
      ""pos_start"": string
    }
	],
  ""json_profile"": {},
  ""notebook_id"": uuid,
  ""project_id"": uuid,
  ""name"": string,
  ""compositions"": [
    {
      ""components"": [
        {
      		 ""line_end"": int,
          ""library"": string,
          ""notebook_id"": uuid,
          ""type_sg_id"": uuid,
          ""function"": string,
          ""value"": { Famix subgraph json export},
          ""pos_end"": string,
          ""line_start"": int,
          ""step_name"": string,
          ""source"": string,
          ""pos_start"": string
        }
      ],
      ""composite"": {
         ""line_end"": int,
         ""library"": string,
         ""notebook_id"": uuid,
         ""type_sg_id"": uuid,
         ""function"": string,
         ""value"": { Famix subgraph json export},
         ""pos_end"": string,
         ""line_start"": int,
         ""step_name"": string,
         ""source"": string,
         ""pos_start"": string
      }
}
```
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
		'compositions',
		'profileName'
	],
	#category : 'VespucciNotebookElementExtractor',
	#package : 'VespucciNotebookElementExtractor'
}

{ #category : 'as yet unclassified' }
Vespucci class >> fromApiComputeNotebookId: aNotebookId fromProject: aProjectId [
	"Auto build the famix model from sources downloaded on the api"

	^ self new
		  notebookId: aNotebookId;
		  projectId: aProjectId;
		  downloadAndBuildFamixModel;
		  buildFamixModelWithAttributes;
		  exportToJSON;
		  exportImports;
		  exportInvocations;
		  postExportOnApi;
		  yourself
]

{ #category : 'as yet unclassified' }
Vespucci class >> fromApiComputeNotebookId: aNotebookId fromProject: aProjectId withProfileName: aString [
	"Auto build the famix model from sources downloaded on the api"

	^ self new
		  notebookId: aNotebookId;
		  projectId: aProjectId;
		  profileName: aString;
		  downloadAndBuildFamixModel;
		  buildFamixModelWithAttributes;
		  exportToJSON;
		  exportImports;
		  exportInvocations;
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
			  exportToJSON;
			  exportImports;
			  exportInvocations;
			  postExportJsonTo: stream;
			  yourself ]
]

{ #category : 'as yet unclassified' }
Vespucci class >> fromApiExportAsJsonNotebookId: aNotebookId fromProject: aProjectId withProfileName: aString [
	"Auto build the famix model from sources downloaded on the api"

	^ String streamContents: [ :stream |
		  self new
			  notebookId: aNotebookId;
			  projectId: aProjectId;
			  profileName: aString;
			  downloadAndBuildFamixModel;
			  buildFamixModelWithAttributes;
			  exportToJSON;
			  exportImports;
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
Vespucci >> buildExportImportFor: aFamixImport withJson: jsonDict [

	| exportObject lineStart lineEnd lineSource startPos endPos funcSource sgTypeId |
	
	"Récupération des informations sources"
	lineStart := aFamixImport sourceAnchor startLine.
	lineEnd   := aFamixImport sourceAnchor endLine.
	lineSource := aFamixImport sourceAnchor sourceText.
	startPos  := aFamixImport sourceAnchor startPos asString.
	endPos    := aFamixImport sourceAnchor endPos asString.


	"Récupération du type SG"
	sgTypeId := colombusClient getSgTypeIdByValue: (jsonDict at: 'FM3').

	"Construction de l'objet"
	exportObject := ApiModelNbElmntAndSg new.
	exportObject type_sg_id: sgTypeId;
	             notebook_id: notebookId;
	             step_name: 'import';
	             value: jsonDict.
	

	exportObject
		source: lineSource; 
		line_start: lineStart;
		line_end: lineEnd;
		pos_start: startPos;
		pos_end: endPos;
		library: (jsonDict at: 'package');
		function: (jsonDict at: 'importOf').

	^ exportObject
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
	"From the builded model in self downloadAndBuildFamixModel, we assign some tags on imports and invocations 
	to keep informations when we will export this model in json."

	| model |
	model := taggedModel.

	model allImports do: [ :i |
		i importedEntity
			ifNotNil: [
				i importOf: i importedEntity name.
				i package: i importedEntity libraryName ]
			ifNil: [
				1 halt.
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
	"We dowload the python source code of notebookId from projectId and create the corresponding FamixPythonModel"

	| fileReference |
	fileReference := colombusClient
		                 fromProjectId: projectId
		                 downloadNotebookId: notebookId.
	notebookName := fileReference basenameWithoutExtension.
	taggedModel := FamixPythonImporter import: fileReference
]

{ #category : 'as yet unclassified' }
Vespucci >> exportComposition: aMooseGroup [

	| famixInvocation compositeExport compositeDict componentsExports element isExportable |

	"On prend la première invocation pour constituer la partie 'composite'"
	famixInvocation := aMooseGroup first.

	compositeExport := self buildExportObjectFor: famixInvocation 
	                                   withJson: (self jsonForInvocation: famixInvocation).

	compositeDict := compositeExport asDictionary.

	"Déterminer si on exporte ou pas"
	isExportable := self shouldExport: famixInvocation.

	"On a gerer cette entite on peut donc l'ajouter a la liste"
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
Vespucci >> exportImports [

	| jsonImports modelImport toExport importingEntity isExportable |
	jsonImports := self allImportInAJsonExportedModel: localfileReference.
	modelImport := taggedModel allImports.


	jsonImports do: [ :i |
		| famixImport |
		famixImport := self importsMatchingJson: i in: modelImport.

		"In the case we analyse simultanously multiple source, we want to keep only the imports from the notebook"
		"Refactoring needed, notebook name should be nullable and if not present we want all the entities"
		importingEntity := famixImport first importingEntity name.
		isExportable := notebookName = importingEntity.

		toExport := self buildExportImportFor: famixImport first withJson: i.

		isExportable ifTrue: [ exports add: toExport asDictionary ] ]
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
				self exportComposition: composedInvoc
			]
			ifFalse: [
				"Traitement normal d’une invocation simple"
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
Vespucci >> exportToJSON [
	"We need to run self buildFamixModelWithAttributes first. The result is a tagged model with the informations we need
	 We then export this model in json on localfileReference"

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

{ #category : 'as yet unclassified' }
Vespucci >> importsMatchingJson: aJson in: modelImports [

	^ modelImports select: [ :importEntity |
		  importEntity sourceAnchor startPos asString
		  = (aJson at: 'startPos') and: [
			  importEntity sourceAnchor endPos asString = (aJson at: 'endPos') ] ]
]

{ #category : 'initialization' }
Vespucci >> initialize [ 

	colombusClient := ColombusClient createClientFromConfFile: '.conf'.
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
	fullProfileModel name: profileName. 

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
	fullProfileModel name: profileName. 
	fullProfileModel sous_graphs: exports.
	fullProfileModel compositions: compositions.

	^colombusClient createFullProfile: fullProfileModel.
	

]

{ #category : 'accessing' }
Vespucci >> profileName [

	^ profileName
]

{ #category : 'accessing' }
Vespucci >> profileName: anObject [

	profileName := anObject
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
"Si l'entité ne vient pas directement du notebook (ex: si l'on a un nb et des sources de lib)
ou si l'on a deja vu l'entitié (ex: dans le cas des compositions on traite toutes les entités d'une ligne).
Dans ces deux cas pour eviter les doublon et ne pas polluer l'export => false.
"

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
