Class {
	#name : 'ColombusModelInconsistancyS',
	#superclass : 'Object',
	#instVars : [
		'description',
		'elements'
	],
	#category : 'NotebookTag',
	#package : 'NotebookTag'
}

{ #category : 'converting' }
ColombusModelInconsistancyS >> asDictionary [
    ^ Dictionary new
        at: 'description' put: description;
        at: 'elements' put: elements;
        yourself.
]

{ #category : 'accessing' }
ColombusModelInconsistancyS >> description [

	^ description
]

{ #category : 'accessing' }
ColombusModelInconsistancyS >> description: anObject [

	description := anObject
]

{ #category : 'accessing' }
ColombusModelInconsistancyS >> elements [

	^ elements asDictionary 
]

{ #category : 'accessing' }
ColombusModelInconsistancyS >> elements: anObject [

	elements addLast: anObject
]

{ #category : 'initialization' }
ColombusModelInconsistancyS >> initialize [ 

	elements := OrderedCollection new.
]
