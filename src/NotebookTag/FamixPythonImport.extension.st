Extension { #name : 'FamixPythonImport' }

{ #category : '*NotebookTag' }
FamixPythonImport >> endPos [ 

    <FMProperty: #endPos type: #String>
    <FMComment: 'endPos of this entity'>
    ^ self attributeAt: #endPos ifAbsent: [  ]
]

{ #category : '*NotebookTag' }
FamixPythonImport >> endPos: aPosString [ 

    self attributeAt: #endPos put: aPosString.
]

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

{ #category : '*NotebookTag' }
FamixPythonImport >> startPos [ 

    <FMProperty: #startPos type: #String>
    <FMComment: 'startPos of this entity'>
    ^ self attributeAt: #startPos ifAbsent: [  ]
]

{ #category : '*NotebookTag' }
FamixPythonImport >> startPos: aPosString [ 

    self attributeAt: #startPos put: aPosString.
]
