Class {
	#name : 'CAPInconsistency',
	#superclass : 'CAPApiProxy',
	#instVars : [
		'id',
		'description',
		'detectionDate',
		'resolutionDate',
		'isResolved',
		'sousGraph',
		'elements'
	],
	#category : 'ColombusProxy',
	#package : 'ColombusProxy'
}

{ #category : 'adding' }
CAPInconsistency >> addElement: anElement [
    self elements ifNil: [ elements := OrderedCollection new ].
    elements add: anElement.
]

{ #category : 'as yet unclassified' }
CAPInconsistency >> areLlmInconsistencies [

	^ (self getLlmMetaSteps collect: #id) asSet size > 1
]

{ #category : 'accessing' }
CAPInconsistency >> description [

	^ description
]

{ #category : 'accessing' }
CAPInconsistency >> description: anObject [

	description := anObject
]

{ #category : 'accessing' }
CAPInconsistency >> detectionDate [

	^ detectionDate
]

{ #category : 'accessing' }
CAPInconsistency >> detectionDate: anObject [

	detectionDate := anObject
]

{ #category : 'as yet unclassified' }
CAPInconsistency >> display [

	| dict |
	dict := self sgValue asDictionary.
	dict at: 'code' put: self elementsCode.
	dict at: 'nbElmnt' put: self elements size.
	dict at: 'metaSteps' put: self metaSteps. 
	^ dict
]

{ #category : 'accessing' }
CAPInconsistency >> elements [

	^ elements
]

{ #category : 'accessing' }
CAPInconsistency >> elements: anObject [

	elements := anObject
]

{ #category : 'as yet unclassified' }
CAPInconsistency >> elementsCode [ 
	
	^ self elements collect: [ :e | e code ]
]

{ #category : 'as yet unclassified' }
CAPInconsistency >> getLlmInconsistencies [
	""

	^ self areLlmInconsistencies
		  ifTrue: [ self ]
		  ifFalse: [ {  } ]
]

{ #category : 'as yet unclassified' }
CAPInconsistency >> getLlmMetaStepNames [

	^ self getLlmMetaSteps collect: #name
]

{ #category : 'as yet unclassified' }
CAPInconsistency >> getLlmMetaSteps [
	""

	^ self metaSteps collect: #second
]

{ #category : 'accessing' }
CAPInconsistency >> id [

	^ id
]

{ #category : 'accessing' }
CAPInconsistency >> id: anObject [

	id := anObject
]

{ #category : 'accessing' }
CAPInconsistency >> isResolved [
    ^ isResolved ifNil: [ false ]
]

{ #category : 'accessing' }
CAPInconsistency >> isResolved: anObject [

	isResolved := anObject
]

{ #category : 'testing' }
CAPInconsistency >> isVespucciUnknown [ 

	^ (self metaSteps collect: #first) first name = 'Unknown' 
]

{ #category : 'as yet unclassified' }
CAPInconsistency >> llmConsistentMetaStep [

	^ self areLlmInconsistencies
		  ifTrue: [ ]
		  ifFalse: [ self getLlmMetaSteps first ]
]

{ #category : 'as yet unclassified' }
CAPInconsistency >> metaSteps [ 

	^ self elements collect: [ :e |  e stepImpls collect: [ :si | si metaStep ]  ].
]

{ #category : 'accessing' }
CAPInconsistency >> resolutionDate [

	^ resolutionDate
]

{ #category : 'accessing' }
CAPInconsistency >> resolutionDate: anObject [

	resolutionDate := anObject
]

{ #category : 'as yet unclassified' }
CAPInconsistency >> sgCode [

	self
		deprecated: 'Use elementsCode instead of current one'
		on: '10 June 2025'
		in:
		'Pharo-13.0.0+SNAPSHOT.build.674.sha.e4d88974a939e8af5b66e2032920fa85414cff6f (64 Bit)'.

	^ self sousGraph code content
]

{ #category : 'as yet unclassified' }
CAPInconsistency >> sgValue [ 
	
	^ self sousGraph internalValue 
]

{ #category : 'accessing' }
CAPInconsistency >> sousGraph [

	^ sousGraph
]

{ #category : 'accessing' }
CAPInconsistency >> sousGraph: anObject [

	sousGraph := anObject
]
