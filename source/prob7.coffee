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

#-1 == ?, -2 = crossed-zero

isMoreGeneral = (h1, h2) ->
	val = true
	for i in [0...4]
		if h1[i] isnt h2[i] and h1[i] isnt -1 and h2[i] isnt -2
			val = false
			break
	val

isConsistent = (hypothesis, example) ->
	val = true

	if example[4] is true
		for i in [0...4]
			if hypothesis[i] != example[i] and hypothesis[i] != -1
				val = false
				break
		val
	else
		val = false
		for i in [0...4]
			if hypothesis[i] != example[i] and hypothesis[i] != -1
				val = true
				break
		#console.log "hypothesis #{hypothesis} example #{example}"
		val

console.log isMoreGeneral([Sunny, Hot, -1, Weak], [Sunny, Hot, -1, -1])

candid = (examples) ->
	G = [[-1, -1, -1, -1]]
	S = [[-2, -2, -2, -2]]

	for example in examples
		console.log "example: #{example}"
		console.log "G"
		console.log G
		console.log "S"
		console.log S
		if example[4] is true

			shouldRemove = false
			G = (hypothesis for hypothesis in G when isConsistent(hypothesis, example))

			NS = (s for s in S when isConsistent(s, example))
			for s in S when isConsistent(s, example) is false
				for i in [0...4]
					if s[i] != example[i]
						if s[i] is -2
							s[i] = example[i]
						else if s[i] is not -1
							s[i] = -1
					if isConsistent(s, example)
						break
				for g in G
					if isMoreGeneral(g, s)
						NS.push(x for x in s)
						break;

			S = NS
		else
			shouldRemove = false
			
			S = (hypothesis for hypothesis in S when isConsistent(hypothesis, example))

			#console.log S

			NG = (g for g in G when isConsistent(g, example))
			for g in G when isConsistent(g, example) is false
				for i in [0...4]
					if g[i] == -1
						max = if i < 2 then 3 else 2
						tmp = g[i]
						for n in [0...max] when n isnt example[i]
							g[i] = n
							#console.log "specialized g, #{g}"
							if isConsistent(g, example)
								#console.log "It's consistent"
								for s in S
									if isMoreGeneral(g, s)
										#console.log "push here"
										NG.push(x for x in g)
										break;
						g[i] = tmp

			G = NG
	S.concat(G)


console.log candid(dataset)