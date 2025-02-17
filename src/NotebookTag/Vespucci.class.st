Class {
	#name : 'Vespucci',
	#superclass : 'Object',
	#instVars : [
		'colombusClient'
	],
	#category : 'NotebookTag',
	#package : 'NotebookTag'
}

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

{ #category : 'as yet unclassified' }
Vespucci >> postFamixSg: anEntityDict [
	"We want a line by line dictionnary of model entities : self famixElementsByLine"

	| value |
	anEntityDict keysAndValuesDo: [ :key :collec |
		collec do: [ :fElment |
			| elem tag source sgFamix |
			elem := fElment element.
			tag := elem tags first name.
			source := elem sourceText.

			"Now here we need to check if this SG exist"
			sgFamix := ColombusModelSg new.
			sgFamix typesgId: 4. "Actual string value type"
			sgFamix value: (Dictionary new
					 at: 'source' put: source;
					 yourself).

			value := colombusClient findSgFamix: sgFamix.
			colombusClient client isSuccess
				ifTrue: [
					| id notebookElmt |
					"self inform: 'Found a corresponding SG : ',(value asString)."
					id := value at: 'id'.

					notebookElmt := ColombusModelNbElmt new
						                notebookId: 1;
						                "Passer la valeur en global"sousgraphfamix_id:
							                id;
						                stepId: 2;
						                "Request to find the tag id"linestart: key;
						                lineend: key;
						                yourself.
					colombusClient createNbElmt: notebookElmt.

					1 halt ]
				ifFalse: [
					| req code |
					req := colombusClient client.
					code := req response statusLine code.

					code = 404 ifFalse: [
						1 halt "Probably a server side error , should not appen" ].
					colombusClient createSgFamix: sgFamix.
					1 halt ]. "here we need to create a new sg"

			"If it does, is the same tag ?"

			"If not insert a new sub graph and create a new nbElmt"



			1 halt ] ]
]
