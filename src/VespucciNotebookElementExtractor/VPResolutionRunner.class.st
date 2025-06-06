Class {
	#name : 'VPResolutionRunner',
	#superclass : 'Object',
	#instVars : [
		'notebook',
		'inconsistencies',
		'resolutions'
	],
	#category : 'VespucciNotebookElementExtractor',
	#package : 'VespucciNotebookElementExtractor'
}

{ #category : 'as yet unclassified' }
VPResolutionRunner class >> runResolutionOnNotebook: aNotebook [


^ self new inconsistenciesForNotebook: aNotebook; resolveInconsistencies; yourself 
]

{ #category : 'accessing' }
VPResolutionRunner >> inconsistencies [

	^ inconsistencies
]

{ #category : 'accessing' }
VPResolutionRunner >> inconsistencies: anObject [

	inconsistencies := anObject
]

{ #category : 'as yet unclassified' }
VPResolutionRunner >> inconsistenciesForNotebook: aNotebook [

	notebook := aNotebook.
	^ inconsistencies := aNotebook detectNewInconsistenciesByMetaStep
]

{ #category : 'initialization' }
VPResolutionRunner >> initialize [  

	resolutions := OrderedCollection new.
]

{ #category : 'accessing' }
VPResolutionRunner >> notebook [

	^ notebook
]

{ #category : 'accessing' }
VPResolutionRunner >> notebook: anObject [

	notebook := anObject
]

{ #category : 'accessing' }
VPResolutionRunner >> resolutions [

	^ resolutions
]

{ #category : 'accessing' }
VPResolutionRunner >> resolutions: anObject [

	resolutions := anObject
]

{ #category : 'as yet unclassified' }
VPResolutionRunner >> resolveInconsistencies [

	| resolution |
	inconsistencies do: [ :i |
			resolution := VPUnknownResolution new resolveInconsistency: i.
			resolution decision ifNotNil: [
				resolutions add: (VPUnknownResolution new resolveInconsistency: i) ] ]
]
