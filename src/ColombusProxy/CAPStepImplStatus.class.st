Class {
	#name : 'CAPStepImplStatus',
	#superclass : 'CAPApiProxy',
	#instVars : [
		'id',
		'name'
	],
	#category : 'ColombusProxy',
	#package : 'ColombusProxy'
}

{ #category : 'instance creation' }
CAPStepImplStatus class >> fromJson: aDict [
    ^ self new
        id: (aDict at: 'id');
        name: (aDict at: 'name');
        yourself.
]

{ #category : 'accessing' }
CAPStepImplStatus >> id [

	^ id
]

{ #category : 'accessing' }
CAPStepImplStatus >> id: anObject [

	id := anObject
]

{ #category : 'accessing' }
CAPStepImplStatus >> name [

	^ name
]

{ #category : 'accessing' }
CAPStepImplStatus >> name: anObject [

	name := anObject
]
