/mob/living/carbon/wendigo/attack_hulk(mob/living/carbon/human/user, does_attack_animation = FALSE)
	if(user.a_intent == INTENT_HARM)
		. = ..(user, TRUE)
		if(.)
			return
		adjustBruteLoss(15)
		var/hitverb = "punched"
		if(mob_size < MOB_SIZE_LARGE)
			step_away(src,user,15)
			sleep(1)
			step_away(src,user,15)
			hitverb = "slammed"
		playsound(loc, "punch", 25, 1, -1)
		visible_message("<span class='danger'>[user] has [hitverb] [src]!</span>", \
		"<span class='userdanger'>[user] has [hitverb] [src]!</span>", null, COMBAT_MESSAGE_RANGE)
		return 1

/mob/living/carbon/wendigo/on_attack_hand(mob/living/carbon/human/M)
	. = ..()
	if(.) //To allow surgery to return properly.
		return
	switch(M.a_intent)
		if (INTENT_HARM)
			if(M != pulling && !src.slaves.Find(M))
				var/damage = rand(1, 9)
				if (prob(90))
					playsound(loc, "punch", 25, 1, -1)
					visible_message("<span class='danger'>[M] has punched [src]!</span>", \
							"<span class='userdanger'>[M] has punched [src]!</span>", null, COMBAT_MESSAGE_RANGE)
					var/obj/item/bodypart/affecting = get_bodypart(ran_zone(M.zone_selected))
					apply_damage(damage, BRUTE, affecting)
					log_combat(M, src, "attacked")
					M.do_attack_animation(src, ATTACK_EFFECT_PUNCH)
				else
					playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
					visible_message("<span class='danger'>[M] has attempted to punch [src]!</span>", \
						"<span class='userdanger'>[M] has attempted to punch [src]!</span>", null, COMBAT_MESSAGE_RANGE)

		if (INTENT_DISARM)
			if (!lying && M != pulling && !src.slaves.Find(M))
				M.do_attack_animation(src, ATTACK_EFFECT_DISARM)
				if (prob(5))
					Unconscious(40)
					playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
					log_combat(M, src, "pushed")
					visible_message("<span class='danger'>[M] has pushed down [src]!</span>", \
						"<span class='userdanger'>[M] has pushed down [src]!</span>")
				else
					if (prob(50))
						dropItemToGround(get_active_held_item())
						playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
						visible_message("<span class='danger'>[M] has disarmed [src]!</span>", \
						"<span class='userdanger'>[M] has disarmed [src]!</span>", null, COMBAT_MESSAGE_RANGE)
					else
						playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
						visible_message("<span class='danger'>[M] has attempted to disarm [src]!</span>",\
							"<span class='userdanger'>[M] has attempted to disarm [src]!</span>", null, COMBAT_MESSAGE_RANGE)

/mob/living/carbon/wendigo/do_attack_animation(atom/A, visual_effect_icon, obj/item/used_item, no_effect)
	if(!no_effect && !visual_effect_icon)
		visual_effect_icon = ATTACK_EFFECT_CLAW
	..()

