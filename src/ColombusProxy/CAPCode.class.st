Class {
	#name : 'CAPCode',
	#superclass : 'CAPApiProxy',
	#instVars : [
		'id',
		'content',
		'position',
		'sousgraph'
	],
	#category : 'ColombusProxy',
	#package : 'ColombusProxy'
}

{ #category : 'instance creation' }
CAPCode class >> fromJson: aDict sousgraph: aSG [
    ^ self new
        id: (aDict at: 'id');
        content: (aDict at: 'content');
        position: (aDict at: 'position');
        sousgraph: aSG;
        yourself.
]

{ #category : 'accessing' }
CAPCode >> content [

	^ content
]

{ #category : 'accessing' }
CAPCode >> content: anObject [

	content := anObject
]

{ #category : 'accessing' }
CAPCode >> id [

	^ id
]

{ #category : 'accessing' }
CAPCode >> id: anObject [

	id := anObject
]

{ #category : 'accessing' }
CAPCode >> position [

	^ position
]

{ #category : 'accessing' }
CAPCode >> position: anObject [

	position := anObject
]

{ #category : 'accessing' }
CAPCode >> sousgraph [

	^ sousgraph
]

{ #category : 'accessing' }
CAPCode >> sousgraph: anObject [

	sousgraph := anObject
]
