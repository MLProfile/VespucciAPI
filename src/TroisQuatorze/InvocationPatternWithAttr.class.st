Class {
	#name : 'InvocationPatternWithAttr',
	#superclass : 'SGPattern',
	#category : 'TroisQuatorze',
	#package : 'TroisQuatorze'
}

{ #category : 'initialization' }
InvocationPatternWithAttr >> initialize [ 

	name := 'InvocationAndAttributes'.
	priority := 1.
	cleaningKeys:= #('id').
	valueKeys := #('function' 'library' 'arguments').
]

{ #category : 'as yet unclassified' }
InvocationPatternWithAttr >> jsonElementsFromFile: aFileRef [
    | data |
    data := (NeoJSONReader on: aFileRef readStream) next.
    ^ data select: [ :e | (e at: 'FM3' ifAbsent: ['']) = 'Famix-Python-Entities.Invocation' ].
]

{ #category : 'as yet unclassified' }
InvocationPatternWithAttr >> matchFamixEntityFrom: json in: model [
    ^ (model allInvocations select: [ :e |
        e sourceAnchor startPos asString = (json at: 'startPos') and:
        [ e sourceAnchor endPos asString = (json at: 'endPos') ]
    ]) ifNotEmpty: [ :c | c first ] ifEmpty: [ nil ].
]
