Class {
	#name : 'Notebook',
	#superclass : 'ApiProxy',
	#instVars : [
		'id',
		'name',
		'url',
		'project',
		'elements',
		'profile'
	],
	#category : 'ColombusProxy',
	#package : 'ColombusProxy'
}

{ #category : 'instance creation' }
Notebook class >> fromJson: aDict profile: aProfile [
    ^ self new
        id: (aDict at: 'id');
        name: (aDict at: 'name');
        url: (aDict at: 'url');
        profile: aProfile;
        yourself.
]

{ #category : 'instance creation' }
Notebook class >> fromJson: aDict project: aProject [
    ^ self new
        id: (aDict at: 'id');
        name: (aDict at: 'name');
        url: (aDict at: 'url');
        project: aProject;
        yourself.
]

{ #category : 'accessing' }
Notebook >> elements [
    elements isNil ifTrue: [
        | json |
        json := self getJsonFrom: 'notebooks/', id asString, '/elements'.
        elements := json collect: [:each | NotebookElement fromJson: each notebook: self ].
    ].
    ^ elements
]

{ #category : 'accessing' }
Notebook >> id [

	^ id
]

{ #category : 'accessing' }
Notebook >> id: anObject [

	id := anObject
]

{ #category : 'accessing' }
Notebook >> name [

	^ name
]

{ #category : 'accessing' }
Notebook >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
Notebook >> profile [
    profile isNil ifTrue: [
        | json |
        json := self getJsonFrom: 'notebooks/', id asString, '/profile'.
        profile := Profile fromJson: json.
    ].
    ^ profile
]

{ #category : 'accessing' }
Notebook >> profile: aProfile [ 

	profile := aProfile 
]

{ #category : 'accessing' }
Notebook >> project [

	^ project
]

{ #category : 'accessing' }
Notebook >> project: anObject [

	project := anObject
]

{ #category : 'accessing' }
Notebook >> url [

	^ url
]

{ #category : 'accessing' }
Notebook >> url: anObject [

	url := anObject
]
