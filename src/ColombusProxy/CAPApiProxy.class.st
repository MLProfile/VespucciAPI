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

	^ 'http://localhost:8080/' "'http://erebe-vm9.i3s.unice.fr:8000/'"
]

{ #category : 'initialization' }
CAPApiProxy class >> client [

	^ clientShared ifNil: [ clientShared := self initializeClient ]
]

{ #category : 'initialization' }
CAPApiProxy class >> initializeClient [

	^ clientShared := ZnClient new
		                  forJsonREST;
		                  headerAt: 'X-API-Token' add: self apiToken;
		                  yourself
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
	res class = ZnClient ifTrue: [  ^ Error signal: 'something went wrong with the request'  ].

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
