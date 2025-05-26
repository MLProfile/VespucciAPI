Class {
	#name : 'StepImpl',
	#superclass : 'ApiProxy',
	#instVars : [
		'id',
		'position',
		'numberChildren',
		'profile',
		'status',
		'metaStep',
		'element',
		'metaInstructions'
	],
	#category : 'ColombusProxy',
	#package : 'ColombusProxy'
}

{ #category : 'instance creation' }
StepImpl class >> fromJson: aDict element: aNotebookElement [
    ^ self new
        id: (aDict at: 'id');
        position: (aDict at: 'position');
        numberChildren: (aDict at: 'number_children');
        element: aNotebookElement;
        yourself.
]

{ #category : 'instance creation' }
StepImpl class >> fromJson: aDict profile: aProfile [
    ^ self new
        id: (aDict at: 'id');
        position: (aDict at: 'position');
        numberChildren: (aDict at: 'number_children');
        profile: aProfile;
        yourself.
]

{ #category : 'accessing' }
StepImpl >> element: anObject [

	element := anObject
]

{ #category : 'accessing' }
StepImpl >> id [

	^ id
]

{ #category : 'accessing' }
StepImpl >> id: anObject [

	id := anObject
]

{ #category : 'accessing' }
StepImpl >> metaInstructions [
    metaInstructions isNil ifTrue: [
        | json |
        json := self getJsonFrom: 'stepimpls/', id asString, '/metainstructions'.
        metaInstructions := json collect: [:each | MetaInstruction fromJson: each stepImpl: self ].
    ].
    ^ metaInstructions
]

{ #category : 'accessing' }
StepImpl >> metaStep [
    metaStep isNil ifTrue: [
        | json |
        json := self getJsonFrom: 'stepimpls/', id asString, '/metastep'.
        metaStep := MetaStep fromJson: json
    ].
    ^ metaStep
]

{ #category : 'accessing' }
StepImpl >> metaStep: anObject [

	metaStep := anObject
]

{ #category : 'accessing' }
StepImpl >> numberChildren [

	^ numberChildren
]

{ #category : 'accessing' }
StepImpl >> numberChildren: anObject [

	numberChildren := anObject
]

{ #category : 'accessing' }
StepImpl >> position [

	^ position
]

{ #category : 'accessing' }
StepImpl >> position: anObject [

	position := anObject
]

{ #category : 'accessing' }
StepImpl >> profile: anObject [

	profile := anObject
]

{ #category : 'accessing' }
StepImpl >> status [
    status isNil ifTrue: [
        | json |
        json := self getJsonFrom: 'stepimpls/', id asString, '/status'.
        status := StepImplStatus fromJson: json
    ].
    ^ status
]

{ #category : 'accessing' }
StepImpl >> status: anObject [

	status := anObject
]
