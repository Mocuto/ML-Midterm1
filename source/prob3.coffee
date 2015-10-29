###
author: Tobi Akomolede
date: 10/22/2015

###

f = (a, b, c, d) -> (a or b) and (c or !d)

sum = (list) ->
	accum = 0.0
	(accum += item) for item in list
	accum

entropy = (list) ->  
	val = sum (Math.log2(item) * item for item in list when item isnt 0)
	val * -1

console.log sum [0..4]

console.log (entropy([9/14, 5/14]))

bl = [false, true]
positive = 0;
negative = 0;


compileValues = (listA, listB, listC, listD) ->
	values = []
	for a in listA
		for b in listB
			for c in listC
				for d in listD
					obj = {"a" : a, "b" : b, "c" : c, "d" : d, "class" : f(a,b,c,d)}
					values.push(obj)

	values

countPositive = (list) -> (obj for obj in list when obj.class is true).length

countNegative = (list) -> list.length - countPositive(list)

					# ...
values = compileValues(bl, bl, bl, bl)

total = values.length

console.log("P(+) = #{countPositive(values)} / #{total} P(-) = #{countNegative(values)} / #{total}")

#test total entropy

testE = 0.940
pWeakPos = 6
pWeakNeg = 2
pWeakTotal = pWeakPos + pWeakNeg
entropyWeak = entropy([pWeakPos / pWeakTotal, pWeakNeg / pWeakTotal])

pStrongPos = 3
pStrongNeg = 3
pStrongTotal = pStrongPos + pStrongNeg
entropyStrong = entropy([pStrongPos / pStrongTotal, pStrongNeg / pStrongTotal])
igW = testE - ((pWeakTotal / 14) * (entropyWeak )) - ((pStrongTotal / 14) * entropyStrong)

console.log "#{entropyStrong} #{entropyWeak} igW is #{igW}"

#total entropy

positive = countPositive(values)
negative = countNegative(values)

totalE = entropy([positive / total, negative / total])

console.log "total entropy is #{totalE}"

#information gain for a
calcIGA = (listB, listC, listD) ->
	compileValuesForATrue = compileValues([true], listB, listC, listD)
	compileValuesForAFalse = compileValues([false], listB, listC, listD)

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
calcIGB = (listA, listC, listD) ->
	compileValuesForBTrue = compileValues(listA, [true], listC, listD)
	compileValuesForBFalse = compileValues(listA, [false], listC, listD)

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
calcIGC = (listA, listB, listD) ->
	compileValuesForCTrue = compileValues(listA, listB, [true], listD)
	compileValuesForCFalse = compileValues(listA, listB, [false], listD)

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

#information gain for d
calcIGD = (listA, listB, listC) ->
	compileValuesForDTrue = compileValues(listA, listB, listC, [true])
	compileValuesForDFalse = compileValues(listA, listB, listC, [false])

	countPositiveDTrue = countPositive(compileValuesForDTrue)
	countNegativeDTrue = countNegative(compileValuesForDTrue)

	countPositiveDFalse = countPositive(compileValuesForDFalse)
	countNegativeDFalse = countNegative(compileValuesForDFalse)

	console.log "For D = true, P(+) = #{countPositiveDTrue} P(-) = #{countNegativeDTrue}"

	console.log "For D = false, P(+) = #{countPositiveDFalse} P(-) = #{countNegativeDFalse}"

	entropyDTrue = entropy([countPositiveDTrue / (countPositiveDTrue + countNegativeDTrue), countNegativeDTrue / (countPositiveDTrue + countNegativeDTrue) ])

	entropyDFalse = entropy([countPositiveDFalse / (countPositiveDFalse + countNegativeDFalse), countNegativeDFalse / (countPositiveDFalse + countNegativeDFalse) ])

	igD = totalE - (((countPositiveDTrue + countNegativeDTrue) / total) * entropyDTrue) - (((countPositiveDFalse + countNegativeDFalse) / total) * entropyDFalse)

#console.log compileValuesForCTrue

	console.log "entropyDTrue: #{entropyDTrue} entropyDFalse: #{entropyDFalse} igD: #{igD}"
	igD

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