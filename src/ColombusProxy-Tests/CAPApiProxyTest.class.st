"
A CAPApiProxyTest is a test class for testing the behavior of CAPApiProxy
"
Class {
	#name : 'CAPApiProxyTest',
	#superclass : 'TestCase',
	#instVars : [
		'serverMock'
	],
	#category : 'ColombusProxy-Tests',
	#package : 'ColombusProxy-Tests'
}

{ #category : 'running' }
CAPApiProxyTest >> setUp [
	super setUp.

	serverMock := ColombusMockAPI start
]

{ #category : 'tests' }
CAPApiProxyTest >> testNotebook5ShouldContainElements [

	| student_0 nb5 |
	student_0 := CAPProject new id: '04fab682-0133-4987-b447-5455d07c2664'.
	nb5 := student_0 notebooks first.
	self assert: nb5 isNotNil. 
	self assert: nb5 elements size equals: 47. 

]

{ #category : 'tests' }
CAPApiProxyTest >> testNotebook6ShouldContain47Elements [

	| student_0 nb5 |
	student_0 := CAPProject new id: 'b6286523-7ef1-44d0-8125-b02f1550cee9'.
	nb5 := student_0 notebooks first.
	self assert: nb5 isNotNil. 
	self assert: nb5 elements size equals: 36. 

]

{ #category : 'tests' }
CAPApiProxyTest >> testNotebook7ShouldContain43Elements [

	| student_0 nb5 |
	student_0 := CAPProject new id: 'cfc3216a-93ec-4628-bb2c-8d7951f954b9'.
	nb5 := student_0 notebooks first.
	self assert: nb5 isNotNil. 
	self assert: nb5 elements size equals: 36. 

]

{ #category : 'tests' }
CAPApiProxyTest >> testProjectShouldContain3Notebooks [

	| student_0 |
	student_0 := CAPProject new id: '04fab682-0133-4987-b447-5455d07c2664'.
	self assert: (student_0 notebooks) notNil .
	self assert: student_0 notebooks size equals: 3.

]
