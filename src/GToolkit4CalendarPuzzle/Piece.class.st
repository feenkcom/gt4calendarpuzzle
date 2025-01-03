Class {
	#name : #Piece,
	#superclass : #Object,
	#instVars : [
		'array',
		'permutations'
	],
	#category : #GToolkit4CalendarPuzzle
}

{ #category : #accessing }
Piece class >> layout: aCollection [ 
	^self new layout: (BitArray withAll: aCollection)
]

{ #category : #accessing }
Piece class >> standard2holePieces [
	^ {self layout: #(2r011 2r010 2r110).
		self layout: #(2r110 2r111).
		self layout: #(2r001 2r001 2r111).
		self layout: #(2r1100 2r0111).
		self layout: #(2r1000 2r1111).
		self layout: #(2r101 2r111).
		self layout: #(2r1111 2r0010).
		self layout: #(2r111 2r111)}
]

{ #category : #accessing }
Piece class >> standard3holePieces [
	^ {self layout: #(2r111 2r010 2r010).
		self layout: #(2r011 2r010 2r110).
		self layout: #(2r110 2r011).
		self layout: #(2r110 2r111).
		self layout: #(2r001 2r001 2r111).
		self layout: #(2r1100 2r0111).
		self layout: #(2r1000 2r1111).
		self layout: #(2r101 2r111).
		self layout: #(2r1111).
		self layout: #(2r111 2r100)}
]

{ #category : #accessing }
Piece >> gtGridFor: aView [
	<gtView>
	^ aView explicit
		title: 'Grid';
		stencil: [ array gridElementWithOneColor: Color gray zeroColor: Color transparent]
]

{ #category : #accessing }
Piece >> gtPermutationsFor: aView [
	<gtView>
	^ aView list
		title: 'Permutations';
		items: [ self permutations asArray ];
		itemStencil: [ BlScalableElement new
				size: 200 @ 200;
				margin: (BlInsets all: 10) ];
		itemDataBinder: [ :eachElement :each :eachIndex | 
			eachElement
				addChild: (each gridElementWithOneColor: Color gray zeroColor: Color transparent) ]
]

{ #category : #accessing }
Piece >> invert: anInteger length: size [
	| current inverted |
	inverted := 0.
	current := anInteger.
	1
		to: size
		do: [ :i | 
			inverted := (inverted bitShift: 1) bitOr: (current bitAnd: 1).
			current := current bitShift: -1 ].
	^ inverted
]

{ #category : #accessing }
Piece >> layout: aCollection [
	array := aCollection
]

{ #category : #accessing }
Piece >> length [
	^ array inject: 0 into: [ :sum :each | sum max: (self length: each) ]
]

{ #category : #accessing }
Piece >> length: anInteger [
	| value length |
	value := anInteger.
	length := 0.
	[ value = 0 ]
		whileFalse: [ length := length + 1.
			value := value bitShift: -1 ].
	^ length
]

{ #category : #accessing }
Piece >> permutations [
	^ permutations
		ifNil: [ | transposed flipped |
			permutations := Set with: array.
			permutations add: array flippedVertical.
			permutations add: (flipped := array flippedHorizontal).
			permutations add: flipped flippedVertical.
			permutations add: (transposed := array transposed).
			permutations add: transposed flippedVertical.
			permutations add: (flipped := transposed flippedHorizontal).
			permutations add: flipped flippedVertical.
			permutations ]
]

{ #category : #accessing }
Piece >> permutationsDo: aBlock [
	self permutations do: aBlock
]

{ #category : #accessing }
Piece >> transposedArray [
	| length result |
	length := self length.
	result := Array new: length.
	1
		to: result size
		do: [ :i | 
			| value mask |
			value := 0.
			mask := 1 bitShift: i - 1.
			array
				do: [ :each | 
					value := (value bitShift: 1)
							+ ((each bitAnd: mask) = 0 ifTrue: [ 0 ] ifFalse: [ 1 ]) ].
			result at: i put: value ].
	^ result
]
