/datum/uplink_item/bundles_TC/role_surplus //Donkstation change, blatantly stolen from surplus crate code
	name = "Syndicate Faction Surplus Crate"
	desc = "A crate of goodies, stocked purely with your employing faction's equipment. Currently being test flighted. Duplicates likely. \
			Rumored to contain a valuable assortment of items, \
			but you never know. Contents are sorted to always be worth 50 TC."
	item = /obj/structure/closet/crate
	cost = 20
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops, /datum/game_mode/traitor/internal_affairs, /datum/game_mode/incursion)
	var/starting_crate_value = 50

/datum/uplink_item/bundles_TC/role_surplus/purchase(mob/user, datum/component/uplink/U)
	var/hardsuit_count = 0 //i've gotten SIX in one crate before
	var/gun_count = 0
	var/list/uplink_items = get_uplink_items(SSticker && SSticker.mode? SSticker.mode : null, FALSE, TRUE, FALSE)
	var/datum/antagonist/user_antag = user.mind.has_antag_datum(/datum/antagonist/traitor)
	var/obj/structure/closet/crate/C = spawn_item(/obj/structure/closet/crate, user, U)
	if(isnull(user_antag))
		to_chat(user, "<span class='warning'><b>Something fucked up. Here's your Telecrystals back, at least.</b></span>")
		new /obj/item/stack/telecrystal/twenty(get_turf(user))
		return C
	var/user_antag_faction = user_antag.synd_faction
	if((user_antag_faction & SYND_FACTION_SYND) || isnull(user_antag_faction))
		to_chat(user, "<span class='warning'><b>Something fucked up. Here's your Telecrystals back, at least.</b></span>")
		new /obj/item/stack/telecrystal/twenty(get_turf(user))
		return C
	for(var/list/L in uplink_items)
		for(var/datum/uplink_item/UI in L)
			if(!(UI.faction_flags & user_antag_faction))
				uplink_items -= UI
	var/crate_value = starting_crate_value
	if(U.purchase_log)
		U.purchase_log.LogPurchase(C, src, cost)
	while(crate_value)
		var/category = pick(uplink_items)
		var/item = pick(uplink_items[category])
		var/datum/uplink_item/I = uplink_items[category][item]

		if(!I.surplus || prob(100 - I.surplus))
			continue
		if(crate_value < I.cost)
			continue
		if(!(I.faction_flags & user_antag_faction))
			continue
		if(istype(I, /datum/uplink_item/dangerous) && prob(33))
			continue
		if(istype(I, /datum/uplink_item/suits) && prob(50))
			if(hardsuit_count <= 0)
				hardsuit_count += 1
			else if(hardsuit_count == 1)
				if(prob(33))
					hardsuit_count += 1
				else //2 suits max
					continue
			else
				continue
		if(I.isgun)
			if(gun_count <= 0)
				gun_count += 1
			else if(gun_count == 1)
				if(prob(33))
					gun_count += 1
				else
					continue
			else
				continue
		crate_value -= I.cost
		var/obj/goods = new I.item(C)
		if(U.purchase_log)
			U.purchase_log.LogPurchase(goods, I, 0)
	return C
