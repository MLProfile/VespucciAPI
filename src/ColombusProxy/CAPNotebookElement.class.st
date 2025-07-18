Class {
	#name : 'CAPNotebookElement',
	#superclass : 'CAPApiProxy',
	#instVars : [
		'id',
		'startLine',
		'endLine',
		'startPos',
		'endPos',
		'library',
		'function',
		'isComposition',
		'notebook',
		'metaInstruction',
		'stepImpls',
		'sousGraph',
		'code'
	],
	#category : 'ColombusProxy',
	#package : 'ColombusProxy'
}

{ #category : 'instance creation' }
CAPNotebookElement class >> fromJson: aDict notebook: aNotebook [
    ^ self new
        id: (aDict at: 'id');
        startLine: (aDict at: 'start_line');
        endLine: (aDict at: 'end_line');
        startPos: (aDict at: 'start_pos');
        endPos: (aDict at: 'end_pos');
        library: (aDict at: 'library');
        function: (aDict at: 'function');
        isComposition: (aDict at: 'is_composition');
        notebook: aNotebook;
        yourself.
]

{ #category : 'instance creation' }
CAPNotebookElement class >> fromJson: aDict sousGraph: aSG [
    ^ self new
        id: (aDict at: 'id');
        startLine: (aDict at: 'start_line');
        endLine: (aDict at: 'end_line');
        startPos: (aDict at: 'start_pos');
        endPos: (aDict at: 'end_pos');
        library: (aDict at: 'library');
        function: (aDict at: 'function');
        isComposition: (aDict at: 'is_composition');
        sousGraph: aSG;
        yourself.
]

{ #category : 'instance creation' }
CAPNotebookElement class >> fromJson: aDict sousGraph: aSG withSteps: aStepsDict [

	^ self new
		  id: (aDict at: 'id');
		  startLine: (aDict at: 'start_line');
		  endLine: (aDict at: 'end_line');
		  startPos: (aDict at: 'start_pos');
		  endPos: (aDict at: 'end_pos');
		  library: (aDict at: 'library');
		  function: (aDict at: 'function');
		  isComposition: (aDict at: 'is_composition');
		  sousGraph: aSG;
		  stepImplsFromJson: aStepsDict;
		  yourself
]

{ #category : 'accessing' }
CAPNotebookElement >> code [

	code ifNil: [
			| json |
			json := self getJsonFrom:
				        'notebookelements/' , id asString , '/code'.
			code := CAPCode fromJson: json sousgraph: self ].
	^ code
]

{ #category : 'accessing' }
CAPNotebookElement >> code: aCode [

	code := aCode. 
]

{ #category : 'accessing' }
CAPNotebookElement >> endLine [

	^ endLine
]

{ #category : 'accessing' }
CAPNotebookElement >> endLine: anObject [

	endLine := anObject
]

{ #category : 'accessing' }
CAPNotebookElement >> endPos [

	^ endPos
]

{ #category : 'accessing' }
CAPNotebookElement >> endPos: anObject [

	endPos := anObject
]

{ #category : 'accessing' }
CAPNotebookElement >> function [

	^ function
]

{ #category : 'accessing' }
CAPNotebookElement >> function: anObject [

	function := anObject
]

{ #category : 'accessing' }
CAPNotebookElement >> id [

	^ id
]

{ #category : 'accessing' }
CAPNotebookElement >> id: anObject [

	id := anObject
]

{ #category : 'accessing' }
CAPNotebookElement >> isComposition [

	^ isComposition
]

{ #category : 'accessing' }
CAPNotebookElement >> isComposition: anObject [

	isComposition := anObject
]

{ #category : 'accessing' }
CAPNotebookElement >> library [

	^ library
]

{ #category : 'accessing' }
CAPNotebookElement >> library: anObject [

	library := anObject
]

{ #category : 'as yet unclassified' }
CAPNotebookElement >> loadSgAndLinkedElemtents [

	| json |
	json := self getJsonFrom:
		        'notebookelements/' , id asString , '/complete'.

	sousGraph := CAPSousGraph
		             fromJson: (json at: 'sousgraph')
		             withJsonElementsAndSteps:
		             (json at: 'elements_with_stepimpls')
]

{ #category : 'accessing' }
CAPNotebookElement >> metaInstruction [

	metaInstruction ifNil: [
			| json |
			json := self getJsonFrom:
				        'notebookelements/' , id asString , '/metainstruction'.
			metaInstruction := CAPMetaInstruction fromJson: json element: self ].
	^ metaInstruction
]

{ #category : 'accessing' }
CAPNotebookElement >> notebook [

	notebook ifNil: [
			| json |
			json := self getJsonFrom:
				        'notebookelements/' , id asString , '/notebook'.
			notebook := CAPNotebook fromJson: json ].
	^ notebook
]

{ #category : 'accessing' }
CAPNotebookElement >> notebook: anObject [

	notebook := anObject
]

{ #category : 'accessing' }
CAPNotebookElement >> sousGraph [

	sousGraph ifNil: [
			| json |
			json := self getJsonFrom:
				        'notebookelements/' , id asString , '/sousgraph/elements'.


			sousGraph := CAPSousGraph
				             fromJson: (json at: 'sousgraph')
				             withJsonelements: (json at: 'elements')

			"Puisque un sous-graph peut etre lié a plusieurs nbElmnt on les charge tous"
			"sousGraph loadNotebookElements" ].
	^ sousGraph
]

{ #category : 'accessing' }
CAPNotebookElement >> sousGraph: anObject [

	sousGraph := anObject. 
]

{ #category : 'accessing' }
CAPNotebookElement >> startLine [

	^ startLine
]

{ #category : 'accessing' }
CAPNotebookElement >> startLine: anObject [

	startLine := anObject
]

{ #category : 'accessing' }
CAPNotebookElement >> startPos [

	^ startPos
]

{ #category : 'accessing' }
CAPNotebookElement >> startPos: anObject [

	startPos := anObject
]

{ #category : 'accessing' }
CAPNotebookElement >> stepImpls [

	stepImpls ifNil: [
			| json |
			json := self getJsonFrom:
				        'notebookelements/' , id asString , '/stepimpls/metastep'.

			stepImpls := json collect: [ :each |
					             CAPStepImpl
						             fromJson: (each at: 'step_impl')
						             element: self
						             withMetaStepJson: (each at: 'meta_step') ] ].

	^ stepImpls
]

{ #category : 'as yet unclassified' }
CAPNotebookElement >> stepImplsFromJson: aDict [

	stepImpls := aDict collect: [ :each |
					             CAPStepImpl
						             fromJson: (each at: 'step_impl')
						             element: self
						             withMetaStepJson: (each at: 'meta_step') ]
]
