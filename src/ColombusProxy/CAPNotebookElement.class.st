Class {
	#name : 'CAPNotebookElement',
	#superclass : 'CAPApiProxy',
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
CAPNotebookElement class >> fromJson: aDict notebook: aNotebook [
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
CAPNotebookElement >> endLine [

	^ endLine
]

{ #category : 'accessing' }
CAPNotebookElement >> endLine: anObject [

	endLine := anObject
]

{ #category : 'accessing' }
CAPNotebookElement >> endPos [

	^ endPos
]

{ #category : 'accessing' }
CAPNotebookElement >> endPos: anObject [

	endPos := anObject
]

{ #category : 'accessing' }
CAPNotebookElement >> function [

	^ function
]

{ #category : 'accessing' }
CAPNotebookElement >> function: anObject [

	function := anObject
]

{ #category : 'accessing' }
CAPNotebookElement >> id [

	^ id
]

{ #category : 'accessing' }
CAPNotebookElement >> id: anObject [

	id := anObject
]

{ #category : 'accessing' }
CAPNotebookElement >> isComposition [

	^ isComposition
]

{ #category : 'accessing' }
CAPNotebookElement >> isComposition: anObject [

	isComposition := anObject
]

{ #category : 'accessing' }
CAPNotebookElement >> library [

	^ library
]

{ #category : 'accessing' }
CAPNotebookElement >> library: anObject [

	library := anObject
]

{ #category : 'accessing' }
CAPNotebookElement >> metaInstruction [
    metaInstruction isNil ifTrue: [
        | json |
        json := self getJsonFrom: 'notebookelements/', id asString, '/metainstruction'.
        metaInstruction := CAPMetaInstruction fromJson: json element: self.
    ].
    ^ metaInstruction
]

{ #category : 'accessing' }
CAPNotebookElement >> notebook [

	^ notebook
]

{ #category : 'accessing' }
CAPNotebookElement >> notebook: anObject [

	notebook := anObject
]

{ #category : 'accessing' }
CAPNotebookElement >> startLine [

	^ startLine
]

{ #category : 'accessing' }
CAPNotebookElement >> startLine: anObject [

	startLine := anObject
]

{ #category : 'accessing' }
CAPNotebookElement >> startPos [

	^ startPos
]

{ #category : 'accessing' }
CAPNotebookElement >> startPos: anObject [

	startPos := anObject
]

{ #category : 'accessing' }
CAPNotebookElement >> stepImpls [
    stepImpls isNil ifTrue: [
        | json |
        json := self getJsonFrom: 'notebookelements/', id asString, '/stepimpls'.
        stepImpls := json collect: [:each | CAPStepImpl fromJson: each element: self ].
    ].
    ^ stepImpls
]
