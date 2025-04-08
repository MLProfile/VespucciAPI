"
# Usage 

```
VespServer startOn: 8181.
```

```
curl -X POST http://localhost:1701/compute -d '{""notebookId"": ""88f4453c-30c7-4341-b3ec-4c0ee03e945e"", ""projectId"": ""4f2b506d-0817-4b73-bcef-247f77d63985"", ""profileName"": ""test""}' -H ""Content-Type: application/json""
```
"
Class {
	#name : 'VespServer',
	#superclass : 'Object',
	#instVars : [
		'dispatcher',
		'server'
	],
	#category : 'VespucciNotebookElementAPI',
	#package : 'VespucciNotebookElementAPI'
}

{ #category : 'public' }
VespServer class >> start [

	| serv |
	serv := self new server: (ZnServer startDefaultOn: 1701).
	serv registerRoutes.
	serv server delegate: serv dispatcher.
	serv server
		logToTranscript;
		start.

	^ serv
]

{ #category : 'public' }
VespServer class >> startOn: aPort [

	| serv |
	serv := self new server: (ZnServer startDefaultOn: aPort).

	serv registerRoutes.
	serv server delegate: serv dispatcher.
	serv server start.

	^ serv
]

{ #category : 'accessing' }
VespServer >> dispatcher [

	^ dispatcher
]

{ #category : 'accessing' }
VespServer >> dispatcher: anObject [

	dispatcher := anObject
]

{ #category : 'public' }
VespServer >> handleRequest: aRequest [

	| postData dict idNb idProject profileName |
	postData := aRequest entity contents.
	dict := (NeoJSONReader on: postData readStream) next.
	
	"Should handle ifAbsent"
	idNb := dict at: 'notebookId' ifAbsent: [ 1 halt ].
	idProject := dict at: 'projectId' ifAbsent: [ 1 halt ].
	profileName := dict at: 'profileName' ifAbsent: [ 1 halt ].

	^ Vespucci fromApiComputeNotebookId: idNb fromProject: idProject
]

{ #category : 'as yet unclassified' }
VespServer >> registerRoutes [

	dispatcher := ZnDispatcherDelegate new.
	dispatcher map: '/compute' to: [ :request :response |
		| postData res |
		res := self handleRequest: request.

		response
			entity: (ZnEntity json: '{"status": "ok"}');
			yourself ]
]

{ #category : 'accessing' }
VespServer >> server [ 

	^server
]

{ #category : 'accessing' }
VespServer >> server: anObject [

	server := anObject
]
