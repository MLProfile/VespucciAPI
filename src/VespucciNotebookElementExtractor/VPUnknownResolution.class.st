Class {
	#name : 'VPUnknownResolution',
	#superclass : 'VPAutoResolution',
	#category : 'VespucciNotebookElementExtractor',
	#package : 'VespucciNotebookElementExtractor'
}

{ #category : 'as yet unclassified' }
VPUnknownResolution >> createDecisionFor: anInconsistency [

	^ CAPDecision new
		inconsistency: anInconsistency;
		metaStep: anInconsistency llmConsistentMetaStep; yourself.
]

{ #category : 'as yet unclassified' }
VPUnknownResolution >> resolveInconsistency: anInconsistency [

	(anInconsistency isVespucciUnknown and: [
		 anInconsistency areLlmInconsistencies not ]) ifFalse: [ ^ self ].

	decision := self createDecisionFor: anInconsistency.
	inconsistency := anInconsistency.
	metaStep := decision metaStep. 
	notebookElements := anInconsistency elements.
]
