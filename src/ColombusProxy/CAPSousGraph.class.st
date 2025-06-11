Class {
	#name : 'CAPSousGraph',
	#superclass : 'CAPApiProxy',
	#instVars : [
		'id',
		'typesg',
		'code',
		'notebookElement',
		'internalValue',
		'notebookElements'
	],
	#category : 'ColombusProxy',
	#package : 'ColombusProxy'
}

{ #category : 'instance creation' }
CAPSousGraph class >> fromJson: aDict [
    ^ self new
        id: (aDict at: 'id');
        internalValue: (aDict at: 'value');
        yourself.
]

{ #category : 'instance creation' }
CAPSousGraph class >> fromJson: aDict notebookElement: anElement [
    ^ self new
        id: (aDict at: 'id');
        internalValue: (aDict at: 'value');
        notebookElement: anElement;
        yourself.
]

{ #category : 'instance creation' }
CAPSousGraph class >> fromJson: aSgDict  withJsonElementsAndSteps: aDict [

	^ self new
		  id: (aSgDict at: 'id');
		  internalValue: (aSgDict at: 'value');
		  loadNotebookElementsAndStepsFromDict: aDict ;
		  yourself
]

{ #category : 'instance creation' }
CAPSousGraph class >> fromJson: aDict withJsonelements: aJsonDict [

	^ self new
		  id: (aDict at: 'id');
		  internalValue: (aDict at: 'value');
		  loadNotebookElementsFromDict: aJsonDict;
		  yourself
]

{ #category : 'accessing' }
CAPSousGraph >> code [
	
	1halt. 
	"code will be linked to nbElmnt"
"	code ifNil: [
			| json |
			json := self getJsonFrom: 'sousgraphs/' , id asString , '/code'.
			code := CAPCode fromJson: json sousgraph: self ].
	^ code"
]

{ #category : 'accessing' }
CAPSousGraph >> code: anObject [

	code := anObject
]

{ #category : 'accessing' }
CAPSousGraph >> id [

	^ id
]

{ #category : 'accessing' }
CAPSousGraph >> id: anObject [

	id := anObject
]

{ #category : 'accessing' }
CAPSousGraph >> internalValue [

	^ internalValue
]

{ #category : 'accessing' }
CAPSousGraph >> internalValue: anObject [

	internalValue := anObject
]

{ #category : 'as yet unclassified' }
CAPSousGraph >> loadNotebookElements [

	| json |
	json := self getJsonFrom: 'sousgraphs/' , id asString , '/elements'.
	notebookElements := json collect: [ :each |
		                    CAPNotebookElement
			                    fromJson: each
			                    sousGraph: self ]
]

{ #category : 'as yet unclassified' }
CAPSousGraph >> loadNotebookElementsAndStepsFromDict: aDict [

	notebookElements := aDict collect: [ :each |
			                    CAPNotebookElement
				                    fromJson: (each at: 'element')
				                    sousGraph: self
				                    withSteps:
				                    (each at: 'step_impls_with_metasteps') ]
]

{ #category : 'as yet unclassified' }
CAPSousGraph >> loadNotebookElementsFromDict: aDict [

	notebookElements := aDict collect: [ :each |
		                    CAPNotebookElement
			                    fromJson: each
			                    sousGraph: self ]
]

{ #category : 'accessing' }
CAPSousGraph >> notebookElements [

	notebookElements ifNil: [ self error: 'NotebookElements not loaded' ].
	^ notebookElements
]

{ #category : 'as yet unclassified' }
CAPSousGraph >> notebookElementsByMetaSteps [

	| groupedByMetaStep |
	groupedByMetaStep := Dictionary new.

	self notebookElements do: [ :el |
			self notebookElementsMetaStepNames do: [ :name |
					| group |
					group := groupedByMetaStep
						         at: name
						         ifAbsentPut: [ OrderedCollection new ].
					(group includes: el) ifFalse: [ group add: el ] ] ].

	^ groupedByMetaStep
]

{ #category : 'as yet unclassified' }
CAPSousGraph >> notebookElementsMetaStepNames [
	"Return all metastep name as set of this SG -> elements -> stepimpls -> metastep "

	self notebookElements do: [ :el |
			| uniqueMetaStepNames |
			uniqueMetaStepNames := (el stepImpls collect: [ :si |
				                        si metaStep name ]) asSet.
			^ uniqueMetaStepNames ]
]

{ #category : 'accessing' }
CAPSousGraph >> typesg [

	typesg ifNil: [
			| json |
			json := self getJsonFrom: 'sousgraphs/' , id asString , '/typesg'.
			typesg := CAPTypeSG fromJson: json ].
	^ typesg
]

{ #category : 'accessing' }
CAPSousGraph >> typesg: anObject [

	typesg := anObject
]
