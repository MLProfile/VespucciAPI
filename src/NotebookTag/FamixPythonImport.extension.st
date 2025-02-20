Extension { #name : 'FamixPythonImport' }

{ #category : '*NotebookTag' }
FamixPythonImport >> importOf [ 

    <FMProperty: #importOf type: #String>
    <FMComment: 'The entity imported'>
    ^ self attributeAt: #importOf ifAbsent: [  ]
]

{ #category : '*NotebookTag' }
FamixPythonImport >> importOf: anImportedEntityName [ 

    self attributeAt: #importOf put: anImportedEntityName.
]

{ #category : '*NotebookTag' }
FamixPythonImport >> package [ 

    <FMProperty: #package type: #String>
    <FMComment: 'This import come from this package'>
    ^ self attributeAt: #package ifAbsent: [  ]
]

{ #category : '*NotebookTag' }
FamixPythonImport >> package: aPackageNane [ 

    self attributeAt: #package put: aPackageNane.
]
