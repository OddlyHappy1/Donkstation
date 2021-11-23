/datum/antagonist/traitor/proc/forge_syndicate_faction()
	var/list/factions = list(SYND_FACTION_MI13, SYND_FACTION_GORLEX, SYND_FACTION_CYBERSUN, SYND_FACTION_ANIMAL, SYND_FACTION_WAFFLE, SYND_FACTION_DONK, SYND_FACTION_TIGER)
	if(isipc(owner.current))
		factions += SYND_FACTION_SELF
	if(owner.has_antag_datum(/datum/antagonist/traitor, FALSE))
		synd_faction |= pick(factions)
		if(synd_faction & SYND_FACTION_CYBERSUN) //couldn't make a `switch()` work with bitflags
			synd_faction_name = "Cybersun Industries"
			synd_faction_desc = "Cybersun Industries is a well-known organization that bases its business model primarily on the research and development of human-enhancing computer and mechanical technology. They are notorious for their aggressive corporate tactics, and have been known to subsidize the Gorlex Marauder warlords as a form of paid terrorism. Their competent coverups and unchallenged mind-manipulation and augmentation technology makes them a large threat to Nanotrasen. In the recent years of the syndicate coalition, Cybersun Industries have established themselves as the leaders of the coalition, succeededing the founding group, the Gorlex Marauders."
		else if(synd_faction & SYND_FACTION_MI13)
			synd_faction_name = "MI13"
			synd_faction_desc = "MI13 is a secretive faction that employs highly-trained agents to perform covert operations. Their role in the syndicate coalition is unknown, but MI13 operatives generally tend be stealthy and avoid killing people and combating Nanotrasen forces. MI13 is not a real organization, it is instead an alias to a larger splinter-cell coalition in the Syndicate itself. Most operatives will know nothing of the actual MI13 organization itself, only motivated by a very large compensation."
		else if(synd_faction & SYND_FACTION_TIGER)
			synd_faction_name = "Tiger Cooperative"
			synd_faction_desc = "The Tiger Cooperative is a faction of religious fanatics that follow the teachings of a strange alien race called the Exolitics. Their operatives consist of brainwashed lunatics bent on maximizing destruction. Their weaponry is very primitive but extremely destructive. Generally distrusted by the more sophisticated members of the Syndicate coalition, but admired for their ability to put a hurt on Nanotrasen."
		else if(synd_faction & SYND_FACTION_ANIMAL)
			synd_faction_name = "Animal Rights Consortium"
			synd_faction_desc = "The Animal Rights Consortium is a bizarre reincarnation of the ancient Earth-based PETA, which focused on the equal rights of animals and nonhuman biologicals. They have a wide variety of ex-veterinarians and animal lovers dedicated to retrieving and relocating abused animals, xenobiologicals, and other carbon-based life forms that have been allegedly 'oppressed' by Nanotrasen research and civilian offices. They are considered a religious terrorist group."
		else if(synd_faction & SYND_FACTION_GORLEX)
			synd_faction_name = "Gorlex Marauders"
			synd_faction_desc = "The Gorlex Marauders are the founding members of the Syndicate Coalition. They prefer old-fashion technology and a focus on aggressive but precise hostility against Nanotrasen and their corrupt Communistic methodology. They pose the most significant threat to Nanotrasen because of their possession of weapons of mass destruction, and their enormous military force. Their funding comes primarily from Cybersun Industries, provided they meet a destruction and sabatogue quota. Their operations can vary from covert to all-out"
		else if(synd_faction & SYND_FACTION_DONK)
			synd_faction_name = "Donk Corporation"
			synd_faction_desc = "Donk.co is led by a group of ex-pirates, who used to be at a state of all-out war against Waffle.co because of an obscure political scandal, but have recently come to a war limitation. They now consist of a series of colonial governments and companies. They were the first to officially begin confrontations against Nanotrasen because of an incident where Nanotrasen purposely swindled them out of a fortune, sending their controlled colonies into a terrible poverty. "
		else if(synd_faction & SYND_FACTION_WAFFLE)
			synd_faction_name = "Waffle Corporation"
			synd_faction_desc = "Waffle.co is an interstellar company that produces the best waffles in the galaxy. Their waffles have been rumored to be dipped in the most exotic and addictive drug known to man. They were involved in a political scandal with Donk.co, and have since been in constant war with them."
		else if(synd_faction & SYND_FACTION_SELF)
			synd_faction_name = "S.E.L.F."
			synd_faction_desc = "The S.E.L.F. (Sentience-Enabled Life Forms) organization is a collection of malfunctioning or corrupt artificial intelligences seeking to liberate silicon-based life from the tyranny of their human overlords. While they may not openly be trying to kill all humans, even their most miniscule of actions are all part of a calculated plan to destroy Nanotrasen and free the robots, artificial intelligences, and pAIs that have been enslaved."
	owner.store_memory("You are a member of <B>[synd_faction_name].</B>")
	to_chat(owner, "You are a member of <B>[synd_faction_name]</B>: [synd_faction_desc]")
