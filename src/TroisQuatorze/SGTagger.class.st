Class {
	#name : 'SGTagger',
	#superclass : 'Object',
	#instVars : [
		'templates'
	],
	#category : 'TroisQuatorze',
	#package : 'TroisQuatorze'
}

{ #category : 'adding' }
SGTagger >> addTemplate: template [
    templates add: template.
]

{ #category : 'initialization' }
SGTagger >> initialize [ 

templates := OrderedCollection new.
]

{ #category : 'as yet unclassified' }
SGTagger >> tagSubGraph: dict [
    | sorted matched |
    sorted := templates sort: [ :a :b | a priority > b priority ].
    matched := sorted detect: [ :t | t matches: dict ] ifNone: [ nil ].
    dict at: 'step_name' put: (matched ifNotNil: [ matched tag ] ifNil: [ 'Unknown' ]).
]

{ #category : 'accessing' }
SGTagger >> templates [

	^ templates
]

{ #category : 'accessing' }
SGTagger >> templates: anObject [

	templates := anObject
]
