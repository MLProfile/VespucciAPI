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
1halt.
"    (FileSystem workingDirectory / 'monFichier.txt') writeStreamDo: [ :stream | stream nextPutAll: res asString ].
    json := NeoJSONReader fromString: (res asString)."
    ^ res
]

{ #category : 'initialization' }
ApiProxy >> initialize [ 

	client := ZnClient new
		          forJsonREST;
		          yourself.
	client headerAt: 'X-API-Token' add: self class apiToken 
]
