
/datum/surgery/advanced/necrotic_revival
	name = "Necrotic Revival"
	desc = "An experimental surgical procedure that stimulates the growth of a weak Romerol tumor inside the patient's brain. Requires zombie powder or rezadone." //DONKSTATION CHANGE: surgery zombies no longer infect others
	steps = list(/datum/surgery_step/incise,
				/datum/surgery_step/retract_skin,
				/datum/surgery_step/saw,
				/datum/surgery_step/clamp_bleeders,
				/datum/surgery_step/bionecrosis,
				/datum/surgery_step/close)

	possible_locs = list(BODY_ZONE_HEAD)

/datum/surgery/advanced/necrotic_revival/can_start(mob/user, mob/living/carbon/target)
	. = ..()
	var/obj/item/organ/zombie_infection/ZI = target.getorganslot(ORGAN_SLOT_ZOMBIE)
	if(ZI)
		return FALSE

/datum/surgery_step/bionecrosis
	name = "start bionecrosis"
	implements = list(/obj/item/reagent_containers/syringe = 100, /obj/item/pen = 30)
	time = 50
	chems_needed = list(/datum/reagent/toxin/zombiepowder, /datum/reagent/medicine/rezadone)
	require_all_chems = FALSE

/datum/surgery_step/bionecrosis/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, "<span class='notice'>You begin to grow a weakened romerol tumor on [target]'s brain...</span>", //DONKSTATION CHANGE: surgery zombies no longer infect others
		"[user] begins to tinker with [target]'s brain...",
		"[user] begins to perform surgery on [target]'s brain.")

/datum/surgery_step/bionecrosis/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, "<span class='notice'>You succeed in growing a weakened romerol tumor on [target]'s brain.</span>", //DONKSTATION CHANGE: surgery zombies no longer infect others
		"[user] successfully grows a romerol tumor on [target]'s brain!",
		"[user] completes the surgery on [target]'s brain.")
	if(!target.getorganslot(ORGAN_SLOT_ZOMBIE))
		var/obj/item/organ/zombie_infection/non_infectious/ZI = new() //DONKSTATION CHANGE: surgery zombies no longer infect others
		ZI.Insert(target)
	return TRUE

