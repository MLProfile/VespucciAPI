Class {
	#name : 'CAPNotebook',
	#superclass : 'CAPApiProxy',
	#instVars : [
		'id',
		'name',
		'url',
		'project',
		'elements',
		'profile',
		'notebookModel',
		'inconsistencies'
	],
	#category : 'ColombusProxy',
	#package : 'ColombusProxy'
}

{ #category : 'instance creation' }
CAPNotebook class >> fromJson: aDict [ 
    ^ self new
        id: (aDict at: 'id');
        name: (aDict at: 'name');
        url: (aDict at: 'url');
        yourself.
]

{ #category : 'instance creation' }
CAPNotebook class >> fromJson: aDict profile: aProfile [
    ^ self new
        id: (aDict at: 'id');
        name: (aDict at: 'name');
        url: (aDict at: 'url');
        profile: aProfile;
        yourself.
]

{ #category : 'instance creation' }
CAPNotebook class >> fromJson: aDict project: aProject [
    ^ self new
        id: (aDict at: 'id');
        name: (aDict at: 'name');
        url: (aDict at: 'url');
        project: aProject;
        yourself.
]

{ #category : 'as yet unclassified' }
CAPNotebook >> allMetaStep [

	^ self elements flatCollect: [ :e | e stepImpls collect: [:stepimpl | stepimpl metaStep] ]
]

{ #category : 'as yet unclassified' }
CAPNotebook >> allProjectStepImpl [

 ^ self allSousGraph collect: [ :sg | sg notebookElements flatCollect: [ :nbe | nbe stepImpls ]]
]

{ #category : 'as yet unclassified' }
CAPNotebook >> allSousGraph [

	| seenIds result |
	seenIds := Set new.
	result := OrderedCollection new.
	self elements do: [ :e |
			| sg |
			sg := e sousGraph.
			(sg notNil and: [ (seenIds includes: sg id) not ]) ifTrue: [
					seenIds add: sg id.
					result add: sg ] ].
	^ result
]

{ #category : 'as yet unclassified' }
CAPNotebook >> allStepImpl [

	^ self elements flatCollect: [ :e | e stepImpls ]
]

{ #category : 'as yet unclassified' }
CAPNotebook >> detectNewInconsistenciesByMetaStep [

	| newInconsistencies seenSGs |
	newInconsistencies := OrderedCollection new.
	seenSGs := Set new.

	self elements do: [ :nbe |
			| sg |
			
			nbe loadSgAndLinkedElemtents.
			sg := nbe sousGraph.

			(seenSGs anySatisfy: [ :seenSg | seenSg id = sg id ]) ifFalse: [ 
					| allElements groupedByMetaStep |
					seenSGs add: sg.


					allElements := sg notebookElements.
					groupedByMetaStep := sg notebookElementsByMetaSteps.


					groupedByMetaStep size > 1 ifTrue: [
							| newInconsistency |
							newInconsistency := CAPInconsistency new
								                    sousGraph: sg;
								                    description:
									                    'MetaStep mismatch detected from notebook '
									                    , self name;
								                    detectionDate: DateAndTime now;
								                    yourself.

							(groupedByMetaStep values flatCollect: [ :group | group ])
								asSet do: [ :el | newInconsistency addElement: el ].

							newInconsistencies add: newInconsistency ] ] ].

	^ newInconsistencies
]

{ #category : 'accessing' }
CAPNotebook >> elements [
    elements ifNil: [
        | json |
        json := self getJsonFrom: 'notebooks/', id asString, '/elements'.
        elements := json collect: [:each | CAPNotebookElement fromJson: each notebook: self ].
    ].
    ^ elements
]

{ #category : 'as yet unclassified' }
CAPNotebook >> getLlmInconsistencies [

	| llmInconsistencies |
	llmInconsistencies := self detectNewInconsistenciesByMetaStep select: #areLlmInconsistencies .
	^ llmInconsistencies collect: [ :i | i -> i getLlmMetaStepNames ]
]

{ #category : 'accessing' }
CAPNotebook >> id [

	^ id
]

{ #category : 'accessing' }
CAPNotebook >> id: anObject [

	id := anObject
]

{ #category : 'accessing' }
CAPNotebook >> inconsistencies [

    inconsistencies ifNil: [
        | json |
        json := self getJsonFrom: 'notebooks/', id asString, '/inconsistencies'.
        inconsistencies := json collect: [:each |
            CAPInconsistency fromJson: each notebook: self
        ].
    ].
    ^ inconsistencies

]

{ #category : 'accessing' }
CAPNotebook >> name [

	^ name
]

{ #category : 'accessing' }
CAPNotebook >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
CAPNotebook >> notebookModel [

	notebookModel ifNil: [
			| json |
			json := self getJsonFrom: 'notebooks/' , id asString , '/model'.
			notebookModel := CAPNotebookModel fromJson: json notebook: self ].
	^ notebookModel
]

{ #category : 'accessing' }
CAPNotebook >> profile [

	profile ifNil: [
			| json |
			json := self getJsonFrom: 'notebooks/' , id asString , '/profile'.
			profile := CAPProfile fromJson: json ].
	^ profile
]

{ #category : 'accessing' }
CAPNotebook >> profile: aProfile [ 

	profile := aProfile 
]

{ #category : 'accessing' }
CAPNotebook >> project [

	project ifNil: [
			| json |
			json := self getJsonFrom: 'notebook/' , id asString , '/project'.
			project := CAPProject fromJson: json ].
	^ project
]

{ #category : 'accessing' }
CAPNotebook >> project: anObject [

	project := anObject
]

{ #category : 'accessing' }
CAPNotebook >> url [

	^ url
]

{ #category : 'accessing' }
CAPNotebook >> url: anObject [

	url := anObject
]
