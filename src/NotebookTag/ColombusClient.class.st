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

{ #category : 'as yet unclassified' }
ColombusClient >> checkHttpCode: aCode [

    aCode = 200 ifTrue: [ 
        ^ self inform: 'OK' 
    ].
    aCode = 401 ifTrue: [ 
        ^ Error signal: 'Unauthorized' 
    ].
    aCode = 404 ifTrue: [ 
        ^ Error signal: 'Not found' 
    ].
    (aCode between: 400 and: 499) ifTrue: [
        ^ Error signal: 'HTTP:' , aCode asString , ' - Client error'
    ].
    (aCode between: 500 and: 599) ifTrue: [
        ^ Error signal: 'HTTP:' , aCode asString , ' - Server error'
    ].
 
    ^ Error signal: 'HTTP:' , aCode asString , ' - Erreur inconnue'
]

{ #category : 'accessing' }
ColombusClient >> client [

	^ client
]

{ #category : 'nbElmt' }
ColombusClient >> createFullProfile: aApiModelFullProfile [
"
test := ApiModelFullProfile new.
test notebook_id: '2a093105-d80c-4b8b-81af-f6b2fd0c771b'.
test project_id: '4f2b506d-0817-4b73-bcef-247f77d63985'.
test name: 'test'.
test sous_graphs: jsonExport. 
"

	^ client post: url,'core/api/profiles' contents: aApiModelFullProfile asDictionary. 
]

{ #category : 'inconsistency' }
ColombusClient >> createIconsistencyS: aColombusModelInconsistencS [
		
		self flag: #toDelete.
		
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

self flag: #toDelete.
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

self flag: #toDelete.
	^ client post: url,'notebook_elements/simple/' contents: aColombusModelNbElmtS asDictionary. 
]

{ #category : 'sousGraph' }
ColombusClient >> createSgFamix: aSgFamixObj [
"sgFamix := ColombusModelSg new.
sgFamix typesgId: 1.
sgFamix value: (Dictionary new at: 'row' put: 'from datetime import date'; yourself).

self createSgFamix: sgFamix."

self flag: #toDelete.
	^ client post: url,'sousgraphfamix/' contents: aSgFamixObj asDictionary. 
]

{ #category : 'inconsistency' }
ColombusClient >> findIconsistency: anElmtMissMatchModel [
self flag: #toDelete.
	^ client post: url,'inconsistencies/find' contents: anElmtMissMatchModel asDictionary. 
	
]

{ #category : 'inconsistency' }
ColombusClient >> findIconsistencyOnElmt: anElmtId nbId: aNbId [

	| res inconsistencies |
	
	self flag: #toDelete.
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

self flag: #toDelete.
	^ client post: url,'sousgraphfamix/search' contents: aSgFamixModelObj asDictionary. 
]

{ #category : 'sousGraph' }
ColombusClient >> fromProjectId: aProjectID downloadNotebookId: aNotebookId [

	| res localfileReference |
	res := ZnClient new
		       headerAt: 'X-API-Token' add: 'profil-platform-token';
		       get:
			       url , 'core/api/project/' , aProjectID asString
			       , '/notebook/' , aNotebookId asString , '/python'.

	"Check if the request went well"
	localfileReference := FileReference
		                      newTempFilePrefix: 'pythonCode-'
		                      suffix: '-download.py'.

	localfileReference writeStreamDo: [ :aStream |
		aStream nextPutAll: res ].
	^ localfileReference
]

{ #category : 'nbElmt' }
ColombusClient >> getNbElmts [
self flag: #toDelete.
	^ client get: url,'notebook_elements/'  
]

{ #category : 'nbElmt' }
ColombusClient >> getNbId: aNbId elementId: anElmtId [
self flag: #toDelete.
	^ client get: url,'notebook_elements/',(aNbId asString),'/',(anElmtId asString)  
]

{ #category : 'sousGraph' }
ColombusClient >> getNotebookById: aNotebookId [

	| res |
	res := client get: url , 'core/api/notebooks/' , aNotebookId asString.

	self client isSuccess ifFalse: [
		| req code |
		req := self client.
		code := req response statusLine code.
		self checkHttpCode: code ].

	^ res
]

{ #category : 'sousGraph' }
ColombusClient >> getSgFamixs [
self flag: #toDelete.
	^ client get: url,'sousgraphfamix/'
]

{ #category : 'sousGraph' }
ColombusClient >> getSgFamixsById: aSgFamixId [
self flag: #toDelete.
	^ client get: url,'sousgraphfamix/',(aSgFamixId asString)
]

{ #category : 'step' }
ColombusClient >> getSgTypeIdByValue: aSgTypeValue [

	| res |
	res := client get: url,'vespucci/api/typesgs/value/', aSgTypeValue asString.

	self client isSuccess ifFalse: [
		| req code |
		req := self client.
		code := req response statusLine code.
		self checkHttpCode: code ].

	^ res at: 'id'
]

{ #category : 'step' }
ColombusClient >> getStepById: aStepId [ 
self flag: #toDelete.
	^ client get: url,'steps/',(aStepId asString ) 
]

{ #category : 'step' }
ColombusClient >> getStepIdByName: aStepName [

	| res |
	self flag: #toDelete.
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

{ #category : 'sousGraph' }
ColombusClient >> getTypesSg [

	| res |
	client headerAt: 'X-API-Token' add: 'profil-platform-token'.
	res := client get: url , 'vespucci/api/typesgs' .

	self client isSuccess ifFalse: [
		| req code |
		req := self client.
		code := req response statusLine code.
		self checkHttpCode: code ].

	^ res
]

{ #category : 'sousGraph' }
ColombusClient >> getTypesSgById: atypeSgId [

	| res |
	res := client get: url , 'vespucci/api/typesgs/' , atypeSgId asString.

	self client isSuccess ifFalse: [
		| req code |
		req := self client.
		code := req response statusLine code.
		self checkHttpCode: code ].

	^ res
]

{ #category : 'as yet unclassified' }
ColombusClient >> initialize [ 

	client :=  ZnClient new forJsonREST; yourself.
	client headerAt: 'X-API-Token' add: 'profil-platform-token'.

]
