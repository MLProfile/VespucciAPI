Class {
	#name : 'ColombusModelNbElmt',
	#superclass : 'Object',
	#instVars : [
		'notebookId',
		'typesgId',
		'sgFamix',
		'linestart',
		'lineend',
		'stepId'
	],
	#category : 'NotebookTag',
	#package : 'NotebookTag'
}

{ #category : 'accessing' }
ColombusModelNbElmt >> asDictionary [
    ^ Dictionary new
        at: 'notebook_id' put: notebookId;
        at: 'typesg_id' put: sgFamix typesgId ;
        at: 'sousgraph' put: sgFamix value;
        at: 'step_id' put: stepId;
        at: 'linestart' put: linestart;
        at: 'lineend' put: lineend;
        yourself.
]

{ #category : 'initialization' }
ColombusModelNbElmt >> initialize [
    notebookId := nil.
    stepId := nil.
	 sgFamix := nil. 
    linestart := nil.
    lineend := nil.
]

{ #category : 'initialization' }
ColombusModelNbElmt >> lineend [
    ^ lineend.
]

{ #category : 'accessing' }
ColombusModelNbElmt >> lineend: anInteger [
    lineend := anInteger.
]

{ #category : 'initialization' }
ColombusModelNbElmt >> linestart [
    ^ linestart.
]

{ #category : 'initialization' }
ColombusModelNbElmt >> linestart: anInteger [
    linestart := anInteger.
]

{ #category : 'initialization' }
ColombusModelNbElmt >> notebookId [
    ^ notebookId.
]

{ #category : 'initialization' }
ColombusModelNbElmt >> notebookId: anInteger [
    notebookId := anInteger.
]

{ #category : 'accessing' }
ColombusModelNbElmt >> sgFamix [

	^ sgFamix
]

{ #category : 'accessing' }
ColombusModelNbElmt >> sgFamix: aColombusModelSg [

	sgFamix := aColombusModelSg .
]

{ #category : 'initialization' }
ColombusModelNbElmt >> stepId [
    ^ stepId.
]

{ #category : 'initialization' }
ColombusModelNbElmt >> stepId: anInteger [
    stepId := anInteger.
]
