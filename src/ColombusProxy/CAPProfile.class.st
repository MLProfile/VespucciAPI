Class {
	#name : 'CAPProfile',
	#superclass : 'CAPApiProxy',
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
CAPProfile class >> fromJson: aDict [
    ^ self new
        id: (aDict at: 'id');
        name: (aDict at: 'name');
        jsonProfile: (aDict at: 'json_profile');
        yourself.
]

{ #category : 'instance creation' }
CAPProfile class >> fromJson: aDict project: aProject [

	^ self new
		  id: (aDict at: 'id');
		  name: (aDict at: 'name');
		  jsonProfile: (aDict at: 'json_profile');
		  project: aProject;
		  yourself
]

{ #category : 'accessing' }
CAPProfile >> id [

	^ id
]

{ #category : 'accessing' }
CAPProfile >> id: anObject [

	id := anObject
]

{ #category : 'accessing' }
CAPProfile >> jsonProfile [

	^ jsonProfile
]

{ #category : 'accessing' }
CAPProfile >> jsonProfile: anObject [

	jsonProfile := anObject
]

{ #category : 'accessing' }
CAPProfile >> name [

	^ name
]

{ #category : 'accessing' }
CAPProfile >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
CAPProfile >> notebooks [
    notebooks isNil ifTrue: [
        | json |
        json := self getJsonFrom: 'profiles/', id asString, '/notebooks'.
        notebooks := json collect: [:each | CAPNotebook fromJson: each profile: self ].
    ].
    ^ notebooks
]

{ #category : 'accessing' }
CAPProfile >> project [

	^ project
]

{ #category : 'accessing' }
CAPProfile >> project: anObject [

	project := anObject
]

{ #category : 'accessing' }
CAPProfile >> stepImpls [
    stepImpls isNil ifTrue: [
        | json |
        json := self getJsonFrom: 'profiles/', id asString, '/stepimpls'.
        stepImpls := json collect: [:each | CAPStepImpl fromJson: each profile: self ].
    ].
    ^ stepImpls
]
