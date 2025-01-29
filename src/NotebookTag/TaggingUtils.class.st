Class {
	#name : 'TaggingUtils',
	#superclass : 'Object',
	#category : 'NotebookTag',
	#package : 'NotebookTag'
}

{ #category : 'as yet unclassified' }
TaggingUtils >> getFuncNameWithTag: afuncTaggedModel [
	"Here we want a model with functions tagged with self tagFuncOrMethods"

	| fonctions dict |
	fonctions := afuncTaggedModel allFunctions.
	dict := Dictionary new.
	fonctions do: [ :func | dict add: func name -> func tags ].
	^ dict
]

{ #category : 'as yet unclassified' }
TaggingUtils >> tagFuncOrMethods: aTaggedModel [

	| tags taggedEntities invocations |
	tags := aTaggedModel allTags.
	taggedEntities := tags flatCollect: #taggedEntities.
	invocations := taggedEntities select: [ :famixObj |
		               famixObj class = FamixPythonInvocation ].
	invocations do: [ :invocation |
		| tags func |
		tags := invocation tags.
		func := invocation invokedEntity.
		tags do: [ :tag | func tagWith: tag ] ].

	^ aTaggedModel
]

{ #category : 'as yet unclassified' }
TaggingUtils >> tagModelFuncAndInvocations: aFamixPythonModel with: aTagDictonnary [
	"Here we want a row FamixPythonModel with a Function -> tag dictionnary get with self getFuncNameWithTag"

	^ aFamixPythonModel allFunctions do: [ :func |
		  | tags |
		  tags := aTagDictonnary at: func name ifAbsent: [ "do something" ].
		  tags ifNotNil: [
			  tags do: [ :tag |
				  func tagWith: tag.
				  "Here we have invocation because function come from invocations not declaration but we should check if it's not empty"
				  func incomingInvocations do: [ :invoc | invoc tagWith: tag ] ] ] ]
]
