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

{ #category : 'accessing' }
CAPInconsistency >> elements [

	^ elements
]

{ #category : 'accessing' }
CAPInconsistency >> elements: anObject [

	elements := anObject
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

{ #category : 'as yet unclassified' }
CAPInconsistency >> metaSteps [ 

	^ self elements collect: [ :e |  e stepImpls collect: [ :si | si metaStep name ]  ].
]

{ #category : 'as yet unclassified' }
CAPInconsistency >> pp [

	| dict |
	dict := self sgValue asDictionary.
	dict at: 'code' put: self sgCode.
	dict at: 'nbElmnt' put: self elements size.
	^ dict
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
