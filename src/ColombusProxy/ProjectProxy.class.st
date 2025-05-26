Class {
	#name : 'ProjectProxy',
	#superclass : 'ApiProxy',
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
ProjectProxy class >> fromJson: aDict [
    ^ self new
        id: (aDict at: 'id');
        name: (aDict at: 'name');
        yourself.
]

{ #category : 'accessing' }
ProjectProxy >> id [

	^ id
]

{ #category : 'accessing' }
ProjectProxy >> id: anObject [

	id := anObject
]

{ #category : 'as yet unclassified' }
ProjectProxy >> id: anId name: aName [
    id := anId.
    name := aName.
]

{ #category : 'accessing' }
ProjectProxy >> name [

	^ name
]

{ #category : 'accessing' }
ProjectProxy >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
ProjectProxy >> notebooks [
    notebooks isNil ifTrue: [
        | json |
        json := self getJsonFrom: 'projects/', id asString, '/notebooks'.
        notebooks := json collect: [:each | Notebook fromJson: each project: self ].
    ].
    ^ notebooks
]

{ #category : 'accessing' }
ProjectProxy >> profiles [
    profiles isNil ifTrue: [
        | json |
        json := self getJsonFrom: 'projects/', id asString, '/profiles'.
        profiles := json collect: [:each | Profile fromJson: each project: self ].
    ].
    ^ profiles
]
