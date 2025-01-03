Class {
	#name : #Board,
	#superclass : #Object,
	#instVars : [
		'array'
	],
	#category : #GToolkit4CalendarPuzzle
}

{ #category : #accessing }
Board class >> layout: aCollection width: anInteger [
	^ self new layout: aCollection copy width: anInteger
]

{ #category : #accessing }
Board class >> standard2holeVersion [
	^ self
		layout: #(
			2r1000000 
			2r1000000 
			2r0000000
			2r0000000 
			2r0000000 
			2r0000000 
			2r1111000 )
		width: 7
]

{ #category : #accessing }
Board class >> standard3holeVersion [
	^ self
		layout: #(
			2r1000000 
			2r1000000 
			2r0000000
			2r0000000 
			2r0000000 
			2r0000000 
			2r0000000 
			2r0001111)
		width: 7
]

{ #category : #accessing }
Board >> allSolutionsWithPieces: pieces [
	| solutions |
	solutions := OrderedCollection new.
	self solveWithPieces: pieces solutions: solutions.
	^ solutions
]

{ #category : #accessing }
Board >> cover: aPoint [
	array
		at: aPoint y
		put: ((array at: aPoint y) bitOr: (1 bitShift: aPoint x - 1))
]

{ #category : #accessing }
Board >> gtGridFor: aView [
	<gtView>
	^ aView forward
		title: 'Grid';
		object: [ array ];
		view: #gtGridFor:
]

{ #category : #accessing }
Board >> gtRowsFor: aView [
	<gtView>
	| list |
	list := aView columnedList
			title: 'Rows';
			items: [ 1 to: array height ].
	1
		to: array width
		do: [ :x | 
			list
				column: x asString
				text: [ :y | 
					| aPoint |
					aPoint := x @ y.
					array bitAt: aPoint ] ].
	^ list
]

{ #category : #accessing }
Board >> layout: aBitArray [
	array := aBitArray
]

{ #category : #accessing }
Board >> layout: aCollection width: anInteger [
	array := BitArray withAll: aCollection andWidth: anInteger
]

{ #category : #accessing }
Board >> place: arr at: aPoint [
	| newArray |
	newArray := array place: arr at: aPoint.
	^ self class new layout: newArray
]

{ #category : #accessing }
Board >> solveWithPieces: pieces at: anInteger current: anObject solutionDo: aBlock [
	anInteger > pieces size ifTrue: [ ^ aBlock value: anObject ].
	(pieces at: anInteger)
		permutationsDo: [ :arr | 
			1
				to: array height - arr height + 1
				do: [ :y | 
					1
						to: array width - arr width + 1
						do: [ :x | 
							| aPoint |
							aPoint := x @ y.
							(array canPlace: arr at: aPoint)
								ifTrue: [ (self place: arr at: x @ y)
										solveWithPieces: pieces
										at: anInteger + 1
										current: (anObject
												copyWith: {arr.
														x @ y})
										solutionDo: aBlock ] ] ] ]
]

{ #category : #accessing }
Board >> solveWithPieces: pieces at: anInteger current: anObject solutions: aCollection [
	self
		solveWithPieces: pieces
		at: anInteger
		current: anObject
		solutionDo: [ :each | 
			aCollection add: each.
			(aCollection size \\ 10) = 0
				ifTrue: [ Transcript
						show: aCollection size;
						cr ] ]
]

{ #category : #accessing }
Board >> solveWithPieces: pieces solutions: aCollection [
	self
		solveWithPieces: pieces
		at: 1
		current: #()
		solutions: aCollection
]
