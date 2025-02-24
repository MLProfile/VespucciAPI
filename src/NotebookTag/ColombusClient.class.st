Class {
	#name : 'ColombusClient',
	#superclass : 'Object',
	#instVars : [
		'client',
		'url'
	],
	#category : 'NotebookTag-API',
	#package : 'NotebookTag',
	#tag : 'API'
}

{ #category : 'as yet unclassified' }
ColombusClient class >> createClientWithUrl: anUrl [

	^ self new
		  apiUrl: anUrl;
		  yourself
]

{ #category : 'accessing' }
ColombusClient >> apiUrl [

	^url 

]

{ #category : 'accessing' }
ColombusClient >> apiUrl: anApiUrl [

	url := anApiUrl

]

{ #category : 'accessing' }
ColombusClient >> client [

	^ client
]

{ #category : 'inconsistency' }
ColombusClient >> createIconsistencyS: aColombusModelInconsistencS [

	^ client post: url,'inconsistencies/simple' contents: aColombusModelInconsistencS asDictionary. 
	
]

{ #category : 'nbElmt' }
ColombusClient >> createNbElmt: aColombusModelNbElmt [
"
notebookRequest := ColombusModelNbElmt new.
notebookRequest notebookId: 1.
notebookRequest sousgraphfamix_id: 1
notebookRequest stepId: 2.
notebookRequest linestart: 5.
notebookRequest lineend: 5.

self createNbElmt: notebookRequest
"
	^ client post: url,'notebook_elements/' contents: aColombusModelNbElmt asDictionary. 
]

{ #category : 'nbElmt' }
ColombusClient >> createNbElmtS: aColombusModelNbElmtS [
"
sgFamix := ColombusModelSg new.
sgFamix typesgId: 1.
sgFamix value: (Dictionary new at: 'row' put: 'from datetime import date'; yourself).

notebookRequest := ColombusModelNbElmtS new.
notebookRequest notebookId: 1.
notebookRequest sgFamix: sgFamix
notebookRequest stepId: 2.
notebookRequest linestart: 5.
notebookRequest lineend: 5.

self createNbElmt: notebookRequest
"
	^ client post: url,'notebook_elements/simple/' contents: aColombusModelNbElmtS asDictionary. 
]

{ #category : 'sousGraph' }
ColombusClient >> createSgFamix: aSgFamixObj [
"sgFamix := ColombusModelSg new.
sgFamix typesgId: 1.
sgFamix value: (Dictionary new at: 'row' put: 'from datetime import date'; yourself).

self createSgFamix: sgFamix."

	^ client post: url,'sousgraphfamix/' contents: aSgFamixObj asDictionary. 
]

{ #category : 'inconsistency' }
ColombusClient >> findIconsistency: anElmtMissMatchModel [

	^ client post: url,'inconsistencies/find' contents: anElmtMissMatchModel asDictionary. 
	
]

{ #category : 'inconsistency' }
ColombusClient >> findIconsistencyOnElmt: anElmtId nbId: aNbId [

	| res inconsistencies |
	res := client post: url , 'inconsistencies/find' contents: {
			       (#idnb -> aNbId).
			       (#idelmt -> anElmtId) } asDictionary.
	self client isSuccess
		ifTrue: [ inconsistencies := res ]
		ifFalse: [
			| req code |
			req := self client.
			code := req response statusLine code.

			code = 404 ifFalse: [
				Error signal: 'HTTP:' , code asString , 'Server problem'.
				"Probably a server side error , should not appen" ].
			inconsistencies := {  } ].

	^ inconsistencies
]

{ #category : 'sousGraph' }
ColombusClient >> findSgFamix: aSgFamixModelObj [
"If sg is find return the id"

	^ client post: url,'sousgraphfamix/search' contents: aSgFamixModelObj asDictionary. 
]

{ #category : 'nbElmt' }
ColombusClient >> getNbElmts [

	^ client get: url,'notebook_elements/'  
]

{ #category : 'nbElmt' }
ColombusClient >> getNbId: aNbId elementId: anElmtId [

	^ client get: url,'notebook_elements/',(aNbId asString),'/',(anElmtId asString)  
]

{ #category : 'sousGraph' }
ColombusClient >> getSgFamixs [

	^ client get: url,'sousgraphfamix/'
]

{ #category : 'sousGraph' }
ColombusClient >> getSgFamixsById: aSgFamixId [

	^ client get: url,'sousgraphfamix/',(aSgFamixId asString)
]

{ #category : 'step' }
ColombusClient >> getSgTypeByValue: aSgTypeValue [

	| res |
	res := client post: url,'find/typesg' contents: { #value->aSgTypeValue} asDictionary.
	^res at: 'id'
]

{ #category : 'step' }
ColombusClient >> getStepById: aStepId [ 

	^ client get: url,'steps/',(aStepId asString ) 
]

{ #category : 'step' }
ColombusClient >> getStepIdByName: aStepName [

	| res |
	res := client
		       post: url , 'step/'
		       contents: { (#name -> aStepName) } asDictionary.
	self client isSuccess ifFalse: [
		| req code |
		req := self client.
		code := req response statusLine code.

		code = 404 ifFalse: [
			Error signal: 'HTTP:' , code asString , 'Server problem' ].
		Error signal: 'Cannot find step (should exist)' ].

	^ res at: 'id'
]

{ #category : 'step' }
ColombusClient >> getSteps [ 

	^ client get: url,'steps/' 
]

{ #category : 'sousGraph' }
ColombusClient >> getTypesSg [

	^ client get: url,'typesg/'
]

{ #category : 'sousGraph' }
ColombusClient >> getTypesSgById: atypeSgId [

	^ client get: url,'typesg/',(atypeSgId asString)
]

{ #category : 'as yet unclassified' }
ColombusClient >> initialize [ 

	client :=  ZnClient new forJsonREST; yourself.

]
