Extension { #name : 'FamixPythonInvocation' }

{ #category : '*NotebookTag' }
FamixPythonInvocation >> arguments [ 

    <FMProperty: #arguments type: #String>
    <FMComment: 'Invocation arguments'>
    ^ self attributeAt: #arguments ifAbsent: [  ]
]

{ #category : '*NotebookTag' }
FamixPythonInvocation >> arguments: anArgumentcollection [ 

	self attributeAt: #arguments put: anArgumentcollection.
]

{ #category : '*NotebookTag' }
FamixPythonInvocation >> computeArgs [

	| text start end paramsAsString level i char paramsList currentParam |
	self flag: #todo.
	"Thx to Pharo gpt but I will consider this as unstabble -> need to refacto"
	text := self sourceAnchor sourceText.

	start := text indexOf: $(.

	level := 1.
	i := start + 1.
	[ i <= text size and: [ level > 0 ] ] whileTrue: [
		char := text at: i.
		char = $( ifTrue: [ level := level + 1 ].
		char = $) ifTrue: [ level := level - 1 ].
		i := i + 1 ].
	end := i - 1.

	paramsAsString := text copyFrom: start + 1 to: end - 1.

	paramsList := OrderedCollection new.
	currentParam := ''.
	level := 0.
	1 to: paramsAsString size do: [ :i |
		char := paramsAsString at: i.
		char = $( ifTrue: [ level := level + 1 ].
		char = $) ifTrue: [ level := level - 1 ].
		(char = $, and: [ level = 0 ])
			ifTrue: [
				paramsList add: currentParam trim.
				currentParam := '' ]
			ifFalse: [ currentParam := currentParam , char asString ] ].

	currentParam size > 0 ifTrue: [ paramsList add: currentParam trim ].
	^ paramsList
]

{ #category : '*NotebookTag' }
FamixPythonInvocation >> computePackage [

	| module toPrint current parent |
	self flag: #TODO.
	"Dans le cas ou l'on a plusieurs candidates cela ne fonctionne pas"
	module := self candidates first.
	toPrint := OrderedCollection new.

	current := module.
	[ 
		(current respondsTo: #parentPackage) 
			and: [ (parent := current parentPackage) isNotNil ] 
	] whileTrue: [ 
		toPrint add: parent.
		current := parent 
	].

	^ $. join: (toPrint reverse collect: #name)
]

{ #category : '*NotebookTag' }
FamixPythonInvocation >> endPos [ 

    <FMProperty: #endPos type: #String>
    <FMComment: 'endPos of this entity'>
    ^ self attributeAt: #endPos ifAbsent: [  ]
]

{ #category : '*NotebookTag' }
FamixPythonInvocation >> endPos: aPosString [ 

    self attributeAt: #endPos put: aPosString.
]

{ #category : '*NotebookTag' }
FamixPythonInvocation >> function [ 

    <FMProperty: #function type: #String>
    <FMComment: 'Function or method invocked'>
    ^ self attributeAt: #function ifAbsent: [  ]
]

{ #category : '*NotebookTag' }
FamixPythonInvocation >> function: aFunctionName [ 

    self attributeAt: #function put: aFunctionName.
]

{ #category : '*NotebookTag' }
FamixPythonInvocation >> library [ 

    <FMProperty: #library type: #String>
    <FMComment: 'Library of the invocation'>
    ^ self attributeAt: #library ifAbsent: [  ]
]

{ #category : '*NotebookTag' }
FamixPythonInvocation >> library: aLibraryName [ 

    self attributeAt: #library put: aLibraryName.
]

{ #category : '*NotebookTag' }
FamixPythonInvocation >> startPos [ 

    <FMProperty: #startPos type: #String>
    <FMComment: 'startPos of this entity'>
    ^ self attributeAt: #startPos ifAbsent: [  ]
]

{ #category : '*NotebookTag' }
FamixPythonInvocation >> startPos: aPosString [ 

    self attributeAt: #startPos put: aPosString.
]
