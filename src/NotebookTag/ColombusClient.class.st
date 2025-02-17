Class {
	#name : 'ColombusClient',
	#superclass : 'Object',
	#instVars : [
		'client',
		'url'
	],
	#category : 'NotebookTag',
	#package : 'NotebookTag'
}

{ #category : 'accessing' }
ColombusClient >> client [ 

^client
]

{ #category : 'as yet unclassified' }
ColombusClient >> createNbElmt: aColombusModelNbElmt [
"
notebookRequest := ColombusModelNbElmt new.
notebookRequest notebookId: 1.
notebookRequest sousgraphfamix_id: 1
notebookRequest stepId: 2.
notebookRequest linestart: 5.
notebookRequest lineend: 5.

self createNbElmt: notebookRequest
"
	^ client post: url,'notebook_elements/' contents: aColombusModelNbElmt asDictionary. 
]

{ #category : 'as yet unclassified' }
ColombusClient >> createNbElmtS: aColombusModelNbElmtS [
"
sgFamix := ColombusModelSg new.
sgFamix typesgId: 1.
sgFamix value: (Dictionary new at: 'row' put: 'from datetime import date'; yourself).

notebookRequest := ColombusModelNbElmtS new.
notebookRequest notebookId: 1.
notebookRequest sgFamix: sgFamix
notebookRequest stepId: 2.
notebookRequest linestart: 5.
notebookRequest lineend: 5.

self createNbElmt: notebookRequest
"
	^ client post: url,'notebook_elements/simple/' contents: aColombusModelNbElmtS asDictionary. 
]

{ #category : 'as yet unclassified' }
ColombusClient >> createSgFamix: aSgFamixObj [
"sgFamix := ColombusModelSg new.
sgFamix typesgId: 1.
sgFamix value: (Dictionary new at: 'row' put: 'from datetime import date'; yourself).

self createSgFamix: sgFamix."

	^ client post: url,'sousgraphfamix/' contents: aSgFamixObj asDictionary. 
]

{ #category : 'as yet unclassified' }
ColombusClient >> findIconsistency: anElmtMissMatchModel [

	^ client post: url,'inconsistencies/find' contents: anElmtMissMatchModel asDictionary. 
	
]

{ #category : 'as yet unclassified' }
ColombusClient >> findIconsistencyOnElmt: anElmtId nbId: aNbId [

	^ client post: url,'inconsistencies/find' contents:  {  #idnb -> aNbId. #idelmt -> anElmtId } asDictionary. 
	
]

{ #category : 'as yet unclassified' }
ColombusClient >> findSgFamix: aSgFamixModelObj [
"If sg is find return the id"

	^ client post: url,'sousgraphfamix/search' contents: aSgFamixModelObj asDictionary. 
]

{ #category : 'as yet unclassified' }
ColombusClient >> getNbElmts [

	^ client get: url,'notebook_elements/'  
]

{ #category : 'as yet unclassified' }
ColombusClient >> getNbId: aNbId elementId: anElmtId [

	^ client get: url,'notebook_elements/',(aNbId asString),'/',(anElmtId asString)  
]

{ #category : 'as yet unclassified' }
ColombusClient >> getSgFamixs [

	^ client get: url,'sousgraphfamix/'
]

{ #category : 'as yet unclassified' }
ColombusClient >> getSgFamixsById: aSgFamixId [

	^ client get: url,'sousgraphfamix/',(aSgFamixId asString)
]

{ #category : 'as yet unclassified' }
ColombusClient >> getStepById: aStepId [ 

	^ client get: url,'steps/',(aStepId asString ) 
]

{ #category : 'as yet unclassified' }
ColombusClient >> getStepByName: aStepName [

	^ client post: url,'step/' contents: { #name->aStepName} asDictionary.
]

{ #category : 'as yet unclassified' }
ColombusClient >> getSteps [ 

	^ client get: url,'steps/' 
]

{ #category : 'as yet unclassified' }
ColombusClient >> getTypesSg [

	^ client get: url,'typesg/'
]

{ #category : 'as yet unclassified' }
ColombusClient >> getTypesSgById: atypeSgId [

	^ client get: url,'typesg/',(atypeSgId asString)
]

{ #category : 'as yet unclassified' }
ColombusClient >> initClient: anApiUrl [

	client :=  ZnClient new forJsonREST; yourself.
	url := anApiUrl
]
