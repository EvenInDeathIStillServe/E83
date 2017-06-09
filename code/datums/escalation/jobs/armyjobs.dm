//A specific job within a faction. This parent should never be used, only children of it.
/datum/army_job
	var/name = "Base job (never see this)"
	var/english_name = "Put english name here"
	var/job_tag = "parent"
	var/enabled = 0 //To disallow this parent from lists, or disable a job, set this 0.
	var/faction_tag = "parent" //The tag of the faction this job is a part of ("bund", "clsa"), for lookups
	var/current_num = 0 //How many players in game currently have this job (do not set manually)
	var/list/outfits = list() //The outfit this job spawns with. Uses the "OUTFIT_JOB_NAME()" field. Is a list for randomizing
	var/outfit_variant_chance = 0  //Odds of getting an outfit that's not the first one in the list
	var/rank_prefix = "PFC" //Text shown before people's names
	var/rank_number = 0 //Determines who is above and below this rank, 0 is leader
	var/position = "team" //"team" "squad" "fireteam". Determines where this job is sorted.
	var/amount = 1 //How many of this are in each team, squad, or fireteam. -1 is infinite (expanding)
//	var/num_per_squad = 1

/datum/army_job/proc/remove_mob(var/datum/fireteam/F, var/datum/army_faction/A, var/mob/new_player/mob)
	var/i = 0
	if(position == "team" && A)
		for(var/M in A.slots)
			i++
			if(M == mob)
				A.slots[i] = src
				break
	else if(position == "fireteam" && F)
		for(var/M in F.slots)
			i++
			if(M == mob)
				F.slots[i] = src
				break

	mob.fireteam_picked = null
	mob.team_picked = null
	return