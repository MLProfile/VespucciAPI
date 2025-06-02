"
This class can lazyload object from an distant database using a dedicated api.

To use it, start from an object with an id :

project := ProjectProxy new id: '153044a8-ea09-4144-99df-9d8ba77bf82f'; name: 'Projet A'.

Then, you can navigate in the DB.
"
Class {
	#name : 'ManifestColombusProxy',
	#superclass : 'PackageManifest',
	#category : 'ColombusProxy-Manifest',
	#package : 'ColombusProxy',
	#tag : 'Manifest'
}
