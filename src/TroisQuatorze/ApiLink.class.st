Class {
	#name : 'ApiLink',
	#superclass : 'Object',
	#instVars : [
		'client'
	],
	#category : 'TroisQuatorze',
	#package : 'TroisQuatorze'
}

{ #category : 'accessing' }
ApiLink class >> apiToken [

	^ 'profil-platform-token'
]

{ #category : 'accessing' }
ApiLink class >> apiUrl [

	^ 'http://localhost:8080/'
]

{ #category : 'initialization' }
ApiLink >> client [

	^ client
]

{ #category : 'initialization' }
ApiLink >> initialize [ 

	client := ZnClient new
		          forJsonREST;
		          yourself.
	client headerAt: 'X-API-Token' add: self class apiToken 
]
