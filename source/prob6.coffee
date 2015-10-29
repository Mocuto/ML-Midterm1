###
author: Tobi Akomolede
date: 10/22/2015

###

OutlookValues = [Sunny, Overcast, Rain] = [0,1,2]
TempValues  = [Hot, Mild, Cool] = [0,1,2]
HumidityValues = [High, Normal] = [0,1]
WindValues = [Weak, Strong] = [0,1] 

dataset = [
	[Sunny, Hot, High, Weak, false],
	[Sunny, Hot, High, Strong, false],
	[Overcast, Hot, High, Weak, true],
	[Rain, Mild, High, Weak, true],
	[Rain, Cool, Normal, Weak, true],
	[Rain, Cool, Normal, Strong, false],
	[Overcast, Cool, Normal, Strong, true],
	[Sunny, Mild, High, Weak, false],
	[Sunny, Cool, Normal, Weak, true],
	[Rain, Mild, Normal, Weak, true],
	[Sunny, Mild, Normal, Strong, true],
	[Overcast, Mild, High, Strong, true],
	[Overcast, Hot, Normal, Weak, true],
	[Rain, Mild, High, Strong, false]
]

classify = (examples, attributeSet, smoothingStrength = 1) ->

	trueProbability = ((x for x in examples when x[4] == true).length + smoothingStrength) / (examples.length + (smoothingStrength * 2))
	falseProbability = ((x for x in examples when x[4] == false).length + smoothingStrength) / (examples.length + (smoothingStrength * 2))

	#Calculate for Y = true
	trueAccum = 1.0;
	falseAccum = 1.0;

	for i in [0...4]
		attribute = attributeSet[i]

		J = if i < 2 then 3 else 2

		probTrue = attribProbGivenY(examples, J, i, attribute, true, smoothingStrength)
		trueAccum = trueAccum * probTrue

		probFalse = attribProbGivenY(examples, J, i, attribute, false, smoothingStrength)
		falseAccum = falseAccum * probFalse

	yTrue = trueProbability * trueAccum
	yFalse = falseProbability * falseAccum

	if yTrue > yFalse then true else false

attribProbGivenY = (examples, J, attributeIndex, attributeValue, yValue, smoothingStrength) ->
	trueCount = 0
	totalCount = 0

	for example in examples
		if example[4] == yValue
			totalCount += 1
			if example[attributeIndex] == attributeValue
				trueCount += 1
	trueCount += smoothingStrength
	totalCount += smoothingStrength * J

	trueCount / totalCount

console.log "Should be true"
console.log classify(dataset, [Overcast, Hot, High, Weak])

console.log "Should be false"
console.log classify(dataset, [Sunny, Hot, High, Strong])

console.log "Unknown"
for i in [0...20]
	console.log classify(dataset, [Sunny, Cool, Normal, Weak], i)