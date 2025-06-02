Class {
	#name : 'ApiModelFullProfile',
	#superclass : 'Object',
	#instVars : [
		'name',
		'project_id',
		'notebook_id',
		'sous_graphs',
		'json_profile',
		'compositions',
		'famix_model'
	],
	#category : 'ColombusAPI',
	#package : 'ColombusAPI'
}

{ #category : 'converting' }
ApiModelFullProfile >> asDictionary [

	^ Dictionary new
		  at: 'name' put: name;
		  at: 'notebook_id' put: notebook_id;
		  at: 'famix_model' put: famix_model;
		  at: 'project_id' put: project_id;
		  at: 'json_profile' put: json_profile asDictionary;
		  at: 'sous_graphs' put: sous_graphs;
		  at: 'compositions' put: compositions;
		  yourself
]

{ #category : 'accessing' }
ApiModelFullProfile >> compositions [

	^ compositions
]

{ #category : 'accessing' }
ApiModelFullProfile >> compositions: anObject [

	compositions := anObject
]

{ #category : 'accessing' }
ApiModelFullProfile >> famix_model [

	^ famix_model
]

{ #category : 'accessing' }
ApiModelFullProfile >> famix_model: anObject [

	famix_model := anObject
]

{ #category : 'initialization' }
ApiModelFullProfile >> initialize [

	name := nil.
	project_id := nil.
	notebook_id := nil.
	json_profile := {}.
	famix_model := {}.
	sous_graphs := nil.
	compositions := nil
]

{ #category : 'accessing' }
ApiModelFullProfile >> json_profile [

	^ json_profile
]

{ #category : 'accessing' }
ApiModelFullProfile >> json_profile: anObject [

	json_profile := anObject
]

{ #category : 'accessing' }
ApiModelFullProfile >> name [

	^ name
]

{ #category : 'accessing' }
ApiModelFullProfile >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
ApiModelFullProfile >> notebook_id [

	^ notebook_id
]

{ #category : 'accessing' }
ApiModelFullProfile >> notebook_id: anObject [

	notebook_id := anObject
]

{ #category : 'accessing' }
ApiModelFullProfile >> project_id [

	^ project_id
]

{ #category : 'accessing' }
ApiModelFullProfile >> project_id: anObject [

	project_id := anObject
]

{ #category : 'accessing' }
ApiModelFullProfile >> sous_graphs [

	^ sous_graphs
]

{ #category : 'accessing' }
ApiModelFullProfile >> sous_graphs: anObject [

	sous_graphs := anObject
]
