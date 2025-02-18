Extension { #name : 'FamixPythonInvocation' }

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
