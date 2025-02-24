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
		'taggedModel'
	],
	#category : 'NotebookTag',
	#package : 'NotebookTag'
}

{ #category : 'as yet unclassified' }
Vespucci class >> uploadAndComputeNotebookWithId: aNotebookId fromTaggedModel: aFamixPythonTaggedModel [
	"Here we want a famix python model tagged with TagsJSonReader
pythonModelA := FamixPythonImporter import: '/Users/mignard/Documents/work/mooseDemo/student_a' asFileReference.

taggedModelA := TagsJsonReader new model: pythonModelA; yourself .
taggedModelA readFrom: '/Users/mignard/Documents/work/mooseDemo/student_a/profile_labels_export_tp_student_A.json' asFileReference.
modelA := taggedModelA model.
"

	^ self new
		  notebookId: aNotebookId;
		  taggedModel: aFamixPythonTaggedModel;
		  buildFamixModelWithAttributes;
		  exportToJSON;
		  postImports;
		  postInvocations;
		  yourself
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
Vespucci >> buildFamixModelWithAttributes [

	| model |
	model := taggedModel. "Surtout pas de copie ici pour le coup"

	model allImports do: [ :i |
		i importOf: i importedEntity name.
		i package: (i importedEntity libraryName).
		i startPos: i sourceAnchor startPos asString.
		i endPos: i sourceAnchor endPos asString ].

	self flag: #todo.
	"If we have a shadowing entity, candidtes may be multiple we should probably check"
	"We also need to find a way to get the parent package of this candidate"
	"See with cyril, will be good in some time"
	model allInvocations do: [ :i |
		i function: i candidates first name.
		i arguments: i computeArgs asStringWithCr.
		i startPos: i sourceAnchor startPos asString.
		i endPos: i sourceAnchor endPos asString ]
]

{ #category : 'as yet unclassified' }
Vespucci >> checkForInconsistancy: aNbElmtId onTag: aTagId [
	"When we create a new nbElmt we should check if others nbElmt exists with the same SG but a different step"

	| inconsistencies currentNb inconsistantNb inconsistency |
	inconsistencies := colombusClient
		                   findIconsistencyOnElmt: aNbElmtId
		                   nbId: notebookId.
	self flag: 'check if inconsistencies size can be > 1'.
	inconsistencies ifNotEmpty: [ "If we have inconsistencies we need to create them in db""Creation of an inconsistency with a name""Creation of two inconsistency element with previous inconsistency id and nbElmt id"
		inconsistency := ColombusModelInconsistancyS new.
		inconsistency description: 'Detected inconsistency during notebook import'.


		currentNb := {
			             (#idnb -> notebookId).
			             (#idelmt -> aNbElmtId).
			             (#step_id -> aTagId) }.
		inconsistency elements: currentNb asDictionary.
		inconsistencies do: [ :i |
			inconsistency elements: {
					(#idnb -> (i at: 'idnb')).
					(#idelmt -> (i at: 'idelmt')).
					(#step_id -> (i at: 'laststep_id')) } asDictionary ].

		colombusClient createIconsistencyS: inconsistency.
		self inform: 'Inconsistency detected' ]
]

{ #category : 'as yet unclassified' }
Vespucci >> exportToJSON [
"We need to run self buildFamixModelWithAttributes first"

	localfileReference writeStreamDo: [ :aStream |
		taggedModel exportToJSONStream: aStream ].
	^ localfileReference
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

	colombusClient := ColombusClient createClientWithUrl: 'http://127.0.0.1:8000/'.
	localfileReference := FileReference
		                      newTempFilePrefix: 'pythonModel-'
		                      suffix: '-export.json'.
]

{ #category : 'accessing' }
Vespucci >> notebookId [

	^ notebookId
]

{ #category : 'accessing' }
Vespucci >> notebookId: anObject [

	notebookId := anObject
]

{ #category : 'as yet unclassified' }
Vespucci >> postFamixSg: anEntityDict [
	"We want a line by line dictionnary of model entities : self famixElementsByLine"

	| value tagId sgId notebookElmt elmtID sgType |
	anEntityDict keysAndValuesDo: [ :key :collec |
		collec do: [ :fElment |
			| elem tag source sgFamix |
			elem := fElment element.
			tag := elem tags first name.
			tagId := colombusClient getStepIdByName: tag.
			source := elem sourceText.

			"Now here we need to check if this SG exist"
			sgFamix := ColombusModelSg new.
			self flag: #TODO.
			1 halt.
			"We actually need to call the api to get the current id of the sgType of the current entity"
			sgType := 1. "This value mean nothing"
			sgFamix typesgId: sgType. "Actual string value type"
			sgFamix value: (Dictionary new
					 at: 'source' put: source;
					 yourself).

			value := colombusClient findSgFamix: sgFamix.
			colombusClient client isSuccess
				ifTrue: [ sgId := value at: 'id' ]
				ifFalse: [
					| req code |
					req := colombusClient client.
					code := req response statusLine code.

					code = 404 ifFalse: [
						Error signal: 'HTTP: ' , code asString , ' during api call'
						"Probably a server side error , should not appen" ].
					sgId := (colombusClient createSgFamix: sgFamix) at: 'id' ]. "here we need to create a new sg"

			notebookElmt := ColombusModelNbElmt new
				                notebookId: notebookId;
				                sousgraphfamix_id: sgId;
				                stepId: tagId;
				                linestart: key;
				                lineend: key;
				                yourself.
			elmtID := (colombusClient createNbElmt: notebookElmt) at: 'idelmt'.
			self checkForInconsistancy: elmtID onTag: tagId ] ]
]

{ #category : 'as yet unclassified' }
Vespucci >> postImports [

	| jsonImports modelImport tag tagId lineStart lineEnd sgFamix value sgId notebookElmt elmtID sgTypeId |
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
		tag := famixImport first tags first name.
		tagId := colombusClient getStepIdByName: tag.
		lineStart := famixImport first sourceAnchor startLine.
		lineEnd := famixImport first sourceAnchor endLine.

		"Now here we need to check if this SG exist"
		sgFamix := ColombusModelSg new.
		sgTypeId := colombusClient getSgTypeByValue: (i at: 'FM3').
		sgFamix typesgId: sgTypeId.
		i removeKey: 'id' ifAbsent: [  ].
		i removeKey: 'endPos' ifAbsent: [  ].
		i removeKey: 'startPos' ifAbsent: [  ].
		i removeKey: 'importedEntity' ifAbsent: [  ].
		i removeKey: 'importingEntity' ifAbsent: [  ].
		i removeKey: 'allTagAssociations' ifAbsent: [  ].
		sgFamix value: i.

		value := colombusClient findSgFamix: sgFamix.
		colombusClient client isSuccess
			ifTrue: [ sgId := value at: 'id' ]
			ifFalse: [
				| req code |
				req := colombusClient client.
				code := req response statusLine code.

				code = 404 ifFalse: [
					Error signal: 'HTTP: ' , code asString , ' during api call'
					"Probably a server side error , should not appen" ].
				sgId := (colombusClient createSgFamix: sgFamix) at: 'id' ]. "here we need to create a new sg"

		notebookElmt := ColombusModelNbElmt new
			                notebookId: notebookId;
			                sousgraphfamix_id: sgId;
			                stepId: tagId;
			                linestart: lineStart;
			                lineend: lineEnd;
			                yourself.
		elmtID := (colombusClient createNbElmt: notebookElmt) at: 'idelmt'.
		self checkForInconsistancy: elmtID onTag: tagId].

	^ jsonImports
]

{ #category : 'as yet unclassified' }
Vespucci >> postInvocations [

	|  tag tagId lineStart lineEnd sgFamix value sgId notebookElmt elmtID jsonInvocation modelInvocations sgTypeId |
	jsonInvocation := self allInvocationInAJsonExportedModel: localfileReference.
	modelInvocations := taggedModel allInvocations.
	jsonInvocation do: [ :i |
		| famixInvocation |
		famixInvocation := modelInvocations select: [ :invocationEntity |
			               invocationEntity sourceAnchor startPos asString
			               = (i at: 'startPos') and: [
				               invocationEntity sourceAnchor endPos asString
				               = (i at: 'endPos') ] ].

		tag := famixInvocation first tags first name.
		tagId := colombusClient getStepIdByName: tag.
		lineStart := famixInvocation first sourceAnchor startLine.
		lineEnd := famixInvocation first sourceAnchor endLine.

		"Now here we need to check if this SG exist"
		sgFamix := ColombusModelSg new.
		sgTypeId := colombusClient getSgTypeByValue: (i at: 'FM3').
		sgFamix typesgId: sgTypeId. 
		i removeKey: 'id' ifAbsent: [  ].
		i removeKey: 'endPos' ifAbsent: [  ].
		i removeKey: 'startPos' ifAbsent: [  ].
		i removeKey: 'sender' ifAbsent: [  ].
		i removeKey: 'candidates' ifAbsent: [  ].
		i removeKey: 'signature' ifAbsent: [  ].
		i removeKey: 'allTagAssociations' ifAbsent: [  ].
		sgFamix value: i.

		value := colombusClient findSgFamix: sgFamix.
		colombusClient client isSuccess
			ifTrue: [ sgId := value at: 'id' ]
			ifFalse: [
				| req code |
				req := colombusClient client.
				code := req response statusLine code.

				code = 404 ifFalse: [
					Error signal: 'HTTP: ' , code asString , ' during api call'
					"Probably a server side error , should not appen" ].
				sgId := (colombusClient createSgFamix: sgFamix) at: 'id' ]. "here we need to create a new sg"

		notebookElmt := ColombusModelNbElmt new
			                notebookId: notebookId;
			                sousgraphfamix_id: sgId;
			                stepId: tagId;
			                linestart: lineStart;
			                lineend: lineEnd;
			                yourself.
		elmtID := (colombusClient createNbElmt: notebookElmt) at: 'idelmt'.
		self checkForInconsistancy: elmtID onTag: tagId. ].

]

{ #category : 'accessing' }
Vespucci >> taggedModel [

	^ taggedModel 
]

{ #category : 'accessing' }
Vespucci >> taggedModel: aFamixPythonTaggedModel [

	taggedModel := aFamixPythonTaggedModel
]
