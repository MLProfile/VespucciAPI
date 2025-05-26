Class {
	#name : 'MetaInstruction',
	#superclass : 'ApiProxy',
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
MetaInstruction class >> fromJson: aDict element: anElement [
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
MetaInstruction class >> fromJson: aDict stepImpl: aStep [
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
MetaInstruction >> algoFamily [

	^ algoFamily
]

{ #category : 'accessing' }
MetaInstruction >> algoFamily: anObject [

	algoFamily := anObject
]

{ #category : 'accessing' }
MetaInstruction >> algoName [

	^ algoName
]

{ #category : 'accessing' }
MetaInstruction >> algoName: anObject [

	algoName := anObject
]

{ #category : 'accessing' }
MetaInstruction >> element: anElement [

	element := anElement
]

{ #category : 'accessing' }
MetaInstruction >> id [

	^ id
]

{ #category : 'accessing' }
MetaInstruction >> id: anObject [

	id := anObject
]

{ #category : 'accessing' }
MetaInstruction >> numberChildren [

	^ numberChildren
]

{ #category : 'accessing' }
MetaInstruction >> numberChildren: anObject [

	numberChildren := anObject
]

{ #category : 'accessing' }
MetaInstruction >> position [

	^ position
]

{ #category : 'accessing' }
MetaInstruction >> position: anObject [

	position := anObject
]

{ #category : 'accessing' }
MetaInstruction >> stepImpl: aStepImpls [

	stepImpl:= aStepImpls
]
