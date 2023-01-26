Class {
	#name : #Board,
	#superclass : #Object,
	#instVars : [
		'array',
		'width',
		'max'
	],
	#category : #GToolkit4CalendarPuzzle
}

{ #category : #accessing }
Board class >> layout: aCollection width: anInteger [
	^ self new layout: aCollection copy width: anInteger
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
	^ aView explicit
		title: 'Grid';
		stencil: [ | container |
			container := BlElement new
					layout: (BlGridLayout new columnCount: width);
					constraintsDo: [ :c | 
						c vertical matchParent.
						c horizontal matchParent ].
			1
				to: 8
				do: [ :y | 
					1
						to: width
						do: [ :x | 
							| aPoint |
							aPoint := x @ y.
							container
								addChild: (BlElement new
										border: Color white;
										background: ((array bitAt: aPoint) isZero
												ifTrue: [ Color gray ]
												ifFalse: [ Color transparent ])) ] ].
			container ]
]

{ #category : #accessing }
Board >> gtRowsFor: aView [
	<gtView>
	| list |
	list := aView columnedList
			title: 'Rows';
			items: [ 1 to: 8 ].
	1
		to: width
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
Board >> layout: aCollection width: anInteger [
	array := BitArray withAll: aCollection andWidth: anInteger.
	width := anInteger.
	max := 1 bitShift: anInteger
]

{ #category : #accessing }
Board >> place: arr at: aPoint [
	| newArray |
	newArray := array place: arr at: aPoint.
	^ self class new layout: newArray width: width
]

{ #category : #accessing }
Board >> solveWithPieces: pieces at: anInteger current: anObject solutionDo: aBlock [
	anInteger > pieces size ifTrue: [ ^ aBlock value: anObject ].
	(pieces at: anInteger)
		permutationsDo: [ :arr | 
			1
				to: array size - arr size + 1
				do: [ :y | 
					1
						to: width
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
