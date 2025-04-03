Extension { #name : 'FamixPythonImport' }

{ #category : '*VespucciNotebookElementExtractor' }
FamixPythonImport >> endPos [ 

    <FMProperty: #endPos type: #String>
    <FMComment: 'endPos of this entity'>
    ^ self attributeAt: #endPos ifAbsent: [  ]
]

{ #category : '*VespucciNotebookElementExtractor' }
FamixPythonImport >> endPos: aPosString [ 

    self attributeAt: #endPos put: aPosString.
]

{ #category : '*VespucciNotebookElementExtractor' }
FamixPythonImport >> importOf [ 

    <FMProperty: #importOf type: #String>
    <FMComment: 'The entity imported'>
    ^ self attributeAt: #importOf ifAbsent: [  ]
]

{ #category : '*VespucciNotebookElementExtractor' }
FamixPythonImport >> importOf: anImportedEntityName [ 

    self attributeAt: #importOf put: anImportedEntityName.
]

{ #category : '*VespucciNotebookElementExtractor' }
FamixPythonImport >> package [ 

    <FMProperty: #package type: #String>
    <FMComment: 'This import come from this package'>
    ^ self attributeAt: #package ifAbsent: [  ]
]

{ #category : '*VespucciNotebookElementExtractor' }
FamixPythonImport >> package: aPackageNane [ 

    self attributeAt: #package put: aPackageNane.
]

{ #category : '*VespucciNotebookElementExtractor' }
FamixPythonImport >> startPos [ 

    <FMProperty: #startPos type: #String>
    <FMComment: 'startPos of this entity'>
    ^ self attributeAt: #startPos ifAbsent: [  ]
]

{ #category : '*VespucciNotebookElementExtractor' }
FamixPythonImport >> startPos: aPosString [ 

    self attributeAt: #startPos put: aPosString.
]
