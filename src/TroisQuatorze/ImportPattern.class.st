Class {
	#name : 'ImportPattern',
	#superclass : 'SGPattern',
	#category : 'TroisQuatorze',
	#package : 'TroisQuatorze'
}

{ #category : 'initialization' }
ImportPattern >> initialize [ 

	name := 'Import'.
	cleaningKeys:= #('id' 'importedEntity' 'importingEntity').
	valueKeys := #('importOf' 'isFromImport' 'package' 'numberOfLinesOfCode' 'alias').
]

{ #category : 'as yet unclassified' }
ImportPattern >> jsonElementsFromFile: aFileRef [
    | data |
    data := (NeoJSONReader on: aFileRef readStream) next.
    ^ data select: [ :e | (e at: 'FM3' ifAbsent: ['']) = 'Famix-Python-Entities.Import' ].

]

{ #category : 'as yet unclassified' }
ImportPattern >> matchFamixEntityFrom: json in: model [
    ^ (model allImports select: [ :e |
        e sourceAnchor startPos asString = (json at: 'startPos') and:
        [ e sourceAnchor endPos asString = (json at: 'endPos') ]
    ]) ifNotEmpty: [ :c | c first ] ifEmpty: [ nil ].
]
