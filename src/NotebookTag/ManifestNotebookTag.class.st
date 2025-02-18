"
I am a notebook model
"
Class {
	#name : 'ManifestNotebookTag',
	#superclass : 'PackageManifest',
	#category : 'NotebookTag-Manifest',
	#package : 'NotebookTag',
	#tag : 'Manifest'
}

{ #category : 'asserting' }
ManifestNotebookTag class >> shouldBeIncludedByDefaultInMetamodelsWith: aCollectionOfPackages [
	^ true
]
