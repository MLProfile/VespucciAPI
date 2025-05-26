Class {
	#name : 'Profile',
	#superclass : 'ApiProxy',
	#instVars : [
		'id',
		'name',
		'jsonProfile',
		'project',
		'notebooks',
		'stepImpls'
	],
	#category : 'ColombusProxy',
	#package : 'ColombusProxy'
}

{ #category : 'instance creation' }
Profile class >> fromJson: aDict [
    ^ self new
        id: (aDict at: 'id');
        name: (aDict at: 'name');
        jsonProfile: (aDict at: 'json_profile');
        yourself.
]

{ #category : 'instance creation' }
Profile class >> fromJson: aDict project: aProject [

	^ self new
		  id: (aDict at: 'id');
		  name: (aDict at: 'name');
		  jsonProfile: (aDict at: 'json_profile');
		  project: aProject;
		  yourself
]

{ #category : 'accessing' }
Profile >> id [

	^ id
]

{ #category : 'accessing' }
Profile >> id: anObject [

	id := anObject
]

{ #category : 'accessing' }
Profile >> jsonProfile [

	^ jsonProfile
]

{ #category : 'accessing' }
Profile >> jsonProfile: anObject [

	jsonProfile := anObject
]

{ #category : 'accessing' }
Profile >> name [

	^ name
]

{ #category : 'accessing' }
Profile >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
Profile >> notebooks [
    notebooks isNil ifTrue: [
        | json |
        json := self getJsonFrom: 'profiles/', id asString, '/notebooks'.
        notebooks := json collect: [:each | Notebook fromJson: each profile: self ].
    ].
    ^ notebooks
]

{ #category : 'accessing' }
Profile >> project [

	^ project
]

{ #category : 'accessing' }
Profile >> project: anObject [

	project := anObject
]

{ #category : 'accessing' }
Profile >> stepImpls [
    stepImpls isNil ifTrue: [
        | json |
        json := self getJsonFrom: 'profiles/', id asString, '/stepimpls'.
        stepImpls := json collect: [:each | StepImpl fromJson: each profile: self ].
    ].
    ^ stepImpls
]
