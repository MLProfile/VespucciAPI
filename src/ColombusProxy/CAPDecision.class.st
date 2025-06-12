Class {
	#name : 'CAPDecision',
	#superclass : 'CAPApiProxy',
	#instVars : [
		'solutionText',
		'inconsistency',
		'element',
		'decisionDate',
		'method',
		'resolutionType',
		'oldMetaStep',
		'newMetaStep'
	],
	#category : 'ColombusProxy',
	#package : 'ColombusProxy'
}

{ #category : 'accessing' }
CAPDecision >> decisionDate [

	^ decisionDate
]

{ #category : 'accessing' }
CAPDecision >> decisionDate: anObject [

	decisionDate := anObject
]

{ #category : 'accessing' }
CAPDecision >> element [

	^ element
]

{ #category : 'accessing' }
CAPDecision >> element: anObject [

	element := anObject
]

{ #category : 'accessing' }
CAPDecision >> inconsistency [

	^ inconsistency
]

{ #category : 'accessing' }
CAPDecision >> inconsistency: anObject [

	inconsistency := anObject
]

{ #category : 'accessing' }
CAPDecision >> method [

	^ method
]

{ #category : 'accessing' }
CAPDecision >> method: anObject [

	method := anObject
]

{ #category : 'accessing' }
CAPDecision >> newMetaStep [

	^ newMetaStep
]

{ #category : 'accessing' }
CAPDecision >> newMetaStep: anObject [

	newMetaStep := anObject
]

{ #category : 'accessing' }
CAPDecision >> oldMetaStep [

	^ oldMetaStep
]

{ #category : 'accessing' }
CAPDecision >> oldMetaStep: anObject [

	oldMetaStep := anObject
]

{ #category : 'accessing' }
CAPDecision >> resolutionType [

	^ resolutionType
]

{ #category : 'accessing' }
CAPDecision >> resolutionType: anObject [

	resolutionType := anObject
]

{ #category : 'accessing' }
CAPDecision >> solutionText [

	^ solutionText
]

{ #category : 'accessing' }
CAPDecision >> solutionText: anObject [

	solutionText := anObject
]
