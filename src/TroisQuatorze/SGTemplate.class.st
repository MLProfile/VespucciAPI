Class {
	#name : 'SGTemplate',
	#superclass : 'ApiLink',
	#instVars : [
		'name',
		'tag',
		'priority',
		'matchBlock'
	],
	#category : 'TroisQuatorze',
	#package : 'TroisQuatorze'
}

{ #category : 'accessing' }
SGTemplate >> matchBlock [

	^ matchBlock
]

{ #category : 'accessing' }
SGTemplate >> matchBlock: anObject [

	matchBlock := anObject
]

{ #category : 'testing' }
SGTemplate >> matches: dict [
    ^ matchBlock value: dict.
]

{ #category : 'accessing' }
SGTemplate >> name [

	^ name
]

{ #category : 'accessing' }
SGTemplate >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
SGTemplate >> priority [

	^ priority
]

{ #category : 'accessing' }
SGTemplate >> priority: anObject [

	priority := anObject
]

{ #category : 'accessing' }
SGTemplate >> tag [

	^ tag
]

{ #category : 'accessing' }
SGTemplate >> tag: anObject [

	tag := anObject
]
