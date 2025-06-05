Class {
	#name : 'CAPNotebookModel',
	#superclass : 'CAPApiProxy',
	#instVars : [
		'id',
		'notebook',
		'internalValue'
	],
	#category : 'ColombusProxy',
	#package : 'ColombusProxy'
}

{ #category : 'instance creation' }
CAPNotebookModel class >> fromJson: aDict notebook: aNotebook [
    ^ self new
        id: (aDict at: 'id');
        internalValue: (aDict at: 'value');
        notebook: aNotebook;
        yourself.
]

{ #category : 'accessing' }
CAPNotebookModel >> id [

	^ id
]

{ #category : 'accessing' }
CAPNotebookModel >> id: anObject [

	id := anObject
]

{ #category : 'accessing' }
CAPNotebookModel >> internalValue [

	^ internalValue
]

{ #category : 'accessing' }
CAPNotebookModel >> internalValue: anObject [

	internalValue := anObject
]

{ #category : 'installing' }
CAPNotebookModel >> load [

	| stream |
	stream := NeoJSONWriter toJSONReadStream: internalValue.
	^ FamixPythonModel new importFromJSONStream: stream
]

{ #category : 'as yet unclassified' }
CAPNotebookModel >> modelAsJson [ 

 ^ NeoJSONWriter toString: (self internalValue) 
]

{ #category : 'accessing' }
CAPNotebookModel >> notebook: anObject [

	notebook := anObject
]
