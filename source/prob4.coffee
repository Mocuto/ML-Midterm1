###
author: Tobi Akomolede
date: 10/22/2015

###

dataset = [
	[1, 0,0, 1],
	[1, 2,2, -1],
	[1, 2.5, 2.5, -1],
	[1, 0, 2, 1],
	[1, 1, 2, -1],
	[1, 2, 0, 1]
]

sum = (list) ->
	accum = 0.0
	(accum += item) for item in list
	accum

dotProduct = (vec1, vec2) -> sum (vec1[i] * vec2[i] for i in [0...Math.min(vec1.length, vec2.length)])

trainPercepton = (examples, maxWeight = 0.1, minError = 0.01, rate = 0.05) ->
	error = 99999;

	iterations = 0;

	weightLength = (examples[0].length - 1)

	weights = (Math.random() * maxWeight for i in [0...weightLength])

	#console.log "weights are #{weights} #{examples[0]} #{weightLength}"

	while true
		error = 0;
		for example in examples
			target = Number(example[example.length - 1])
			tempOutput = dotProduct(weights, example)

			output = if tempOutput > 0 then 1 else -1

			for i in [0...weightLength]
				weights[i] = weights[i] + (rate * (target - output) * example[i])
				error +=  Math.abs(rate * (target - output) * example[i])

		#console.log "error is #{error} #{error > minError}"

		iterations++;

		break unless (error > minError)

	console.log "final error #{error}"
	console.log "took #{iterations} iterations"
	weights

console.log (weights = trainPercepton(dataset))

mapOutput = (output) -> if output > 0 then 1 else -1

inaccuracies = 0;
for example in dataset
	output =  mapOutput(dotProduct(weights, example))
	console.log "output #{output} should be #{example[3]}"

	inaccuracies += if output isnt example[3] then 1 else 0

console.log "inaccuracies: #{inaccuracies}"

dataset1 = [
	[1, 0,0, 1],
	[1, 2.5, 2.5, -1],
	[1, 0, 2, 1],
	[1, 1, 2, -1],
	[1, 2, 0, 1]
]

dataset2 = [
	[1, 0,0, 1],
	[1, 2,2, -1],
	[1, 0, 2, 1],
	[1, 1, 2, -1],
	[1, 2, 0, 1]
]

dataset3 = [
	[1, 0,0, 1],
	[1, 2,2, -1],
	[1, 2.5, 2.5, -1],
	[1, 0, 2, 1],
	[1, 2, 0, 1]
]
console.log "removing 2 2 -"
console.log (weights = trainPercepton(dataset1))

console.log "removing 2.5 2.5 -"
console.log (weights = trainPercepton(dataset2))

console.log "removing 1 2 -"
console.log (weights = trainPercepton(dataset3))
