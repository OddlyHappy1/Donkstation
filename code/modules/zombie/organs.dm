/obj/item/organ/zombie_infection
	name = "festering ooze"
	desc = "A black web of pus and viscera."
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_ZOMBIE
	icon_state = "blacktumor"
	var/causes_damage = TRUE
	var/datum/species/old_species = /datum/species/human
	var/living_transformation_time = 30
	var/converts_living = FALSE
	var/infectious_variant = TRUE //DONKSTATION CHANGE: viro/surgery zombies no longer infect others

	var/revive_time_min = 450
	var/revive_time_max = 700
	var/timer_id

/obj/item/organ/zombie_infection/Initialize()
	. = ..()
	if(iscarbon(loc))
		Insert(loc)
	GLOB.zombie_infection_list += src

/obj/item/organ/zombie_infection/Destroy()
	GLOB.zombie_infection_list -= src
	. = ..()

/obj/item/organ/zombie_infection/Insert(var/mob/living/carbon/M, special = 0)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/organ/zombie_infection/Remove(mob/living/carbon/M, special = 0)
	. = ..()
	STOP_PROCESSING(SSobj, src)
	if(iszombie(M) && old_species && !QDELETED(M))
		M.set_species(old_species)
	if(timer_id)
		deltimer(timer_id)

/obj/item/organ/zombie_infection/on_find(mob/living/finder)
	to_chat(finder, "<span class='warning'>Inside the head is a disgusting black \
		web of pus and viscera, bound tightly around the brain like some \
		biological harness.</span>")

/obj/item/organ/zombie_infection/process(delta_time)
	if(!owner)
		return
	if(owner.IsInStasis())
		return
	if(!(src in owner.internal_organs))
		Remove(owner)
	if (causes_damage && !iszombie(owner) && owner.stat != DEAD)
		owner.adjustToxLoss(0.5 * delta_time)
		if(DT_PROB(5, delta_time))
			to_chat(owner, "<span class='danger'>You feel sick...</span>")
	if(timer_id)
		return
	if(owner.suiciding)
		return
	if(owner.stat != DEAD && !converts_living)
		return
	if(!owner.getorgan(/obj/item/organ/brain))
		return
	if(!iszombie(owner))
		to_chat(owner, "<span class='cultlarge'>You can feel your heart stopping, but something isn't right... \
		life has not abandoned your broken form. You can only feel a deep and immutable hunger that \
		not even death can stop, you will rise again!</span>")
	var/revive_time = rand(revive_time_min, revive_time_max)
	var/flags = TIMER_STOPPABLE
	timer_id = addtimer(CALLBACK(src, .proc/zombify), revive_time, flags)

/obj/item/organ/zombie_infection/proc/zombify()
	timer_id = null

	if(!converts_living && owner.stat != DEAD)
		return

	if(!iszombie(owner))
		old_species = owner.dna.species.type
		if(src.infectious_variant) //DONKSTATION CHANGE: surgery/viro zombies no longer infect others
			owner.set_species(/datum/species/zombie/infectious)
		else
			owner.set_species(/datum/species/zombie/infectious/non_infectious)

	var/stand_up = (owner.stat == DEAD) || (owner.stat == UNCONSCIOUS)

	//Fully heal the zombie's damage the first time they rise
	owner.setToxLoss(0, 0)
	owner.setOxyLoss(0, 0)
	owner.heal_overall_damage(INFINITY, INFINITY, INFINITY, null, TRUE)

	//if(!owner.revive())
	//	return

	owner.grab_ghost()
	owner.visible_message("<span class='danger'>[owner] suddenly convulses, as [owner.p_they()][stand_up ? " stagger to [owner.p_their()] feet and" : ""] gain a ravenous hunger in [owner.p_their()] eyes!</span>", "<span class='alien'>You HUNGER!</span>")
	playsound(owner.loc, 'sound/hallucinations/far_noise.ogg', 50, 1)
	owner.do_jitter_animation(living_transformation_time)
	owner.revive()
	if(src.infectious_variant) //DONKSTATION CHANGE: surgery/viro zombies no longer infect others
		var/datum/browser/popup = new(owner, "antagTips", null, 600, 400)
		to_chat(owner, "<span class='alertalien'>You are now a zombie! Do not seek to be cured, do not help any non-zombies in any way, do not harm your zombie brethren and spread the disease by killing others. You are a creature of hunger and violence.</span>")
		popup.set_window_options("titlebar=1;can_minimize=0;can_resize=0")
		popup.set_content(replacetext(rustg_file_read("html/antagtips/romerol_zombie.html"), regex("\\w*.png", "gm"), /datum/antagonist/proc/get_asset_url_from))
		popup.open(FALSE)
	else
		var/datum/browser/popup = new(owner, "antagTips", null, 600, 400)
		to_chat(owner, "<span class='alertalien'>You are now a zombie! You are NOT an antagonist, but do not harm your zombie brethren!</span>")
		popup.set_window_options("titlebar=1;can_minimize=0;can_resize=0")
		popup.set_content(replacetext(rustg_file_read("html/antagtips/romerol_zombie_nonantag.html"), regex("\\w*.png", "gm"), /datum/antagonist/proc/get_asset_url_from))
		popup.open(FALSE)

/obj/item/organ/zombie_infection/nodamage
	causes_damage = FALSE
