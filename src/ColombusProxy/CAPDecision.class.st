Class {
	#name : 'CAPDecision',
	#superclass : 'CAPApiProxy',
	#instVars : [
		'solutionText',
		'inconsistency',
		'resolutionType',
		'metaStep'
	],
	#category : 'ColombusProxy',
	#package : 'ColombusProxy'
}

{ #category : 'accessing' }
CAPDecision >> inconsistency [

	^ inconsistency
]

{ #category : 'accessing' }
CAPDecision >> inconsistency: anObject [

	inconsistency := anObject
]

{ #category : 'accessing' }
CAPDecision >> metaStep [

	^ metaStep
]

{ #category : 'accessing' }
CAPDecision >> metaStep: anObject [

	metaStep := anObject
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
