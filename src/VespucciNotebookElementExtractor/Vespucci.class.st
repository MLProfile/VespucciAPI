"
# Vespucci Builder
This class handle the parsing, model building and notebookElement extraction and upload.
The whole process can be launched with a class side method.

This class use some other classes :

- ColombusClient => to retrieve and send information to the python api / db
- TroisQuatorze  => for pattern recognition and tagging. 

## Usage 
(cannot be used alone anymore)

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
This is the json output format (not handled in this class anymore)

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
		'profileName',
		'newProfileId'
	],
	#category : 'VespucciNotebookElementExtractor',
	#package : 'VespucciNotebookElementExtractor'
}

{ #category : 'as yet unclassified' }
Vespucci class >> runForNotebook: aNotebookId fromProject: aProjectId withProfileNamed: aString [

	^ self new
		  notebookId: aNotebookId;
		  projectId: aProjectId;
		  profileName: aString;
		  launchProcess;
		  yourself
]

{ #category : 'as yet unclassified' }
Vespucci class >> wipfromApiComputeNotebookId: aNotebookId fromProject: aProjectId withProfileName: aString [
	"Auto build the famix model from sources downloaded on the api"

	^ self new
		  notebookId: aNotebookId;
		  projectId: aProjectId;
		  profileName: aString;
		  downloadAndBuildFamixModel;
		  buildFamixModelWithAttributes;
		  exportToJSON;
		  exportWithPatternProcessor;
		  postExportOnApi;
		  yourself
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
Vespucci >> exportToJSON [
	"We need to run self buildFamixModelWithAttributes first. The result is a tagged model with the informations we need
	 We then export this model in json on localfileReference"

	localfileReference writeStreamDo: [ :aStream |
		taggedModel exportToJSONStream: aStream ].
	^ localfileReference
]

{ #category : 'as yet unclassified' }
Vespucci >> exportWithPatternProcessor [

	| processor factory |
	processor := SGProcessor new.
	processor
		taggedModel: taggedModel
		jsonFile: localfileReference
		notebookName: notebookName.

	processor addPattern: ImportPattern new.
	processor addPattern: InvocationPattern new.
"	processor addPattern: InvocationPatternWithAttr new."

	factory := SGTemplateFactory initializeWithClient: colombusClient.
	(factory buildTemplatesFromDbForPattern: (Dictionary new
			  at: 'sg_type_name' put: 'Invocation';
			  at: 'project_id' put: self projectId;
			  yourself)) do: [ :tpl | processor tagger addTemplate: tpl ].
"	(factory buildTemplatesFromDbForPattern: (Dictionary new
			  at: 'sg_type_name' put: 'InvocationAndAttributes';
			  at: 'project_id' put: self projectId;
			  yourself)) do: [ :tpl | processor tagger addTemplate: tpl ]."


	processor tagger addTemplate: (SGTemplate new
			 name: 'ImportGeneric';
			 tag: 'Library Loading';
			 priority: 0;
			 matchBlock: [ :d | (d at: 'FM3') = 'Famix-Python-Entities.Import' ]).

	exports := processor extractTaggedSubGraphs
]

{ #category : 'accessing' }
Vespucci >> exports [

	^ exports
]

{ #category : 'accessing' }
Vespucci >> exports: anObject [

	exports := anObject
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
Vespucci >> launchProcess [
	"We start by pulling the python code from the api and build the python famix model"
	self downloadAndBuildFamixModel.
	"On the previously built model we compute and assign attributes in the model"
	self buildFamixModelWithAttributes.
	"We export the model with attribute to json temp file"
	self exportToJSON.
	"Pattern recognition process on exported json + tagging"
	self exportWithPatternProcessor.
	"Post the resulting found pattern on api "
	self postExportOnApi
]

{ #category : 'accessing' }
Vespucci >> newProfileId [

	^ newProfileId
]

{ #category : 'accessing' }
Vespucci >> newProfileId: anObject [

	newProfileId := anObject
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
Vespucci >> postExportOnApi [
	"After calling self exportImport or exportInvocations we can post those entities to the Colombus api"

	| fullProfileModel res content |

	fullProfileModel := ApiModelFullProfile new.
	fullProfileModel famix_model:  (NeoJSONReader fromString: localfileReference contents). 
	fullProfileModel notebook_id: notebookId.
	fullProfileModel project_id: projectId.
	fullProfileModel name: profileName. 
	fullProfileModel sous_graphs: exports.
	fullProfileModel compositions: compositions.
	
	res := colombusClient createFullProfile: fullProfileModel.
	content := res contents. 
	newProfileId := content id.

	^ content

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
