Class {
	#name : 'ColombusClient',
	#superclass : 'Object',
	#instVars : [
		'client',
		'url'
	],
	#category : 'VespucciNotebookElementExtractor-API',
	#package : 'VespucciNotebookElementExtractor',
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
