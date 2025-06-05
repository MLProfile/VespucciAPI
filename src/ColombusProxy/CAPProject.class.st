Class {
	#name : 'CAPProject',
	#superclass : 'CAPApiProxy',
	#instVars : [
		'id',
		'name',
		'notebooks',
		'profiles'
	],
	#category : 'ColombusProxy',
	#package : 'ColombusProxy'
}

{ #category : 'instance creation' }
CAPProject class >> fromJson: aDict [
    ^ self new
        id: (aDict at: 'id');
        name: (aDict at: 'name');
        yourself.
]

{ #category : 'accessing' }
CAPProject >> id [

	^ id
]

{ #category : 'accessing' }
CAPProject >> id: anObject [

	id := anObject
]

{ #category : 'as yet unclassified' }
CAPProject >> id: anId name: aName [
    id := anId.
    name := aName.
]

{ #category : 'accessing' }
CAPProject >> name [

	^ name
]

{ #category : 'accessing' }
CAPProject >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
CAPProject >> notebooks [
    notebooks isNil ifTrue: [
        | json |
        json := self getJsonFrom: 'projects/', id asString, '/notebooks'.
        notebooks := json collect: [:each | CAPNotebook fromJson: each project: self ].
    ].
    ^ notebooks
]

{ #category : 'accessing' }
CAPProject >> profiles [
    profiles isNil ifTrue: [
        | json |
        json := self getJsonFrom: 'projects/', id asString, '/profiles'.
        profiles := json collect: [:each | CAPProfile fromJson: each project: self ].
    ].
    ^ profiles
]
