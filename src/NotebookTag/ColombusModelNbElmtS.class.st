Class {
	#name : 'ColombusModelNbElmtS',
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
ColombusModelNbElmtS >> asDictionary [
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
ColombusModelNbElmtS >> initialize [
    notebookId := nil.
    stepId := nil.
	 sgFamix := nil. 
    linestart := nil.
    lineend := nil.
]

{ #category : 'initialization' }
ColombusModelNbElmtS >> lineend [
    ^ lineend.
]

{ #category : 'accessing' }
ColombusModelNbElmtS >> lineend: anInteger [
    lineend := anInteger.
]

{ #category : 'initialization' }
ColombusModelNbElmtS >> linestart [
    ^ linestart.
]

{ #category : 'initialization' }
ColombusModelNbElmtS >> linestart: anInteger [
    linestart := anInteger.
]

{ #category : 'initialization' }
ColombusModelNbElmtS >> notebookId [
    ^ notebookId.
]

{ #category : 'initialization' }
ColombusModelNbElmtS >> notebookId: anInteger [
    notebookId := anInteger.
]

{ #category : 'accessing' }
ColombusModelNbElmtS >> sgFamix [

	^ sgFamix
]

{ #category : 'accessing' }
ColombusModelNbElmtS >> sgFamix: aColombusModelSg [

	sgFamix := aColombusModelSg .
]

{ #category : 'initialization' }
ColombusModelNbElmtS >> stepId [
    ^ stepId.
]

{ #category : 'initialization' }
ColombusModelNbElmtS >> stepId: anInteger [
    stepId := anInteger.
]
