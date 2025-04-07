Class {
	#name : 'ApiModelNbElmntAndSg',
	#superclass : 'Object',
	#instVars : [
		'notebook_id',
		'type_sg_id',
		'line_start',
		'line_end',
		'library',
		'function',
		'source',
		'value',
		'step_name',
		'pos_start',
		'pos_end',
		'is_composition'
	],
	#category : 'ColombusAPI',
	#package : 'ColombusAPI'
}

{ #category : 'converting' }
ApiModelNbElmntAndSg >> asDictionary [

	^ Dictionary new
		  at: 'step_name' put: step_name;
		  at: 'notebook_id' put: notebook_id;
		  at: 'type_sg_id' put: type_sg_id;
		  at: 'line_start' put: line_start;
		  at: 'line_end' put: line_end;
		  at: 'pos_start' put: pos_start;
		  at: 'pos_end' put: pos_end;
		  at: 'library' put: library;
		  at: 'function' put: function;
		  at: 'source' put: source;
		  at: 'value' put: value;
		  yourself
]

{ #category : 'accessing' }
ApiModelNbElmntAndSg >> function [

	^ function
]

{ #category : 'accessing' }
ApiModelNbElmntAndSg >> function: anObject [

	function := anObject
]

{ #category : 'initialization' }
ApiModelNbElmntAndSg >> initialize [

	step_name := nil.
	notebook_id := nil.
	type_sg_id := nil.
	line_start := nil.
	line_end := nil.
	pos_start := nil.
	pos_end := nil.
	library := nil.
	function := nil.
	source := nil.
	value := nil.
	is_composition := false.
]

{ #category : 'accessing' }
ApiModelNbElmntAndSg >> is_composition [

	^ is_composition
]

{ #category : 'accessing' }
ApiModelNbElmntAndSg >> is_composition: anObject [

	is_composition := anObject
]

{ #category : 'accessing' }
ApiModelNbElmntAndSg >> library [

	^ library
]

{ #category : 'accessing' }
ApiModelNbElmntAndSg >> library: anObject [

	library := anObject
]

{ #category : 'accessing' }
ApiModelNbElmntAndSg >> line_end [

	^ line_end
]

{ #category : 'accessing' }
ApiModelNbElmntAndSg >> line_end: anObject [

	line_end := anObject
]

{ #category : 'accessing' }
ApiModelNbElmntAndSg >> line_start [

	^ line_start
]

{ #category : 'accessing' }
ApiModelNbElmntAndSg >> line_start: anObject [

	line_start := anObject
]

{ #category : 'accessing' }
ApiModelNbElmntAndSg >> notebook_id [

	^ notebook_id
]

{ #category : 'accessing' }
ApiModelNbElmntAndSg >> notebook_id: anObject [

	notebook_id := anObject
]

{ #category : 'accessing' }
ApiModelNbElmntAndSg >> pos_end [

	^ pos_end
]

{ #category : 'accessing' }
ApiModelNbElmntAndSg >> pos_end: anObject [

	pos_end := anObject
]

{ #category : 'accessing' }
ApiModelNbElmntAndSg >> pos_start [

	^ pos_start
]

{ #category : 'accessing' }
ApiModelNbElmntAndSg >> pos_start: anObject [

	pos_start := anObject
]

{ #category : 'accessing' }
ApiModelNbElmntAndSg >> source [

	^ source
]

{ #category : 'accessing' }
ApiModelNbElmntAndSg >> source: anObject [

	source := anObject
]

{ #category : 'accessing' }
ApiModelNbElmntAndSg >> step_name [

	^ step_name
]

{ #category : 'accessing' }
ApiModelNbElmntAndSg >> step_name: anObject [

	step_name := anObject
]

{ #category : 'accessing' }
ApiModelNbElmntAndSg >> type_sg_id [

	^ type_sg_id
]

{ #category : 'accessing' }
ApiModelNbElmntAndSg >> type_sg_id: anObject [

	type_sg_id := anObject
]

{ #category : 'accessing' }
ApiModelNbElmntAndSg >> value1 [

	^ value
]

{ #category : 'accessing' }
ApiModelNbElmntAndSg >> value: anObject [

	value := anObject
]
