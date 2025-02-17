"
## Usage 

vsp := Vespucci new notebookId: 1; yourself.
""We build the element collection line by line""
dict := vsp famixElementsByLine: modelA.
""We call the api to update db with new elements""
vsp postFamixSg: dict.
"
Class {
	#name : 'Vespucci',
	#superclass : 'Object',
	#instVars : [
		'colombusClient',
		'notebookId'
	],
	#category : 'NotebookTag',
	#package : 'NotebookTag'
}

{ #category : 'as yet unclassified' }
Vespucci >> checkForInconsistancy: aSgId [ 
"When we create a new nbElmt we should check if others nbElmt exists with the same SG but a different step"


"With the current notebook and the current sgId we can see if others notebooks registers the same sg with another step "
^aSgId

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

	colombusClient := ColombusClient new initClient: 'http://127.0.0.1:8000/'; yourself.
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

	"Probleme de duplication si on repase sur un nb deja traite, on va inserer de nouveau les elmts"

	| value tagId sgId notebookElmt |
	anEntityDict keysAndValuesDo: [ :key :collec |
		collec do: [ :fElment |
			| elem tag source sgFamix |
			elem := fElment element.
			tag := elem tags first name.
			tagId := self tagIdByName: tag.
			source := elem sourceText.

			"Now here we need to check if this SG exist"
			sgFamix := ColombusModelSg new.
			sgFamix typesgId: 4. "Actual string value type"
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
			colombusClient createNbElmt: notebookElmt ] ]
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
