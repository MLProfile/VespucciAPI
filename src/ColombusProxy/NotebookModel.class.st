Class {
	#name : 'NotebookModel',
	#superclass : 'ApiProxy',
	#instVars : [
		'id',
		'notebook',
		'internalValue'
	],
	#category : 'ColombusProxy',
	#package : 'ColombusProxy'
}

{ #category : 'instance creation' }
NotebookModel class >> fromJson: aDict notebook: aNotebook [
    ^ self new
        id: (aDict at: 'id');
        internalValue: (aDict at: 'value');
        notebook: aNotebook;
        yourself.
]

{ #category : 'accessing' }
NotebookModel >> id [

	^ id
]

{ #category : 'accessing' }
NotebookModel >> id: anObject [

	id := anObject
]

{ #category : 'accessing' }
NotebookModel >> internalValue [

	^ internalValue
]

{ #category : 'accessing' }
NotebookModel >> internalValue: anObject [

	internalValue := anObject
]

{ #category : 'installing' }
NotebookModel >> load [

	| stream |
	stream := NeoJSONWriter toJSONReadStream: internalValue.
	^ FamixPythonModel new importFromJSONStream: stream
]

{ #category : 'as yet unclassified' }
NotebookModel >> modelAsJson [ 

 ^ NeoJSONWriter toString: (self internalValue) 
]

{ #category : 'accessing' }
NotebookModel >> notebook: anObject [

	notebook := anObject
]
