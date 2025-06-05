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
