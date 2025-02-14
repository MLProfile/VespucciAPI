Class {
	#name : 'ColombusModelSg',
	#superclass : 'Object',
	#instVars : [
		'value',
		'typesgId'
	],
	#category : 'NotebookTag',
	#package : 'NotebookTag'
}

{ #category : 'evaluating' }
ColombusModelSg >> asDictionary [
    ^ Dictionary new
        at: 'value' put: value;
        at: 'typesg_id' put: typesgId;
        yourself.
]

{ #category : 'evaluating' }
ColombusModelSg >> initialize [
    value := Dictionary new.
    typesgId := 0.
]

{ #category : 'evaluating' }
ColombusModelSg >> typesgId [
    ^ typesgId.
]

{ #category : 'evaluating' }
ColombusModelSg >> typesgId: anInteger [
    typesgId := anInteger.
]

{ #category : 'evaluating' }
ColombusModelSg >> value [
    ^ value.
]

{ #category : 'evaluating' }
ColombusModelSg >> value: aJsonDict [
    value := aJsonDict.
]
