/mob/living/silicon/robot/proc/objectivesupdate()
	var/mob/living/silicon/ai/AI
	busystatus = 1
	playsound(loc, 'sound/machines/chime.ogg', 25, 0)
	to_chat(usr, "<span class='notice'>A.I Assigned Objective Updated. [AI.objectivesconfirm] Priority objective recieved as follows: [AI.objectiveupdate] </span>") //Objectives Updated, standby for Emergency Procedures. BEEEEP, BEEEP

/mob/living/silicon/robot/verb/togglebusy()
	set category = "Robot Commands"
	set name = "Toggle Flag"
	set desc = "Toggle your busy flag off/online to indicate your status to your A.I"
	busystatus = !busystatus
	playsound(loc, 'sound/machines/ding.ogg', 25)
	to_chat(usr, "<span class='notice'>Flag Toggled [busystatus ? "Offline, unavailable for lowpriority tasking." : "Online, ready for assignment."]</span>")

/mob/living/silicon/robot/verb/setobjective()
	set category = "Robot Commands"
	set name = "Set Current Objective"
	set desc = "Set your current objective, will display to your A.I"
	switch(alert("Are you sure you want to set a custom A.I Objective? This will override your previous task.", "Confirm", "Yes", "No"))
		if("Yes")
			for(var/mob/living/silicon/ai/AI in GLOB.alive_mob_list)
				AI.objectiveupdate = input(src, "What is your current objective, this will be displayed to your A.I.","Update Objective")
				busystatus = 1
				to_chat(usr, "<span class='notice'>A.I Assigned Objective Updated. Objective set as follows: [AI.objectiveupdate] </span>")
