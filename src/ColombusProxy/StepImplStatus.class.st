Class {
	#name : 'StepImplStatus',
	#superclass : 'ApiProxy',
	#instVars : [
		'id',
		'name'
	],
	#category : 'ColombusProxy',
	#package : 'ColombusProxy'
}

{ #category : 'instance creation' }
StepImplStatus class >> fromJson: aDict [
    ^ self new
        id: (aDict at: 'id');
        name: (aDict at: 'name');
        yourself.
]

{ #category : 'accessing' }
StepImplStatus >> id [

	^ id
]

{ #category : 'accessing' }
StepImplStatus >> id: anObject [

	id := anObject
]

{ #category : 'accessing' }
StepImplStatus >> name [

	^ name
]

{ #category : 'accessing' }
StepImplStatus >> name: anObject [

	name := anObject
]
