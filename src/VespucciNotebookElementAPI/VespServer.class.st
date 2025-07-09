"
This is a very small and simple server. We define two entry points for vespucci. One to parse, profile and persist a notebook, and one to detect and persist inconsistencies on a notebook to db.

# Routes 

- url:1701/parse
- url:1701/inconsistencies

# Usage 

```
VespServer startOn: 8181.
```

```
curl -X POST http://localhost:1701/parse -d '{""notebookId"": ""88f4453c-30c7-4341-b3ec-4c0ee03e945e"", ""projectId"": ""4f2b506d-0817-4b73-bcef-247f77d63985"", ""profileName"": ""test""}' -H ""Content-Type: application/json""
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

{ #category : 'as yet unclassified' }
VespServer >> handleInconsistenciesRequest: aRequest [

	| postData dict idNb idProject |
	postData := aRequest entity contents.
	dict := (NeoJSONReader on: postData readStream) next.

	"Should handle ifAbsent"
	idNb := dict
		        at: 'notebookId'
		        ifAbsent: [
		        ^ Error new signal: 'notebook id is missing in the request' ].
	idProject := dict
		             at: 'projectId'
		             ifAbsent: [
		             ^ Error new signal:
			               'project id is missing in the request' ].

	^ VPInconsistenciesRunner
		  fromApiPersistInconsistenciesFromNotebookId: idNb
		  fromProject: idProject
]

{ #category : 'public' }
VespServer >> handleParseRequest: aRequest [

	| postData dict idNb idProject profileName |
	postData := aRequest entity contents.
	dict := (NeoJSONReader on: postData readStream) next.

	"Should handle ifAbsent"
	idNb := dict
		        at: 'notebookId'
		        ifAbsent: [
		        ^ Error new signal: 'notebook id is missing in the request' ].
	idProject := dict
		             at: 'projectId'
		             ifAbsent: [
		             ^ Error new signal:
			               'project id is missing in the request' ].
	profileName := dict
		               at: 'profileName'
		               ifAbsent: [
		               ^ Error new signal:
			                 'profile name is missing in the request' ].

	^ Vespucci
		  wipfromApiComputeNotebookId: idNb
		  fromProject: idProject
		  withProfileName: profileName
]

{ #category : 'as yet unclassified' }
VespServer >> registerRoutes [

	dispatcher := ZnDispatcherDelegate new.
	dispatcher map: '/parse' to: [ :request :response |
			| res |
			res := self handleParseRequest: request.

			response
				entity:
					(ZnEntity json:
							 '{"profile": "' , res newProfileId asString , '"}');
				yourself ].
	dispatcher map: '/inconsistencies' to: [ :request :response |
			| res |
			res := self handleInconsistenciesRequest: request.
			"Ce serait mieux de ollect les id des inconsistences et de les renvoyer"
			response
				entity: (ZnEntity json:
							 '{"count": "' , res inconsistencies size asString , '"}');
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
