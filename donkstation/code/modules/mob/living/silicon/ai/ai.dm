/mob/living/silicon/ai/proc/borgmanagement() //Shamelessly Stolen from Botcall()
	set category = "AI Commands"
	set name = "Access Cyborg Management"
	set desc = "Provide Pathing, Remote Communiques, and other data on linked synthetics."
	if(incapacitated())
		return
	if(control_disabled)
		to_chat(src, "<span class='warning'>Wireless control is disabled.</span>")
		return
	var/turf/ai_current_turf = get_turf(src)
	var/ai_Zlevel = ai_current_turf.get_virtual_z_level()
	var/c
	c += "<A HREF=?src=[REF(src)];cyborgrefresh=1>Query network status</A><br>"
	c += "<table width='100%'><tr><td width='40%'><h3>Name</h3></td><td width='30%'><h3>Status</h3></td><td width='30%'><h3>Location</h3></td><td width='10%'><h3>Control</h3></td></tr>"

	for(var/mob/living/silicon/robot/G in connected_robots)
		if(G.get_virtual_z_level() == ai_Zlevel && !G.emagged) //Only non-emagged Cyborgs on the same Z-level are detected!
			c += "<tr><td width='30%'>Designation: [G.name]</A> (Module: [G.designation])</td>"
			c += "<td width='30%'>Integrity: [G.health]% <BR>Flagged as: [G.busystatus ? "Occupied" : "Unoccupied"]	<BR>Current Objective: [objectiveupdate]</td>"
			c += "<td width='30%'>Location: [get_area_name(G, TRUE)]</td>" //Where is BORGIE????
			c += "<td width='30%'>Cell: [G.cell ? "[G.cell.charge]/[G.cell.maxcharge]" : "Empty"]</td>"
			c += "<td width='15%'><A HREF=?src=[REF(src)];cyborgmessage=[REF(G)]>Private Message</A></td>"
			c += "<td width='15%'><A HREF=?src=[REF(src)];objectivemanage=[REF(G)]>Update Objective</A></td>"
			c += "</tr>"
			c = format_text(c)

	var/datum/browser/popup = new(src, "cyborgmanagement", "Remote Cyborg Management", 700, 400)
	popup.set_content(c)
	popup.open()
