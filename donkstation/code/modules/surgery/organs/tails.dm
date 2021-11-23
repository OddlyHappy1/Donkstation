/obj/item/organ/tail/teshari
	name = "teshari tail"
	desc = "A severed teshari tail. Somewhere, no doubt, a teshari hater is very pleased with themselves."
	icon_state = "tesharitail"
	var/teshari_tailfeather = "None"

/obj/item/organ/tail/teshari/Insert(mob/living/carbon/human/H, special = 0, drop_if_replaced = TRUE)
	..()
	if(istype(H))
		// Checks here are necessary so it wouldn't overwrite the tail of a lizard it spawned in
		if(!("teshari_tail" in H.dna.species.mutant_bodyparts))
			H.dna.features["teshari_tail"] = tail_type
			H.dna.species.mutant_bodyparts |= "teshari_tail"

		if(!("teshari_tailfeather" in H.dna.species.mutant_bodyparts))
			H.dna.features["teshari_tailfeather"] = teshari_tailfeather
			H.dna.species.mutant_bodyparts |= "teshari_tailfeather"
		H.update_body()

/obj/item/organ/tail/teshari/Remove(mob/living/carbon/human/H,  special = 0)
	..()
	if(istype(H))
		H.dna.species.mutant_bodyparts -= "teshari_tail"
		H.dna.species.mutant_bodyparts -= "teshari_tailfeather"
		color = "#" + H.dna.features["mcolor"]
		tail_type = H.dna.features["teshari_tail"]
		teshari_tailfeather = H.dna.features["teshari_tailfeather"]
		H.update_body()
