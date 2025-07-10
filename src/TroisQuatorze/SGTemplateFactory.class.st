Class {
	#name : 'SGTemplateFactory',
	#superclass : 'Object',
	#instVars : [
		'colombusClient'
	],
	#category : 'TroisQuatorze',
	#package : 'TroisQuatorze'
}

{ #category : 'initialization' }
SGTemplateFactory class >> initializeWithClient: aClient [

	^self new colombusClient: aClient; yourself. 
]

{ #category : 'as yet unclassified' }
SGTemplateFactory >> buildTemplatesFromDbForPattern: aPatternName [

	| rawTemplates res |
	res := colombusClient getSgTemplatesByPatternName: aPatternName. 
	rawTemplates := res contents.
	^ rawTemplates collect: [ :templateDict |
		  | template |
		  template := SGTemplate new.
		  template
			  tag: (templateDict at: 'meta_step_name');
			  priority: (templateDict at: 'priority' ifAbsent: [ 5 ]);
			  "A voir si la priority est vraiment importante"matchBlock: [
				  :dict |
				  (NeoJSONWriter toString: (dict at: 'value' ifAbsent: [ '' ]))
				  = (templateDict at: 'sg_value') asString ].
		  "name: (templateDict at: 'name');"
		  template ]
]

{ #category : 'accessing' }
SGTemplateFactory >> colombusClient [

	^ colombusClient
]

{ #category : 'accessing' }
SGTemplateFactory >> colombusClient: anObject [

	colombusClient := anObject
]
