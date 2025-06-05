Class {
	#name : 'CAPTypeSG',
	#superclass : 'CAPApiProxy',
	#instVars : [
		'id',
		'name',
		'internalValue'
	],
	#category : 'ColombusProxy',
	#package : 'ColombusProxy'
}

{ #category : 'instance creation' }
CAPTypeSG class >> fromJson: aDict [
    ^ self new
        id: (aDict at: 'id');
        name: (aDict at: 'name');
        internalValue: (aDict at: 'value');
        yourself.
]

{ #category : 'accessing' }
CAPTypeSG >> id [

	^ id
]

{ #category : 'accessing' }
CAPTypeSG >> id: anObject [

	id := anObject
]

{ #category : 'accessing' }
CAPTypeSG >> internalValue [

	^ internalValue
]

{ #category : 'accessing' }
CAPTypeSG >> internalValue: anObject [

	internalValue := anObject
]

{ #category : 'accessing' }
CAPTypeSG >> name [

	^ name
]

{ #category : 'accessing' }
CAPTypeSG >> name: anObject [

	name := anObject
]
