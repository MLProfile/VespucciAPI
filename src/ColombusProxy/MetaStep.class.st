Class {
	#name : 'MetaStep',
	#superclass : 'ApiProxy',
	#instVars : [
		'id',
		'name'
	],
	#category : 'ColombusProxy',
	#package : 'ColombusProxy'
}

{ #category : 'instance creation' }
MetaStep class >> fromJson: aDict [
    ^ self new
        id: (aDict at: 'id');
        name: (aDict at: 'name');
        yourself.
]

{ #category : 'accessing' }
MetaStep >> id [

	^ id
]

{ #category : 'accessing' }
MetaStep >> id: anObject [

	id := anObject
]

{ #category : 'accessing' }
MetaStep >> name [

	^ name
]

{ #category : 'accessing' }
MetaStep >> name: anObject [

	name := anObject
]
