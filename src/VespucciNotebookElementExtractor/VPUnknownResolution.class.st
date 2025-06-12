Class {
	#name : 'VPUnknownResolution',
	#superclass : 'VPAutoResolution',
	#category : 'VespucciNotebookElementExtractor',
	#package : 'VespucciNotebookElementExtractor'
}

{ #category : 'as yet unclassified' }
VPUnknownResolution >> createDecisionFor: anInconsistency [

	^ anInconsistency elements collect: [ :each |  
		
		CAPDecision new
		inconsistency: anInconsistency;
		method: self className;
		"Une decision par element"
		element: each;
		solutionText: 'Unknown resolution';
		resolutionType: 'automatic';
		decisionDate: DateAndTime now;
		newMetaStep: anInconsistency llmConsistentMetaStep; yourself.
		
		
		 ]
"
	^ CAPDecision new
		inconsistency: anInconsistency;
		method: self className;
		""Une decision par element""
		""element: anInconsistency ""
		decisionDate: DateAndTime now;
		newMetaStep: anInconsistency llmConsistentMetaStep; yourself."
]

{ #category : 'as yet unclassified' }
VPUnknownResolution >> resolveInconsistency: anInconsistency [

	(anInconsistency isVespucciUnknown and: [
		 anInconsistency areLlmInconsistencies not ]) ifFalse: [ ^ self ].

	decisions := self createDecisionFor: anInconsistency.
	inconsistency := anInconsistency.
	
	metaStep := decisions first newMetaStep name. 
	notebookElements := anInconsistency elements.
]
