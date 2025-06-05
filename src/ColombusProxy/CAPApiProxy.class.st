Class {
	#name : 'CAPApiProxy',
	#superclass : 'Object',
	#instVars : [
		'client'
	],
	#category : 'ColombusProxy',
	#package : 'ColombusProxy'
}

{ #category : 'accessing' }
CAPApiProxy class >> apiToken [ 

	^ 'profil-platform-token'
]

{ #category : 'accessing' }
CAPApiProxy class >> apiUrl [

	^ 'http://localhost:8080/'
]

{ #category : 'accessing' }
CAPApiProxy >> client [ 

^ client 
]

{ #category : 'as yet unclassified' }
CAPApiProxy >> getJsonFrom: aPath [
    | res json |
    res := self client get: ( self class apiUrl,'vespucci/api/', aPath).
	"(Delay forMilliseconds: 500) wait."
    self client isSuccess ifFalse: [
        1halt.
    ].

"    (FileSystem workingDirectory / 'monFichier.txt') writeStreamDo: [ :stream | stream nextPutAll: res asString ].
    json := NeoJSONReader fromString: (res asString)."
    ^ res
]

{ #category : 'initialization' }
CAPApiProxy >> initialize [ 

	client := ZnClient new
		          forJsonREST;
		          yourself.
	client headerAt: 'X-API-Token' add: self class apiToken 
]
