Class {
	#name : 'CAPMetaInstruction',
	#superclass : 'CAPApiProxy',
	#instVars : [
		'id',
		'algoFamily',
		'algoName',
		'position',
		'numberChildren',
		'stepImpl',
		'element'
	],
	#category : 'ColombusProxy',
	#package : 'ColombusProxy'
}

{ #category : 'instance creation' }
CAPMetaInstruction class >> fromJson: aDict element: anElement [
    ^ self new
        id: (aDict at: 'id');
        algoFamily: (aDict at: 'algo_family');
        algoName: (aDict at: 'algo_name');
        position: (aDict at: 'position');
        numberChildren: (aDict at: 'number_children');
        element: anElement;
        yourself.
]

{ #category : 'instance creation' }
CAPMetaInstruction class >> fromJson: aDict stepImpl: aStep [
    ^ self new
        id: (aDict at: 'id');
        algoName: (aDict at: 'algo_name');
        algoFamily: (aDict at: 'algo_family');
        position: (aDict at: 'position');
        numberChildren: (aDict at: 'number_children');
        stepImpl: aStep;
        yourself.
]

{ #category : 'accessing' }
CAPMetaInstruction >> algoFamily [

	^ algoFamily
]

{ #category : 'accessing' }
CAPMetaInstruction >> algoFamily: anObject [

	algoFamily := anObject
]

{ #category : 'accessing' }
CAPMetaInstruction >> algoName [

	^ algoName
]

{ #category : 'accessing' }
CAPMetaInstruction >> algoName: anObject [

	algoName := anObject
]

{ #category : 'accessing' }
CAPMetaInstruction >> element: anElement [

	element := anElement
]

{ #category : 'accessing' }
CAPMetaInstruction >> id [

	^ id
]

{ #category : 'accessing' }
CAPMetaInstruction >> id: anObject [

	id := anObject
]

{ #category : 'accessing' }
CAPMetaInstruction >> numberChildren [

	^ numberChildren
]

{ #category : 'accessing' }
CAPMetaInstruction >> numberChildren: anObject [

	numberChildren := anObject
]

{ #category : 'accessing' }
CAPMetaInstruction >> position [

	^ position
]

{ #category : 'accessing' }
CAPMetaInstruction >> position: anObject [

	position := anObject
]

{ #category : 'accessing' }
CAPMetaInstruction >> stepImpl: aStepImpls [

	stepImpl:= aStepImpls
]
