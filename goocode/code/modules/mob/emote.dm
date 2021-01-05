/datum/emote/living/reh
	key = "reh"
	key_third_person = "rehs"
	message = "lets out a delgreh."
	emote_type = EMOTE_AUDIBLE
	muzzle_ignore = FALSE
	restraint_check = FALSE
	mob_type_allowed_typecache = list(/mob/living/carbon, /mob/living/silicon/pai)
	
/datum/emote/living/reh/run_emote(mob/living/user, params)
	if(!(. = ..()))
		return
	if(user.nextsoundemote >= world.time)
		return
	user.nextsoundemote = world.time + 3
	playsound(user, 'goostation/sound/voice/reh.ogg', 50, 1, -1)
