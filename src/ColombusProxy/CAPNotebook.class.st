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
		'notebookModel'
	],
	#category : 'ColombusProxy',
	#package : 'ColombusProxy'
}

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
			sg := nbe sousGraph.

			(seenSGs includes: sg) ifFalse: [
					| allElements groupedByMetaStep |
					seenSGs add: sg.

					allElements := sg notebookElements.
					groupedByMetaStep := Dictionary new.

					allElements do: [ :el |
							el stepImpls do: [ :si |
									| name |
									name := si metaStep name.
									(groupedByMetaStep
										 at: name
										 ifAbsentPut: [ OrderedCollection new ]) add: el ] ].
					"1halt."
					groupedByMetaStep size > 1 ifTrue: [
							| newInconsistency |
							newInconsistency := CAPInconsistency new
								                    sousGraph: sg;
								                    description:
									                    'MetaStep mismatch detected from notebook '
									                    , self name;
								                    detectionDate: DateAndTime now;
								                    yourself.

							(groupedByMetaStep values flatCollect: [ :group | group ]) do: [
									:el |
									newInconsistency addElement: el ].

							newInconsistencies add: newInconsistency ] ] ].

	^ newInconsistencies
]

{ #category : 'accessing' }
CAPNotebook >> elements [
    elements isNil ifTrue: [
        | json |
        json := self getJsonFrom: 'notebooks/', id asString, '/elements'.
        elements := json collect: [:each | CAPNotebookElement fromJson: each notebook: self ].
    ].
    ^ elements
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
CAPNotebook >> name [

	^ name
]

{ #category : 'accessing' }
CAPNotebook >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
CAPNotebook >> notebookModel [
    notebookModel isNil ifTrue: [
        | json |
        json := self getJsonFrom: 'notebooks/', id asString, '/model'.
        notebookModel := CAPNotebookModel fromJson: json notebook: self.
    ].
    ^ notebookModel
]

{ #category : 'accessing' }
CAPNotebook >> profile [
    profile isNil ifTrue: [
        | json |
        json := self getJsonFrom: 'notebooks/', id asString, '/profile'.
        profile := CAPProfile fromJson: json.
    ].
    ^ profile
]

{ #category : 'accessing' }
CAPNotebook >> profile: aProfile [ 

	profile := aProfile 
]

{ #category : 'accessing' }
CAPNotebook >> project [

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
