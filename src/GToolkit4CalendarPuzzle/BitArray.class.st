Class {
	#name : #BitArray,
	#superclass : #Object,
	#instVars : [
		'array',
		'width',
		'max'
	],
	#category : #GToolkit4CalendarPuzzle
}

{ #category : #'as yet unclassified' }
BitArray class >> size: aPoint [ 
	^self new size: aPoint
]

{ #category : #accessing }
BitArray class >> withAll: aCollection [
	"Derive width from longest bit pattern"

	| width |
	width := aCollection inject: 0 into: [ :max :each | max max: each highBit ].
	^ self withAll: aCollection andWidth: width
]

{ #category : #accessing }
BitArray class >> withAll: aCollection andWidth: width [ 
	^self new array: aCollection; width: width
]

{ #category : #accessing }
BitArray >> = aBitArray [
	aBitArray class == self class ifFalse: [ ^ false ].
	^ array = aBitArray array
]

{ #category : #accessing }
BitArray >> array [
	^array
]

{ #category : #accessing }
BitArray >> array: aCollection [ 
	array := aCollection
]

{ #category : #accessing }
BitArray >> at: anIndex [
	^array at: anIndex
]

{ #category : #accessing }
BitArray >> at: anIndex put: anObject [
	array at: anIndex put: anObject
]

{ #category : #accessing }
BitArray >> bitAt: aPoint [
	^ ((self at: aPoint y) & (1 bitShift: aPoint x - 1)) isZero
		ifTrue: [ 0 ]
		ifFalse: [ 1 ]
]

{ #category : #accessing }
BitArray >> bitAt: aPoint put: aBit [
	| row |
	row := array at: aPoint y.
	row := row bitAt: aPoint x put: aBit.
	array := array asOrderedCollection
			at: aPoint y put: row;
			asArray
]

{ #category : #accessing }
BitArray >> canPlace: arr at: aPoint [
	aPoint y + arr height - 1 > self height ifTrue: [ ^ false ].
	arr
		doWithIndex: [ :value :y | 
			| shifted |
			shifted := value bitShift: aPoint x - 1.
			shifted >= max ifTrue: [ ^ false ].
			((self at: y + aPoint y - 1) bitAnd: shifted) = 0 ifFalse: [ ^ false ] ].
	^ true
]

{ #category : #'as yet unclassified' }
BitArray >> doWithIndex: aBlock [
	array doWithIndex: aBlock 
]

{ #category : #'as yet unclassified' }
BitArray >> flippedHorizontal [
	| newArray |
	newArray := array
			collect: [ :anInteger | 
				| inverted current |
				inverted := 0.
				current := anInteger.
				self width
					timesRepeat: [ inverted := (inverted bitShift: 1) bitOr: (current bitAnd: 1).
						current := current bitShift: -1 ].
				inverted ].
	^ BitArray withAll: newArray andWidth: self width
]

{ #category : #accessing }
BitArray >> flippedVertical [
	^ self class withAll: array reversed
]

{ #category : #accessing }
BitArray >> gridElementWithOneColor: oneColor zeroColor: zeroColor [
	| container |
	container := BlElement new
			layout: (BlGridLayout new columnCount: width);
			constraintsDo: [ :c | 
				c vertical matchParent.
				c horizontal matchParent ].
	1
		to: self height
		do: [ :y | 
			1
				to: self width
				do: [ :x | 
					| aPoint |
					aPoint := x @ y.
					container
						addChild: (BlElement new
								border: Color gray veryMuchLighter;
								background: ((self bitAt: aPoint) = 0 ifTrue: [ zeroColor ] ifFalse: [ oneColor ])) ] ].
	^ container
]

{ #category : #accessing }
BitArray >> gtGridFor: aView [
	<gtView>
	^ aView explicit
		title: 'Grid';
		stencil: [ self gridElementWithOneColor: Color transparent zeroColor: Color gray ]
]

{ #category : #accessing }
BitArray >> hash [
	^array hash
]

{ #category : #accessing }
BitArray >> height [
	^ array size
]

{ #category : #'as yet unclassified' }
BitArray >> inverted [
	|result|
	result := self copy.
	result array: (array collect: [:each | each bitInvert]).
	^result
]

{ #category : #accessing }
BitArray >> place: arr at: aPoint [
	| newArray |
	newArray := self copy.
	arr
		doWithIndex: [ :value :y | 
			newArray
				at: y + aPoint y - 1
				put: ((self at: y + aPoint y - 1) bitOr: (value bitShift: aPoint x - 1)) ].
	^ newArray
]

{ #category : #accessing }
BitArray >> postCopy [
	super postCopy.
	array := array copy
]

{ #category : #accessing }
BitArray >> size: aPoint [
	width := aPoint x.
	array := Array new: aPoint y withAll: 0.
	^ self
]

{ #category : #accessing }
BitArray >> transposed [
	| result |
	result := BitArray size: self height @ self width.
	1
		to: self width
		do: [ :x | 1 to: self height do: [ :y | result bitAt: y @ x put: (self bitAt: x @ y) ] ].
	^ result
]

{ #category : #accessing }
BitArray >> width [
	^ width
]

{ #category : #accessing }
BitArray >> width: anInteger [
	width := anInteger.
	max := 1 bitShift: anInteger
]
