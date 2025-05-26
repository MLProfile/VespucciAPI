Class {
	#name : 'NotebookElement',
	#superclass : 'ApiProxy',
	#instVars : [
		'id',
		'startLine',
		'endLine',
		'startPos',
		'endPos',
		'library',
		'function',
		'isComposition',
		'notebook',
		'metaInstruction',
		'stepImpls'
	],
	#category : 'ColombusProxy',
	#package : 'ColombusProxy'
}

{ #category : 'instance creation' }
NotebookElement class >> fromJson: aDict notebook: aNotebook [
    ^ self new
        id: (aDict at: 'id');
        startLine: (aDict at: 'start_line');
        endLine: (aDict at: 'end_line');
        startPos: (aDict at: 'start_pos');
        endPos: (aDict at: 'end_pos');
        library: (aDict at: 'library');
        function: (aDict at: 'function');
        isComposition: (aDict at: 'is_composition');
        notebook: aNotebook;
        yourself.
]

{ #category : 'accessing' }
NotebookElement >> endLine [

	^ endLine
]

{ #category : 'accessing' }
NotebookElement >> endLine: anObject [

	endLine := anObject
]

{ #category : 'accessing' }
NotebookElement >> endPos [

	^ endPos
]

{ #category : 'accessing' }
NotebookElement >> endPos: anObject [

	endPos := anObject
]

{ #category : 'accessing' }
NotebookElement >> function [

	^ function
]

{ #category : 'accessing' }
NotebookElement >> function: anObject [

	function := anObject
]

{ #category : 'accessing' }
NotebookElement >> id [

	^ id
]

{ #category : 'accessing' }
NotebookElement >> id: anObject [

	id := anObject
]

{ #category : 'accessing' }
NotebookElement >> isComposition [

	^ isComposition
]

{ #category : 'accessing' }
NotebookElement >> isComposition: anObject [

	isComposition := anObject
]

{ #category : 'accessing' }
NotebookElement >> library [

	^ library
]

{ #category : 'accessing' }
NotebookElement >> library: anObject [

	library := anObject
]

{ #category : 'accessing' }
NotebookElement >> metaInstruction [
    metaInstruction isNil ifTrue: [
        | json |
        json := self getJsonFrom: 'notebookelements/', id asString, '/metainstruction'.
        metaInstruction := MetaInstruction fromJson: json element: self.
    ].
    ^ metaInstruction
]

{ #category : 'accessing' }
NotebookElement >> notebook [

	^ notebook
]

{ #category : 'accessing' }
NotebookElement >> notebook: anObject [

	notebook := anObject
]

{ #category : 'accessing' }
NotebookElement >> startLine [

	^ startLine
]

{ #category : 'accessing' }
NotebookElement >> startLine: anObject [

	startLine := anObject
]

{ #category : 'accessing' }
NotebookElement >> startPos [

	^ startPos
]

{ #category : 'accessing' }
NotebookElement >> startPos: anObject [

	startPos := anObject
]

{ #category : 'accessing' }
NotebookElement >> stepImpls [
    stepImpls isNil ifTrue: [
        | json |
        json := self getJsonFrom: 'notebookelements/', id asString, '/stepimpls'.
        stepImpls := json collect: [:each | StepImpl fromJson: each element: self ].
    ].
    ^ stepImpls
]
