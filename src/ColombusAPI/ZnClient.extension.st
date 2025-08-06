Extension { #name : 'ZnClient' }

{ #category : '*ColombusAPI' }
ZnClient >> checkHttpCode: aCode [

    aCode = 200 ifTrue: [ 
        ^ self inform: 'OK' 
    ].
    aCode = 401 ifTrue: [ 
        ^ Error signal: 'Response from Colombus - Unauthorized' 
    ].
    aCode = 404 ifTrue: [ 
        ^ Error signal: 'Response from Colombus - Not found' 
    ].
    (aCode between: 400 and: 499) ifTrue: [
        ^ Error signal: 'Response from Colombus - HTTP:' , aCode asString , ' - Client error'
    ].
    (aCode between: 500 and: 599) ifTrue: [
        ^ Error signal: 'Response from Colombus - HTTP:' , aCode asString , ' - Server error'
    ].
 
    ^ Error signal: 'Response from Colombus - HTTP:' , aCode asString , ' - Erreur inconnue'
]

{ #category : '*ColombusAPI' }
ZnClient >> forJsonREST [
"IfFail est appelé avant d'avoir la nouvelle response. On est donc sur l'ancienne reponse qui a potentiellement un autre status "
	| reader writer |
	reader := ZnUtils defaultJSONReader.
	writer := ZnUtils defaultJSONWriter.
	self
		accept: ZnMimeType applicationJson;
		contentReader: [ :entity | reader fromString: entity contents ];
		ifFail: [ "ici la response est le cache de la response precedente, il faut donc faire autrement" self checkHttpCode: response statusLine code. ];
		contentWriter: [ :data | ZnEntity json: (writer toString: data) ]
]
