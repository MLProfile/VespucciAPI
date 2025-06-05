Class {
	#name : 'CAPMetaStep',
	#superclass : 'CAPApiProxy',
	#instVars : [
		'id',
		'name',
		'stepImpl'
	],
	#category : 'ColombusProxy',
	#package : 'ColombusProxy'
}

{ #category : 'instance creation' }
CAPMetaStep class >> fromJson: aDict [
    ^ self new
        id: (aDict at: 'id');
        name: (aDict at: 'name');
        yourself.
]

{ #category : 'instance creation' }
CAPMetaStep class >> fromJson: aDict stepImpl: aStep [
    ^ self new
        id: (aDict at: 'id');
        name: (aDict at: 'name');
        stepImpl: aStep;
        yourself.
]

{ #category : 'accessing' }
CAPMetaStep >> id [

	^ id
]

{ #category : 'accessing' }
CAPMetaStep >> id: anObject [

	id := anObject
]

{ #category : 'accessing' }
CAPMetaStep >> name [

	^ name
]

{ #category : 'accessing' }
CAPMetaStep >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
CAPMetaStep >> stepImpl [

	^ stepImpl
]

{ #category : 'accessing' }
CAPMetaStep >> stepImpl: anObject [

	stepImpl := anObject
]
