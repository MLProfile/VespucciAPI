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
