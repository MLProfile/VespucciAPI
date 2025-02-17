Class {
	#name : 'ColombusModelNbElmt',
	#superclass : 'Object',
	#instVars : [
		'notebookId',
		'sousgraphfamix_id',
		'linestart',
		'lineend',
		'stepId'
	],
	#category : 'NotebookTag',
	#package : 'NotebookTag'
}

{ #category : 'converting' }
ColombusModelNbElmt >> asDictionary [
    ^ Dictionary new
        at: 'idnb' put: notebookId;
        at: 'sousgraphfamix_id' put: sousgraphfamix_id ;
        at: 'laststep_id' put: stepId;
        at: 'linestart' put: linestart;
        at: 'lineend' put: lineend;
        yourself.
]

{ #category : 'accessing' }
ColombusModelNbElmt >> lineend [

	^ lineend
]

{ #category : 'accessing' }
ColombusModelNbElmt >> lineend: anObject [

	lineend := anObject
]

{ #category : 'accessing' }
ColombusModelNbElmt >> linestart [

	^ linestart
]

{ #category : 'accessing' }
ColombusModelNbElmt >> linestart: anObject [

	linestart := anObject
]

{ #category : 'accessing' }
ColombusModelNbElmt >> notebookId [

	^ notebookId
]

{ #category : 'accessing' }
ColombusModelNbElmt >> notebookId: anObject [

	notebookId := anObject
]

{ #category : 'accessing' }
ColombusModelNbElmt >> sousgraphfamix_id [

	^ sousgraphfamix_id
]

{ #category : 'accessing' }
ColombusModelNbElmt >> sousgraphfamix_id: anObject [

	sousgraphfamix_id := anObject
]

{ #category : 'accessing' }
ColombusModelNbElmt >> stepId [

	^ stepId
]

{ #category : 'accessing' }
ColombusModelNbElmt >> stepId: anObject [

	stepId := anObject
]
