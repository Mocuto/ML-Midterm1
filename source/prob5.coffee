###
author: Tobi Akomolede
date: 10/22/2015

###

dataset = [
	{a1 : true, a2 : true, a3 : true, class : true},
	{a1 : true, a2 : false, a3 : true, class : true},
	{a1 : true, a2 : false, a3 : false, class : false},
	{a1 : false, a2 : false, a3 : true, class : true},
	{a1 : false, a2 : true, a3 : false, class : false}
	{a1 : false, a2 : true, a3 : true, class : false}
]

sum = (list) ->
	accum = 0.0
	(accum += item) for item in list
	accum

entropy = (list) ->  
	val = sum (Math.log2(item) * item for item in list when item isnt 0)
	val * -1


bl = [false, true]
positive = 0;
negative = 0;


compileValues = (examples, listA1, listA2, listA3) ->
	values = []
	for a in listA1
		for b in listA2
			for c in listA3
				for item in examples
					if item.a1 is a and item.a2 is b and item.a3 is c then values.push(item)

	values

countPositive = (list) -> (obj for obj in list when obj.class is true).length

countNegative = (list) -> list.length - countPositive(list)

					# ...
values = compileValues(dataset, bl, bl, bl)

total = values.length

console.log("P(+) = #{countPositive(values)} / #{total} P(-) = #{countNegative(values)} / #{total}")
console.log "total is #{total}"
#total entropy

positive = countPositive(values)
negative = countNegative(values)

totalE = entropy([positive / total, negative / total])

console.log "total entropy is #{totalE}"


console.log (entropy([9/14, 5/14]))


#information gain for a
calcIGA1 = (examples, listA2, listA3) ->
	compileValuesForATrue = compileValues(examples, [true], listA2, listA3)
	compileValuesForAFalse = compileValues(examples, [false], listA2, listA3)

	countPositiveATrue = countPositive(compileValuesForATrue)
	countNegativeATrue = countNegative(compileValuesForATrue)

	countPositiveAFalse = countPositive(compileValuesForAFalse)
	countNegativeAFalse = countNegative(compileValuesForAFalse)

	console.log "For A = true, P(+) = #{countPositiveATrue} P(-) = #{countNegativeATrue}"

	console.log "For A = false, P(+) = #{countPositiveAFalse} P(-) = #{countNegativeAFalse}"

	entropyATrue = entropy([countPositiveATrue / (countPositiveATrue + countNegativeATrue), countNegativeATrue / (countPositiveATrue + countNegativeATrue) ])

	entropyAFalse = entropy([countPositiveAFalse / (countPositiveAFalse + countNegativeAFalse), countNegativeAFalse / (countPositiveAFalse + countNegativeAFalse) ])

	igA = totalE - (((countPositiveATrue + countNegativeATrue) / total) * entropyATrue) - (((countPositiveAFalse + countNegativeAFalse) / total) * entropyAFalse)

	console.log "entropyATrue: #{entropyATrue} entropyAFalse: #{entropyAFalse} igA: #{igA}"

	igA

#information gain for b
calcIGA2 = (examples, listA1, listA3) ->
	compileValuesForBTrue = compileValues(examples, listA1, [true], listA3)
	compileValuesForBFalse = compileValues(examples, listA1, [false], listA3)

	countPositiveBTrue = countPositive(compileValuesForBTrue)
	countNegativeBTrue = countNegative(compileValuesForBTrue)

	countPositiveBFalse = countPositive(compileValuesForBFalse)
	countNegativeBFalse = countNegative(compileValuesForBFalse)

	console.log "For B = true, P(+) = #{countPositiveBTrue} P(-) = #{countNegativeBTrue}"

	console.log "For B = false, P(+) = #{countPositiveBFalse} P(-) = #{countNegativeBFalse}"

	entropyBTrue = entropy([countPositiveBTrue / (countPositiveBTrue + countNegativeBTrue), countNegativeBTrue / (countPositiveBTrue + countNegativeBTrue) ])

	entropyBFalse = entropy([countPositiveBFalse / (countPositiveBFalse + countNegativeBFalse), countNegativeBFalse / (countPositiveBFalse + countNegativeBFalse) ])

	igB = totalE - (((countPositiveBTrue + countNegativeBTrue) / total) * entropyBTrue) - (((countPositiveBFalse + countNegativeBFalse) / total) * entropyBFalse)

	console.log "entropyBTrue: #{entropyBTrue} entropyBFalse: #{entropyBFalse} igB: #{igB}"
	igB

