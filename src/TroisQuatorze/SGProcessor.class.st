Class {
	#name : 'SGProcessor',
	#superclass : 'Object',
	#instVars : [
		'patterns',
		'tagger',
		'taggedModel',
		'jsonFileReference',
		'notebookName',
		'processedEntities'
	],
	#category : 'TroisQuatorze',
	#package : 'TroisQuatorze'
}

{ #category : 'as yet unclassified' }
SGProcessor >> addPattern: pattern [
    patterns add: pattern.
]

{ #category : 'as yet unclassified' }
SGProcessor >> cleanJson: dict using: pattern [
    | keysToRemove |
    keysToRemove := pattern cleaningKeys.
    keysToRemove do: [ :k | dict removeKey: k ifAbsent: [ ] ].
    ^ dict.
]

{ #category : 'as yet unclassified' }
SGProcessor >> enrichJson: json with: famix andPattern: pattern [
    | dict |
    dict := json copy.
    dict at: 'line_start' put: famix sourceAnchor startLine.
    dict at: 'line_end' put: famix sourceAnchor endLine.
    dict at: 'pos_start' put: famix sourceAnchor startPos asString.
    dict at: 'pos_end' put: famix sourceAnchor endPos asString.
    dict at: 'source' put: famix sourceAnchor sourceText.
    dict at: 'type_sg_name' put: pattern name.
    ^ dict.
]

{ #category : 'as yet unclassified' }
SGProcessor >> extractTaggedSubGraphs [

	| allTagged |
	allTagged := OrderedCollection new.
	(patterns sort: [ :a :b | a priority > b priority ]) do: [ :pattern |
		| jsons isFallback |
		jsons := pattern jsonElementsFromFile: jsonFileReference.
		isFallback := pattern priority = (patterns collect: #priority) min.
		jsons do: [ :json |
			| famixEntity dict uniqueId tag |
			famixEntity := pattern matchFamixEntityFrom: json in: taggedModel.
			famixEntity isNil ifFalse: [
				uniqueId := famixEntity sourceAnchor startPos asString , '-'
				            , famixEntity sourceAnchor endPos asString.
				self flag: #'Peut etre plutot utiliser id famix'.
				(processedEntities includes: uniqueId) ifFalse: [
					dict := self
						        cleanJson:
						        (self
							         enrichJson: json
							         with: famixEntity
							         andPattern: pattern)
						        using: pattern.
					dict
						at: 'value'
						put: (self extractValueFrom: json using: pattern).
					tagger tagSubGraph: dict.

					tag := dict at: 'step_name'.
					(tag ~= 'Unknown' or: [ isFallback ]) ifTrue: [
						processedEntities add: uniqueId.
						allTagged add: dict ] ] ] ] ].
	^ allTagged
]

{ #category : 'as yet unclassified' }
SGProcessor >> extractValueFrom: json using: pattern [
    | value |
    value := Dictionary new.
    pattern valueKeys do: [ :key |
        (json includesKey: key) ifTrue: [
            value at: key put: (json at: key)
        ]
    ].
    ^ value.
]

{ #category : 'initialization' }
SGProcessor >> initialize [
    patterns := OrderedCollection new.
    tagger := SGTagger new.
    processedEntities := Set new.

]

{ #category : 'testing' }
SGProcessor >> isFallbackPattern: aPattern [
    ^ aPattern priority = (patterns collect: #priority) min.
]

{ #category : 'accessing' }
SGProcessor >> patterns [

	^ patterns
]

{ #category : 'accessing' }
SGProcessor >> patterns: anObject [

	patterns := anObject
]

{ #category : 'as yet unclassified' }
SGProcessor >> taggedModel: aModel jsonFile: aFile notebookName: aName [
    taggedModel := aModel.
    jsonFileReference := aFile.
    notebookName := aName.
]

{ #category : 'as yet unclassified' }
SGProcessor >> tagger [
    ^ tagger.
]
