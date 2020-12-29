#define MOVESPEED_ID_SIZE      "SIZECODE"
#define MOVESPEED_ID_STOMP     "STEPPY"

/datum/movespeed_modifier/resized
	id = MOVESPEED_ID_SIZE
	movetypes = GROUND
	multiplicative_slowdown = 1 //it's a demo, gets set properly on the proc after the one that sets this.

/datum/movespeed_modifier/stomp
	id = MOVESPEED_ID_STOMP
	movetypes = GROUND
	multiplicative_slowdown = 10