#information gain for c
calcIGA3 = (examples, listA1, listA2) ->
	compileValuesForCTrue = compileValues(examples, listA1, listA2, [true])
	compileValuesForCFalse = compileValues(examples, listA1, listA2, [false])

	countPositiveCTrue = countPositive(compileValuesForCTrue)
	countNegativeCTrue = countNegative(compileValuesForCTrue)

	countPositiveCFalse = countPositive(compileValuesForCFalse)
	countNegativeCFalse = countNegative(compileValuesForCFalse)

	console.log "For C = true, P(+) = #{countPositiveCTrue} P(-) = #{countNegativeCTrue}"

	console.log "For C = false, P(+) = #{countPositiveCFalse} P(-) = #{countNegativeCFalse}"

	entropyCTrue = entropy([countPositiveCTrue / (countPositiveCTrue + countNegativeCTrue), countNegativeCTrue / (countPositiveCTrue + countNegativeCTrue) ])

	entropyCFalse = entropy([countPositiveCFalse / (countPositiveCFalse + countNegativeCFalse), countNegativeCFalse / (countPositiveCFalse + countNegativeCFalse) ])

	igC = totalE - (((countPositiveCTrue + countNegativeCTrue) / total) * entropyCTrue) - (((countPositiveCFalse + countNegativeCFalse) / total) * entropyCFalse)

	console.log compileValuesForCTrue

	console.log "entropyCTrue: #{entropyCTrue} entropyCFalse: #{entropyCFalse} igC: #{igC}"
	igC

console.log "H(A3 | A2 = T)"
console.log calcIGA3(dataset, bl, [true])

console.log "find largest entropy"
console.log calcIGA1(dataset, bl, bl)
console.log calcIGA2(dataset, bl, bl)

console.log calcIGA3(dataset, bl, bl)

console.log "A1 is true"

console.log calcIGA2(dataset, [true], bl)
console.log calcIGA3(dataset, [true], bl)

console.log "A1 is true, A3 is true"

console.log calcIGA2(dataset, [true], [true])

console.log "A1 is true, A3 is false"

console.log calcIGA2(dataset, [true], [false])

console.log "A1 is false"

console.log calcIGA2(dataset, [false], bl)
console.log calcIGA3(dataset, [false], bl)

console.log "A1 is false, A2 is true"

console.log calcIGA3(dataset, [false], [true])

console.log "A1 is fakse, A2 is false"

console.log calcIGA3(dataset, [false], [false])



###

console.log calcIGA(bl, bl, bl)

console.log calcIGB(bl, bl, bl)

console.log calcIGC(bl, bl, bl)

console.log calcIGD(bl, bl, bl)

#For A = T
console.log "For A is true"
console.log ""

calcIGB([true], bl, bl)
calcIGC([true], bl, bl)
calcIGD([true], bl, bl)

#For A = F
console.log "For A is false"
console.log ""

calcIGB([false], bl, bl)
calcIGC([false], bl, bl)
calcIGD([false], bl, bl)

#For A = T, C = T
console.log "For A is true, C is true"
console.log ""

calcIGB([true], [true], bl)
calcIGD([true], [true], bl)

#For A = T, C = F, D = T
console.log "For A is true, C is false, D is true"
console.log ""

calcIGB([true], [false], [true])

#For A = T, C = F
console.log "For A is true, C is false"
console.log ""

calcIGB([true], [false], bl)
calcIGD([true], bl, [false])

#For A = F, B = T
console.log "For A is false, B is true"
console.log ""

calcIGC([false], [true], bl)
calcIGD([false], bl, [true])

#For A = F, B = T, C T
console.log "For A is false, B is true, C is true"
console.log ""

calcIGD([false], [true], [true])

#For A = F, B = T, C F
console.log "For A is false, B is true, C is false"
console.log ""

calcIGD([false], [true], [false])

#For A = F, B = F
console.log "For A is false, B is false"
console.log ""

calcIGC([false], [false], bl)
calcIGD([false], [false], bl)

###