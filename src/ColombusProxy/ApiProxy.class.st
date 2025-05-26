Class {
	#name : 'ApiProxy',
	#superclass : 'Object',
	#instVars : [
		'client'
	],
	#category : 'ColombusProxy',
	#package : 'ColombusProxy'
}

{ #category : 'accessing' }
ApiProxy class >> apiToken [ 

	^ 'profil-platform-token'
]

{ #category : 'accessing' }
ApiProxy class >> apiUrl [

	^ 'http://localhost:8080/'
]

{ #category : 'accessing' }
ApiProxy >> client [ 

^ client 
]

{ #category : 'as yet unclassified' }
ApiProxy >> getJsonFrom: aPath [
    | res json |
    res := self client get: ( self class apiUrl,'vespucci/api/', aPath).
	"(Delay forMilliseconds: 500) wait."
    self client isSuccess ifFalse: [
        1halt.
    ].
    json := NeoJSONReader fromString: (res asString).
    ^ json
]

{ #category : 'initialization' }
ApiProxy >> initialize [ 

	client := ZnClient new
		          forJsonREST;
		          yourself.
	client headerAt: 'X-API-Token' add: self class apiToken 
]
