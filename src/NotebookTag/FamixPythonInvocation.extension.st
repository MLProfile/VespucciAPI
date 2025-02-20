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

	| text start end paramsAsString res |
	
	self flag: #todo. 
	"If we have methods or func as arguments the parenthesis break this compute : model.compile(optimizer=optimizers.Adam(), loss=losses.sparse_categorical_crossentropy, metrics=[""accuracy""])"
	text := self sourceAnchor sourceText.
	start := text indexOf: $(.
	end := text indexOf: $).
	paramsAsString := text copyFrom: start + 1 to: end - 1.
	res := paramsAsString splitOn: $,.
	^ res collect: [ :each | each trim ]
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
