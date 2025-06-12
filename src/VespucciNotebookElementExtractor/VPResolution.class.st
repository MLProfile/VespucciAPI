Class {
	#name : 'VPResolution',
	#superclass : 'Object',
	#instVars : [
		'inconsistency',
		'metaStep',
		'notebookElements',
		'decisions'
	],
	#category : 'VespucciNotebookElementExtractor',
	#package : 'VespucciNotebookElementExtractor'
}

{ #category : 'accessing' }
VPResolution >> decisions [

	^ decisions
]

{ #category : 'accessing' }
VPResolution >> decisions: anObject [

	decisions := anObject
]

{ #category : 'accessing' }
VPResolution >> inconsistency [

	^ inconsistency
]

{ #category : 'accessing' }
VPResolution >> inconsistency: anObject [

	inconsistency := anObject
]

{ #category : 'accessing' }
VPResolution >> metaStep [

	^ metaStep
]

{ #category : 'accessing' }
VPResolution >> metaStep: anObject [

	metaStep := anObject
]

{ #category : 'accessing' }
VPResolution >> notebookElements [

	^ notebookElements
]

{ #category : 'accessing' }
VPResolution >> notebookElements: anObject [

	notebookElements := anObject
]
