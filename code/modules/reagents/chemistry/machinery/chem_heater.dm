/obj/machinery/chem_heater
	name = "chemical heater"
	density = TRUE
	icon = 'icons/obj/chemical.dmi'
	icon_state = "mixer0b"
	use_power = IDLE_POWER_USE
	idle_power_usage = 40
	resistance_flags = FIRE_PROOF | ACID_PROOF
	circuit = /obj/item/circuitboard/machine/chem_heater



	var/obj/item/reagent_containers/beaker = null
	var/target_temperature = 300
	var/heater_coefficient = 0.05
	var/on = FALSE

/obj/machinery/chem_heater/Destroy()
	QDEL_NULL(beaker)
	return ..()

/obj/machinery/chem_heater/handle_atom_del(atom/A)
	. = ..()
	if(A == beaker)
		beaker = null
		update_icon()

/obj/machinery/chem_heater/update_icon()
	if(beaker)
		icon_state = "mixer1b"
	else
		icon_state = "mixer0b"

/obj/machinery/chem_heater/AltClick(mob/living/user)
	if(!istype(user) || !user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return
	replace_beaker(user)
	ui_update()
	return

/obj/machinery/chem_heater/proc/replace_beaker(mob/living/user, obj/item/reagent_containers/new_beaker)
	if(beaker)
		beaker.forceMove(drop_location())
		if(user && Adjacent(user) && !issiliconoradminghost(user))
			user.put_in_hands(beaker)
	if(new_beaker)
		beaker = new_beaker
	else
		beaker = null
		on = FALSE
	update_icon()
	return TRUE

/obj/machinery/chem_heater/RefreshParts()
	heater_coefficient = 0.1
	for(var/obj/item/stock_parts/micro_laser/M in component_parts)
		heater_coefficient *= M.rating

/obj/machinery/chem_heater/examine(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user))
		. += "<span class='notice'>The status display reads: Heating reagents at <b>[heater_coefficient*1000]%</b> speed.</span>"

/obj/machinery/chem_heater/process(delta_time)
	..()
	if(stat & NOPOWER)
		return
	if(on)
		if(beaker && beaker.reagents.total_volume)
			//keep constant with the chemical acclimator please
			beaker.reagents.adjust_thermal_energy((target_temperature - beaker.reagents.chem_temp) * heater_coefficient * delta_time * SPECIFIC_HEAT_DEFAULT * beaker.reagents.total_volume)
			beaker.reagents.handle_reactions()

/obj/machinery/chem_heater/attackby(obj/item/I, mob/user, params)
	if(default_deconstruction_screwdriver(user, "mixer0b", "mixer0b", I))
		return

	if(default_deconstruction_crowbar(I))
		return

	if(istype(I, /obj/item/reagent_containers) && !(I.item_flags & ABSTRACT) && I.is_open_container())
		. = TRUE //no afterattack
		var/obj/item/reagent_containers/B = I
		if(!user.transferItemToLoc(B, src))
			return
		replace_beaker(user, B)
		to_chat(user, "<span class='notice'>You add [B] to [src].</span>")
		ui_update()
		update_icon()
		return
	return ..()

/obj/machinery/chem_heater/on_deconstruction()
	replace_beaker()
	return ..()


/obj/machinery/chem_heater/ui_requires_update(mob/user, datum/tgui/ui)
	. = ..()
	if(on && beaker)
		. = TRUE

/obj/machinery/chem_heater/ui_state(mob/user)
	return GLOB.default_state

/obj/machinery/chem_heater/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChemHeater")
		ui.open()
		ui.set_autoupdate(TRUE)

/obj/machinery/chem_heater/ui_data()
	var/data = list()
	data["targetTemp"] = target_temperature
	data["isActive"] = on
	data["isBeakerLoaded"] = beaker ? 1 : 0

	data["currentTemp"] = beaker ? beaker.reagents.chem_temp : null
	data["beakerCurrentVolume"] = beaker ? beaker.reagents.total_volume : null
	data["beakerMaxVolume"] = beaker ? beaker.volume : null

	var beakerContents[0]
	if(beaker)
		for(var/datum/reagent/R in beaker.reagents.reagent_list)
			beakerContents.Add(list(list("name" = R.name, "volume" = R.volume))) // list in a list because Byond merges the first list...
	data["beakerContents"] = beakerContents
	return data

/obj/machinery/chem_heater/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("power")
			on = !on
			. = TRUE
		if("temperature")
			var/target = text2num(params["target"])
			if(target != null)
				target_temperature = clamp(target, 0, 1000)
				. = TRUE
		if("eject")
			replace_beaker(usr)
			. = TRUE
