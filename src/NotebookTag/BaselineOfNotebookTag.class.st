Class {
	#name : 'BaselineOfNotebookTag',
	#superclass : 'BaselineOf',
	#category : 'NotebookTag',
	#package : 'NotebookTag'
}

{ #category : 'baselines' }
BaselineOfNotebookTag >> baseline: spec [  
    <baseline>
    spec
    for: #common
    do: [ 
        self defineDependencies: spec.
        self definePackages: spec.]

]

{ #category : 'baselines' }
BaselineOfNotebookTag >> defineDependencies: spec [
    spec
        baseline: 'MoosePy'
        with: [ spec
            repository: 'github://moosetechnology/MoosePy:master/src' ].
]

{ #category : 'baselines' }
BaselineOfNotebookTag >> definePackages: spec [
    spec
        package: 'NotebookTag' with: [ spec requires: #( 'MoosePy' ) ]



]
