Class {
	#name : 'CAPApiProxy',
	#superclass : 'Object',
	#instVars : [
		'client'
	],
	#classInstVars : [
		'clientShared'
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

{ #category : 'initialization' }
CAPApiProxy class >> client [ 

	clientShared ifNil: [ self initializeClient ].
	^ clientShared
]

{ #category : 'initialization' }
CAPApiProxy class >> initializeClient [

	clientShared := ZnClient new
		                forJsonREST;
		                yourself.
	clientShared headerAt: 'X-API-Token' add: self apiToken
]

{ #category : 'accessing' }
CAPApiProxy >> client [ 

"^ client "


	^ self class client
]

{ #category : 'as yet unclassified' }
CAPApiProxy >> getJsonFrom: aPath [
    | res json |
    res := self client get: ( self class apiUrl,'vespucci/api/', aPath).
	
    self client isSuccess ifFalse: [
        1halt.
    ].

    ^ res
]

{ #category : 'initialization' }
CAPApiProxy >> initialize [ 

"	client := ZnClient new
		          forJsonREST;
		          yourself.
	client headerAt: 'X-API-Token' add: self class apiToken "
]

{ #category : 'as yet unclassified' }
CAPApiProxy >> persist [ 

	self subclassResponsibility. 
]

{ #category : 'initialization' }
CAPApiProxy >> reset [ 

	
]

{ #category : 'as yet unclassified' }
CAPApiProxy >> toJsonPayload [ 

	self subclassResponsibility. 
]
