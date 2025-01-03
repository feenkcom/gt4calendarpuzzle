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

{ #category : #comparing }
Board >> = anObject [
	^ self class = anObject class and: [ array = anObject array ]
]

{ #category : #accessing }
Board >> allBoardsAndSolutionsWithPieces: pieces [
	| solutions |
	solutions := Dictionary new.
	self
		solveWithPieces: pieces
		at: 1
		current: #()
		solutionDo: [ :each :board | (solutions at: board ifAbsentPut: [ OrderedCollection new ]) add: each ].
	^ solutions
]

{ #category : #accessing }
Board >> allSolutionsWithPieces: pieces [
	| solutions |
	solutions := OrderedCollection new.
	self solveWithPieces: pieces solutions: solutions.
	^ solutions
]

{ #category : #'as yet unclassified' }
Board >> array [
	^ array
]

{ #category : #accessing }
Board >> cover: aPoint [
	array
		at: aPoint y
		put: ((array at: aPoint y) bitOr: (1 bitShift: aPoint x - 1))
]

{ #category : #accessing }
Board >> dayIndex [
	1
		to: 31
		do: [ :i | (self isCovered: ((i - 1) \\ 7 + 1) @ ((i - 1) // 7 + 3)) ifFalse: [ ^ i ] ].
	^ nil
]

{ #category : #printing }
Board >> dayName [
	Date dayNames
		doWithIndex: [ :each :i | 
			| y x |
			i <= 4
				ifTrue: [ x := 4.
					y := 7 ]
				ifFalse: [ x := 5.
					y := 8 ].
			(self isCovered: (x + ((i - 1) \\ 4)) @ y) ifFalse: [ ^ each ] ].
	^ nil
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

{ #category : #hashing }
Board >> hash [
	^ array hash
]

{ #category : #'as yet unclassified' }
Board >> invert [
	array := array inverted
]

{ #category : #printing }
Board >> is3holeVersion [
	^ array height = 8
]

{ #category : #accessing }
Board >> isCovered: aPoint [
	^ ((array at: aPoint y) bitAnd: (1 bitShift: aPoint x - 1)) ~= 0
]

{ #category : #testing }
Board >> isLegalDate [
	^ self monthName notNil
		and: [ self dayIndex notNil
				and: [ self is3holeVersion not or: [ self dayName notNil ] ] ]
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
Board >> monthName [
	Date monthNames
		doWithIndex: [ :each :i | (self isCovered: ((i - 1) \\ 6 + 1) @ ((i - 1) // 6 + 1)) ifFalse: [ ^ each ] ].
	^ nil
]

{ #category : #accessing }
Board >> place: arr at: aPoint [
	| newArray |
	newArray := array place: arr at: aPoint.
	^ self class new layout: newArray
]

{ #category : #printing }
Board >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	self monthName printOn: aStream.
	aStream space.
	self dayIndex printOn: aStream.
	self is3holeVersion
		ifTrue: [ aStream space.
			self dayName printOn: aStream ].
	aStream nextPut: $)
]

{ #category : #accessing }
Board >> solveWithPieces: pieces at: anInteger current: anObject solutionDo: aBlock [
	anInteger > pieces size ifTrue: [ ^ aBlock cull: anObject cull: self ].
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
