Class {
	#name : 'InvocationPattern',
	#superclass : 'SGPattern',
	#category : 'TroisQuatorze',
	#package : 'TroisQuatorze'
}

{ #category : 'initialization' }
InvocationPattern >> initialize [ 

	name := 'Invocation'.
	cleaningKeys:= #('id').
	valueKeys := #('function' 'library').
]

{ #category : 'as yet unclassified' }
InvocationPattern >> jsonElementsFromFile: aFileRef [
    | data |
    data := (NeoJSONReader on: aFileRef readStream) next.
    ^ data select: [ :e | (e at: 'FM3' ifAbsent: ['']) = 'Famix-Python-Entities.Invocation' ].
]

{ #category : 'as yet unclassified' }
InvocationPattern >> matchFamixEntityFrom: json in: model [
"Filter par target name"
    ^ (model allInvocations select: [ :e |
        e sourceAnchor startPos asString = (json at: 'startPos') and:
        [ e sourceAnchor endPos asString = (json at: 'endPos') ]
    ]) ifNotEmpty: [ :c | c first ] ifEmpty: [ nil ].
]
