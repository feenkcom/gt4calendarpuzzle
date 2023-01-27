Class {
	#name : #BitArrayExamples,
	#superclass : #Object,
	#category : #GToolkit4CalendarPuzzle
}

{ #category : #accessing }
BitArrayExamples >> testArray [
	<gtExample>
	| array |
	array := BitArray withAll: #(
		2r1010 
		2r0110 
		2r1001
	) andWidth: 4.
	self assert: (array bitAt: 1 @ 1) = 0.
	self assert: (array bitAt: 2 @ 1) = 1.
	self assert: (array bitAt: 3 @ 1) = 0.
	self assert: (array bitAt: 4 @ 3) = 1.
	self assert: (array bitAt: 2 @ 3) = 0.
	self assert: (array width = 4).
	self assert: (array height = 3).
	^ array
]

{ #category : #accessing }
BitArrayExamples >> testExplicitSizeConstructor [
	<gtExample>
	| array |
	array := BitArray size: 4@3.
	self assert: array width = 4.
	self assert: array height = 3.
	^array
]

{ #category : #'as yet unclassified' }
BitArrayExamples >> testFlippedHorizontal [
	<gtExample>
	| array original |
	original := self testArray.
	array := original flippedHorizontal.
	self assert: array = (BitArray withAll: #(
		2r0101
		2r0110 
		2r1001 
	)).
	self assert: original = self testArray.
	^ array
]

{ #category : #accessing }
BitArrayExamples >> testFlippedVertical [
	<gtExample>
	| array original |
	original := self testArray.
	array := original flippedVertical.
	self assert: array = (BitArray withAll: #(
		2r1001 
		2r0110 
		2r1010
	)).
	self assert: original = self testArray.
	^ array
]

{ #category : #accessing }
BitArrayExamples >> testImplicitWidthArray [
	<gtExample>
	| array |
	array := BitArray withAll: #(
		2r0001 
		2r0000 
		2r1001
	).
	self assert: array width = 4.
	^ array
]

{ #category : #accessing }
BitArrayExamples >> testTransposed [
	<gtExample>
	| array original |
	original := self testArray.
	array := original transposed.
	self assert: array = (BitArray withAll: #(
		2r100
		2r011
		2r010
		2r101
	)).
	self assert: original = self testArray.
	^ array
]
