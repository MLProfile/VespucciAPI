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

{ #category : 'accessing' }
CAPInconsistency >> resolutionDate [

	^ resolutionDate
]

{ #category : 'accessing' }
CAPInconsistency >> resolutionDate: anObject [

	resolutionDate := anObject
]

{ #category : 'accessing' }
CAPInconsistency >> sousGraph [

	^ sousGraph
]

{ #category : 'accessing' }
CAPInconsistency >> sousGraph: anObject [

	sousGraph := anObject
]
