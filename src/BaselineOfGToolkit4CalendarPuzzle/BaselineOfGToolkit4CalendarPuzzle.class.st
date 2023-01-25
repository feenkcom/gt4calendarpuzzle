Class {
	#name : #BaselineOfGToolkit4CalendarPuzzle,
	#superclass : #BaselineOf,
	#category : #BaselineOfGToolkit4CalendarPuzzle
}

{ #category : #accessing }
BaselineOfGToolkit4CalendarPuzzle class >> loadLepiter [
	| currentProperties |
	currentProperties := LeDatabasesRegistry defaultLogicalDatabase properties.
	currentProperties
		addRegisteredDirectory: FileLocator imageDirectory / 'pharo-local' / 'iceberg' / 'feenkcom'
				/ 'gt4calendarpuzzle' / 'lepiter'.
	LeDatabasesRegistry default defaultLogicalDatabase reload

]

{ #category : #baseline }
BaselineOfGToolkit4CalendarPuzzle >> baseline: spec [
	<baseline>
	spec for: #common do: [ spec package: 'GToolkit4CalendarPuzzle' ]
]
