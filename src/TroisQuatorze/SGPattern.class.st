Class {
	#name : 'SGPattern',
	#superclass : 'ApiLink',
	#instVars : [
		'name',
		'cleaningKeys',
		'valueKeys',
		'priority'
	],
	#category : 'TroisQuatorze',
	#package : 'TroisQuatorze'
}

{ #category : 'accessing' }
SGPattern >> cleaningKeys [
    ^ cleaningKeys ifNil: [ #() ].
]

{ #category : 'accessing' }
SGPattern >> cleaningKeys: aCollection [
    cleaningKeys := aCollection.
]

{ #category : 'as yet unclassified' }
SGPattern >> jsonElementsFromFile: aFileRef [
    self subclassResponsibility.
]

{ #category : 'as yet unclassified' }
SGPattern >> matchFamixEntityFrom: json in: model [
    self subclassResponsibility.
]

{ #category : 'accessing' }
SGPattern >> name [

	^ name
]

{ #category : 'accessing' }
SGPattern >> name: aString [

	name := aString
]

{ #category : 'accessing' }
SGPattern >> priority [
    ^ priority ifNil: [ 0 ].
]

{ #category : 'accessing' }
SGPattern >> priority: anInteger [
    priority := anInteger.
]

{ #category : 'accessing' }
SGPattern >> valueKeys [
    ^ valueKeys ifNil: [ #() ].
]
