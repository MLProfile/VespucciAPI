"
curl -X POST -H 'Content-Type: application/json' -d '{""notebookId"": ""aNbId"", ""projectId"": ""aProjectId""}' http://localhost:1701/inconsistencies
"
Class {
	#name : 'VPInconsistenciesRunner',
	#superclass : 'Object',
	#instVars : [
		'project',
		'notebook',
		'inconsistencies'
	],
	#category : 'VespucciNotebookElementExtractor',
	#package : 'VespucciNotebookElementExtractor'
}

{ #category : 'instance creation' }
VPInconsistenciesRunner class >> fromApiPersistInconsistenciesFromNotebookId: idNb fromProject: idProject [

	^ self new
		  project: (CAPProject new id: idProject);
		  loadNoteboook: idNb;
		  computeInconsistencies;
		  persistInconsistencies;
		  yourself
]

{ #category : 'as yet unclassified' }
VPInconsistenciesRunner >> computeInconsistencies [

	inconsistencies := notebook detectNewInconsistenciesByMetaStep. 
]

{ #category : 'accessing' }
VPInconsistenciesRunner >> inconsistencies [

	^ inconsistencies
]

{ #category : 'accessing' }
VPInconsistenciesRunner >> inconsistencies: anObject [

	inconsistencies := anObject
]

{ #category : 'as yet unclassified' }
VPInconsistenciesRunner >> loadNoteboook: idNb [

	notebook := (project notebooks select: [ :n | n id = idNb ]) first.

]

{ #category : 'accessing' }
VPInconsistenciesRunner >> notebook [

	^ notebook
]

{ #category : 'accessing' }
VPInconsistenciesRunner >> notebook: anObject [

	notebook := anObject
]

{ #category : 'as yet unclassified' }
VPInconsistenciesRunner >> persistInconsistencies [

	inconsistencies .
	1halt.
]

{ #category : 'accessing' }
VPInconsistenciesRunner >> project [

	^ project
]

{ #category : 'accessing' }
VPInconsistenciesRunner >> project: anObject [

	project := anObject
]
