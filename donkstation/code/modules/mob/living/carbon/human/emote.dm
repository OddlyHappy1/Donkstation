/datum/emote/living/carbon/human/laugh
	key = "laugh"
	key_third_person = "laughs"
	message = "laughs"
	message_mime = "laughs silently"
	emote_type = EMOTE_AUDIBLE
	vary = TRUE

/datum/emote/living/carbon/human/laugh/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		return !C.silent

/datum/emote/living/carbon/human/laugh/get_sound(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.mind?.miming)
		return
	if(ishumanbasic(H) || iscatperson(H))
		if(user.gender == FEMALE)
			return 'sound/voice/human/womanlaugh.ogg'
		else
			return pick('sound/voice/human/manlaugh1.ogg', 'sound/voice/human/manlaugh2.ogg')
	else if(ismoth(H))
		return 'sound/voice/moth/laugh_moth.ogg'
	else if (islizard(H))
		return 'sound/voice/lizard/lizard_laugh.ogg'
	else if (isipc(H))
		return 'sound/voice/ipc/robot_laugh.ogg'
	else if (isteshari(H)) //DONKSTATION CHANGE: ADDED TESHARI
		return 'sound/voice/teshari/teshari_laugh.ogg'
	else if (isskeleton(H) || isplasmaman(H))
		return 'sound/voice/skeleton/skeleton_laugh.ogg'
	else if (isflyperson(H) || isapid(H))
		return 'sound/voice/fly/fly_buzz.ogg'
	else if (ispodperson(H) || isabductor(H))
		return 'sound/voice/abductor/allen_laugh.ogg'
	else if (isoozeling(H) || isslimeperson(H) || isjellyperson(H))
		return 'sound/voice/ooze/ooze_laugh.ogg'
	else if (isethereal(H))
		return pick('sound/voice/ethereal/ethereal_laugh.ogg', 'sound/voice/ethereal/ethereal_laugh2.ogg')
	else if (issquidperson(H))
		return 'sound/voice/squid/squid_laugh.ogg'
