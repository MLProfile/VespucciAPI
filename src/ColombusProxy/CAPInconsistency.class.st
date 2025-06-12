Class {
	#name : 'CAPInconsistency',
	#superclass : 'CAPApiProxy',
	#instVars : [
		'id',
		'description',
		'detectionDate',
		'resolutionDate',
		'isResolved',
		'sousGraph',
		'elements'
	],
	#category : 'ColombusProxy',
	#package : 'ColombusProxy'
}

{ #category : 'instance creation' }
CAPInconsistency class >> fromJson: aDict notebook: aNotebook [

	| inst ids |
	inst := self new
		        id: (aDict at: 'id');
		        description: (aDict at: 'description');
		        detectionDate:
			        (DateAndTime fromString: (aDict at: 'detection_date_'));
		        resolutionDate:
			        (DateAndTime fromString: (aDict at: 'resolution_date'));
		        isResolved: (aDict at: 'is_resolved');
		        yourself.


	ids := aDict elements collect: [ :e | e at: 'notebook_element_id' ].

	inst elements:
		(aNotebook elements select: [ :e | ids includes: e id ]).

	^ inst
]

{ #category : 'adding' }
CAPInconsistency >> addElement: anElement [
    self elements ifNil: [ elements := OrderedCollection new ].
    elements add: anElement.
]

{ #category : 'as yet unclassified' }
CAPInconsistency >> areLlmInconsistencies [

	^ (self getLlmMetaSteps collect: #id) asSet size > 1
]

{ #category : 'accessing' }
CAPInconsistency >> description [

	^ description
]

{ #category : 'accessing' }
CAPInconsistency >> description: anObject [

	description := anObject
]

{ #category : 'accessing' }
CAPInconsistency >> detectionDate [

	^ detectionDate
]

{ #category : 'accessing' }
CAPInconsistency >> detectionDate: anObject [

	detectionDate := anObject
]

{ #category : 'as yet unclassified' }
CAPInconsistency >> display [

	| dict |
	dict := self sgValue asDictionary.
	dict at: 'code' put: self elementsCode.
	dict at: 'nbElmnt' put: self elements size.
	dict at: 'metaSteps' put: self metaSteps. 
	^ dict
]

{ #category : 'accessing' }
CAPInconsistency >> elements [

	^ elements
]

{ #category : 'accessing' }
CAPInconsistency >> elements: anObject [

	elements := anObject
]

{ #category : 'as yet unclassified' }
CAPInconsistency >> elementsCode [ 
	
	^ self elements collect: [ :e | e code ]
]

{ #category : 'as yet unclassified' }
CAPInconsistency >> getLlmInconsistencies [
	""

	^ self areLlmInconsistencies
		  ifTrue: [ self ]
		  ifFalse: [ {  } ]
]

{ #category : 'as yet unclassified' }
CAPInconsistency >> getLlmMetaStepNames [

	^ self getLlmMetaSteps collect: #name
]

{ #category : 'as yet unclassified' }
CAPInconsistency >> getLlmMetaSteps [
	""

	^ self metaSteps collect: #second
]

{ #category : 'accessing' }
CAPInconsistency >> id [

	^ id
]

{ #category : 'accessing' }
CAPInconsistency >> id: anObject [

	id := anObject
]

{ #category : 'accessing' }
CAPInconsistency >> isResolved [
    ^ isResolved ifNil: [ false ]
]

{ #category : 'accessing' }
CAPInconsistency >> isResolved: anObject [

	isResolved := anObject
]

{ #category : 'testing' }
CAPInconsistency >> isVespucciUnknown [ 

	^ (self metaSteps collect: #first) first name = 'Unknown' 
]

{ #category : 'as yet unclassified' }
CAPInconsistency >> llmConsistentMetaStep [

	^ self areLlmInconsistencies
		  ifTrue: [ ]
		  ifFalse: [ self getLlmMetaSteps first ]
]

{ #category : 'as yet unclassified' }
CAPInconsistency >> metaSteps [ 

	^ self elements collect: [ :e |  e stepImpls collect: [ :si | si metaStep ]  ].
]

{ #category : 'as yet unclassified' }
CAPInconsistency >> persist [

	| res |
	res := self client
		       post: self class apiUrl , 'vespucci/api/inconsistencies'
		       contents: self toJsonPayload.
	
	self id: (res at: 'id').
	^ res at: 'id'
]

{ #category : 'accessing' }
CAPInconsistency >> projectId [ 

	^ self elements first notebook project id
]

{ #category : 'accessing' }
CAPInconsistency >> resolutionDate [

	^ resolutionDate
]

{ #category : 'accessing' }
CAPInconsistency >> resolutionDate: anObject [

	resolutionDate := anObject
]

{ #category : 'as yet unclassified' }
CAPInconsistency >> sgCode [

	self
		deprecated: 'Use elementsCode instead of current one'
		on: '10 June 2025'
		in:
		'Pharo-13.0.0+SNAPSHOT.build.674.sha.e4d88974a939e8af5b66e2032920fa85414cff6f (64 Bit)'.

	^ self sousGraph code content
]

{ #category : 'as yet unclassified' }
CAPInconsistency >> sgValue [ 
	
	^ self sousGraph internalValue 
]

{ #category : 'accessing' }
CAPInconsistency >> sousGraph [

	^ sousGraph
]

{ #category : 'accessing' }
CAPInconsistency >> sousGraph: anObject [

	sousGraph := anObject
]

{ #category : 'as yet unclassified' }
CAPInconsistency >> toJsonPayload [
    ^ Dictionary new
        at: 'project_id' put: self projectId asString;
        at: 'description' put: self description;
		  at: 'elements' put: (
            self elements flatCollect: [:el |
                el stepImpls collect: [:si |
                    Dictionary new
                        at: 'notebook_element_id' put: el id asString;
                        at: 'metastep_id' put: si metaStep id asString;
                        yourself
                ]
            ]
        );
        yourself.
]
