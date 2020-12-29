//IMPORTANT: Multiple animate() calls do not stack well, so try to do them all at once if you can.
/mob/living/carbon/update_transform()
	var/matrix/ntransform = matrix(transform) //aka transform.Copy()
	var/final_pixel_y = pixel_y
	var/final_dir = dir
	var/changed = 0

	if(lying != lying_prev && rotate_on_lying)
		changed++
		ntransform.TurnTo(lying_prev,lying)
		if(lying == 0) //Lying to standing
			final_pixel_y = get_standard_pixel_y_offset()
			if(size_multiplier >= 1) //if its bigger than normal
				ntransform.Translate(0,16 * (size_multiplier-1))
			else
				if(lying_prev == 90)
					ntransform.Translate(16 * (size_multiplier-1),16 * (size_multiplier-1))

				if(lying_prev == 270)
					ntransform.Translate(-16 * (size_multiplier-1),16 * (size_multiplier-1))

		else //if(lying != 0)
			if(lying_prev == 0) //Standing to lying
				pixel_y = get_standard_pixel_y_offset()
				final_pixel_y = get_standard_pixel_y_offset(lying)
				if(lying == 90)    //Check the angle of the sprite to offset it accordingly.
					ntransform.Translate(-16 * (size_multiplier-1),0)
					if(size_multiplier < 1) //if its smaller than normal
						ntransform.Translate(0,16 * (size_multiplier-1)) //we additionally offset the sprite downwards

				if(lying == 270) //check the angle of the sprite to offset it accordingly
					ntransform.Translate(16 * (size_multiplier-1),0)
					if(size_multiplier < 1) //if its smaller than normal
						ntransform.Translate(0,16 * (size_multiplier-1)) //we additionally offset the sprite downwards

				if(dir & (EAST|WEST)) //Facing east or west
					final_dir = pick(NORTH, SOUTH) //So you fall on your side rather than your face or ass

	if(resize != RESIZE_DEFAULT_SIZE)
		changed++
		ntransform.Scale(resize)
		resize = RESIZE_DEFAULT_SIZE

	//Apply size multiplier, thank NeverExisted for this
	if(size_multiplier != previous_size)
		changed++
		//now we offset the sprite
		//Scaling affects offset. There's probably a smarter and easier way to do this, but this way it works for sure (?)
		//Just to be clear. All this bullshit is needed because someone wanted to store the old transform matrix instead of using a new one each iteration
		//Winfre is currently doing a great job at coating my nuts in slobber while i code this
		if(!lying) //when standing. People of all sizes are affected equally
			ntransform.Translate(0,-16 * (previous_size-1))			//reset the sprite
			ntransform.Scale(size_multiplier/previous_size)			//scale the sprite accordingly.
			ntransform.Translate(0,16 * (size_multiplier-1))		//apply the new offset
		else //when lying. Macros dont get an offset, Micros do. We must also check the cases when a micro becomes a macro and viceversa
			if(previous_size <= 1 && size_multiplier <= 1) //micro stays a micro. We modify the side-offset
				ntransform.Translate(0,-16 * (previous_size-1))		//reset the sprite
				ntransform.Scale(size_multiplier/previous_size)		//scale the sprite accordingly
				ntransform.Translate(0,16 * (size_multiplier-1))	//apply the new offset

			if(previous_size <= 1 && size_multiplier > 1) //micro becomes a macro. We remove the side-offset
				ntransform.Translate(0,-16 * (previous_size-1))		//reset the sprite
				ntransform.Scale(size_multiplier/previous_size)		//scale the sprite accordingly

			if(previous_size > 1 && size_multiplier <= 1) //macro becomes a micro. We add an offset
				ntransform.Scale(size_multiplier/previous_size)		//scale the sprite accordingly.
				ntransform.Translate(0,16 * (size_multiplier-1))	//apply the new offset

			if(previous_size > 1 && size_multiplier > 1) //macro stays a macro. We just scale the sprite with no offset changes
				ntransform.Scale(size_multiplier/previous_size)		//scale the sprite accordingly


	if(changed)
		animate(src, transform = ntransform, time = 2, pixel_y = final_pixel_y, dir = final_dir, easing = EASE_IN|EASE_OUT)
		movement_type |= FLOATING  // If we were without gravity, the bouncing animation got stopped, so we make sure we restart it in next life().
