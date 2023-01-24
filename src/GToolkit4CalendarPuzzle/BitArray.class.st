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

{ #category : #accessing }
BitArray class >> withAll: aCollection andWidth: width [ 
	^self new array: aCollection; width: width
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
BitArray >> canPlace: arr at: aPoint [
	aPoint y + arr size - 1 > self size ifTrue: [ ^ false ].
	arr
		doWithIndex: [ :value :y | 
			| shifted |
			shifted := value bitShift: aPoint x - 1.
			shifted >= max ifTrue: [ ^ false ].
			((self at: y + aPoint y - 1) bitAnd: shifted) = 0 ifFalse: [ ^ false ] ].
	^ true
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
BitArray >> width: anInteger [
	width := anInteger.
	max := 1 bitShift: anInteger
]
