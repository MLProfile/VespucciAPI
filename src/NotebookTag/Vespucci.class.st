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
Vespucci >> buildFamixModelWithAttributes: aTaggedFamixPythonModel [

	| model |
	model := aTaggedFamixPythonModel. "Surtout pas de copie ici pour le coup"

	model allImports do: [ :i |
		i importOf: i importedEntity name.
		i package: (self parentPackageOfAnImport: i).
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
Vespucci >> checkForInconsistancy: aNbElmtId [
	"When we create a new nbElmt we should check if others nbElmt exists with the same SG but a different step"

	| res inconsistencies |
	res := colombusClient
		       findIconsistencyOnElmt: aNbElmtId
		       nbId: notebookId.
	colombusClient client isSuccess
		ifTrue: [
			inconsistencies := res.
			1 halt ]
		ifFalse: [
			| req code |
			req := colombusClient client.
			code := req response statusLine code.

			code = 404 ifFalse: [
				1 halt "Probably a server side error , should not appen" ].
			inconsistencies := [  ] ].

"If we have inconsistencies we need to create them in db"
]

{ #category : 'as yet unclassified' }
Vespucci >> exportToJSON: aModelWithAttributes [

	localfileReference writeStreamDo: [ :aStream |
		aModelWithAttributes exportToJSONStream: aStream ].
	^ localfileReference
]

{ #category : 'as yet unclassified' }
Vespucci >> famixElementsByLine: aTaggedFamixPythonModel [

	| source dictionary model |
	model := aTaggedFamixPythonModel. "Besoin de faire une copy"
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
	sgType := 1
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
Vespucci >> parentPackageOfAnImport: anImport [
	"An imported entity can come from a package"

	"Actually we can have package chain sklearn.preprocessing.blabla we will need to handle this"

	| importedEntity |
	importedEntity := anImport importedEntity.

	^ String streamContents: [ :aStream |
		  | segments |
		  segments := OrderedCollection new.
		  importedEntity parentPackage ifNotNil: [
			  segments addFirst: importedEntity parentPackage name.
			  importedEntity parentPackage parentPackage ifNotNil: [
				  segments addFirst:
					  importedEntity parentPackage parentPackage name ] ].
		  segments doWithIndex: [ :each :index |
			  aStream nextPutAll: each.
			  index < segments size ifTrue: [ aStream nextPut: $. ] ] ]
]

{ #category : 'as yet unclassified' }
Vespucci >> postFamixSg: anEntityDict [
	"We want a line by line dictionnary of model entities : self famixElementsByLine"

	"Probleme de duplication si on repase sur un nb deja traite, on va inserer de nouveau les elmts"

	| value tagId sgId notebookElmt elmtID |
	anEntityDict keysAndValuesDo: [ :key :collec |
		collec do: [ :fElment |
			| elem tag source sgFamix |
			elem := fElment element.
			tag := elem tags first name.
			tagId := self tagIdByName: tag.
			source := elem sourceText.

			"Now here we need to check if this SG exist"
			sgFamix := ColombusModelSg new.
			sgFamix typesgId: sgType . "Actual string value type"
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
						1 halt "Probably a server side error , should not appen" ].
					sgId := (colombusClient createSgFamix: sgFamix) at: 'id' ]. "here we need to create a new sg"

			notebookElmt := ColombusModelNbElmt new
				                notebookId: notebookId;
				                "Passer la valeur en global"sousgraphfamix_id:
					                sgId;
				                stepId: tagId;
				                linestart: key;
				                lineend: key;
				                yourself.
			elmtID := (colombusClient createNbElmt: notebookElmt) at: 'idelmt'.
			self checkForInconsistancy: elmtID ] ]
]

{ #category : 'as yet unclassified' }
Vespucci >> postImports [

	| jsonImports modelImport tag tagId lineStart lineEnd sgFamix value sgId notebookElmt elmtID |
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
		tagId := self tagIdByName: tag.
		lineStart := famixImport first sourceAnchor startLine.
		lineEnd := famixImport first sourceAnchor endLine.

		"Now here we need to check if this SG exist"
		sgFamix := ColombusModelSg new.
		sgFamix typesgId: sgType. "We need to request the id where value is famix python import"
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
					1 halt "Probably a server side error , should not appen" ].
				sgId := (colombusClient createSgFamix: sgFamix) at: 'id' ]. "here we need to create a new sg"

		notebookElmt := ColombusModelNbElmt new
			                notebookId: notebookId;
			                sousgraphfamix_id: sgId;
			                stepId: tagId;
			                linestart: lineStart;
			                lineend: lineEnd;
			                yourself.
		elmtID := (colombusClient createNbElmt: notebookElmt) at: 'idelmt'.
		self checkForInconsistancy: elmtID ].

	^ jsonImports
]

{ #category : 'as yet unclassified' }
Vespucci >> postInvocations [

	|  tag tagId lineStart lineEnd sgFamix value sgId notebookElmt elmtID jsonInvocation modelInvocations |
	jsonInvocation := self allInvocationInAJsonExportedModel: localfileReference.
	modelInvocations := taggedModel allInvocations.
	jsonInvocation do: [ :i |
		| famixInvocation |
		famixInvocation := modelInvocations select: [ :invocationEntity |
			               invocationEntity sourceAnchor startPos asString
			               = (i at: 'startPos') and: [
				               invocationEntity sourceAnchor endPos asString
				               = (i at: 'endPos') ] ].
		1halt.
		tag := famixInvocation first tags first name.
		tagId := self tagIdByName: tag.
		lineStart := famixInvocation first sourceAnchor startLine.
		lineEnd := famixInvocation first sourceAnchor endLine.

		"Now here we need to check if this SG exist"
		sgFamix := ColombusModelSg new.
		sgFamix typesgId: sgType. "We need to request the id where value is famix python invocation"
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
					1 halt "Probably a server side error , should not appen" ].
				sgId := (colombusClient createSgFamix: sgFamix) at: 'id' ]. "here we need to create a new sg"

		notebookElmt := ColombusModelNbElmt new
			                notebookId: notebookId;
			                sousgraphfamix_id: sgId;
			                stepId: tagId;
			                linestart: lineStart;
			                lineend: lineEnd;
			                yourself.
		elmtID := (colombusClient createNbElmt: notebookElmt) at: 'idelmt'.
		self checkForInconsistancy: elmtID ].

]

{ #category : 'as yet unclassified' }
Vespucci >> tagIdByName: aTagName [

	| tagId |
	tagId := colombusClient getStepByName: aTagName.
	colombusClient client isSuccess ifFalse: [
		| req code |
		req := colombusClient client.
		code := req response statusLine code.

		code = 404 ifFalse: [ Error signal: 'Server problem' ].
		Error signal: 'Cannot find step (should exist)' ].

	^ tagId at: 'id'
]

{ #category : 'accessing' }
Vespucci >> taggedModel [

	^ taggedModel 
]

{ #category : 'accessing' }
Vespucci >> taggedModel: aFamixPythonTaggedModel [

	taggedModel := aFamixPythonTaggedModel
]
