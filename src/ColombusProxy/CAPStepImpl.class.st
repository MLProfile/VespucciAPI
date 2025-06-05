Class {
	#name : 'CAPStepImpl',
	#superclass : 'CAPApiProxy',
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
CAPStepImpl class >> fromJson: aDict element: aNotebookElement [
    ^ self new
        id: (aDict at: 'id');
        position: (aDict at: 'position');
        numberChildren: (aDict at: 'number_children');
        element: aNotebookElement;
        yourself.
]

{ #category : 'instance creation' }
CAPStepImpl class >> fromJson: aDict profile: aProfile [
    ^ self new
        id: (aDict at: 'id');
        position: (aDict at: 'position');
        numberChildren: (aDict at: 'number_children');
        profile: aProfile;
        yourself.
]

{ #category : 'accessing' }
CAPStepImpl >> element [

	^ element 
]

{ #category : 'accessing' }
CAPStepImpl >> element: anObject [

	element := anObject
]

{ #category : 'accessing' }
CAPStepImpl >> id [

	^ id
]

{ #category : 'accessing' }
CAPStepImpl >> id: anObject [

	id := anObject
]

{ #category : 'accessing' }
CAPStepImpl >> metaInstructions [
    metaInstructions isNil ifTrue: [
        | json |
        json := self getJsonFrom: 'stepimpls/', id asString, '/metainstructions'.
        metaInstructions := json collect: [:each | CAPMetaInstruction fromJson: each stepImpl: self ].
    ].
    ^ metaInstructions
]

{ #category : 'accessing' }
CAPStepImpl >> metaStep [
    metaStep isNil ifTrue: [
        | json |
        json := self getJsonFrom: 'stepimpls/', id asString, '/metastep'.
        metaStep := CAPMetaStep fromJson: json stepImpl: self
    ].
    ^ metaStep
]

{ #category : 'accessing' }
CAPStepImpl >> metaStep: anObject [

	metaStep := anObject
]

{ #category : 'accessing' }
CAPStepImpl >> numberChildren [

	^ numberChildren
]

{ #category : 'accessing' }
CAPStepImpl >> numberChildren: anObject [

	numberChildren := anObject
]

{ #category : 'accessing' }
CAPStepImpl >> position [

	^ position
]

{ #category : 'accessing' }
CAPStepImpl >> position: anObject [

	position := anObject
]

{ #category : 'accessing' }
CAPStepImpl >> profile: anObject [

	profile := anObject
]

{ #category : 'accessing' }
CAPStepImpl >> status [
    status isNil ifTrue: [
        | json |
        json := self getJsonFrom: 'stepimpls/', id asString, '/status'.
        status := CAPStepImplStatus fromJson: json
    ].
    ^ status
]

{ #category : 'accessing' }
CAPStepImpl >> status: anObject [

	status := anObject
]
