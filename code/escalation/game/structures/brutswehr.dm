/obj/structure/brutswehr
	name = "brustwehr"
	desc = "Land structure to cover your ass!" //change this stupid description
	//icon = 'icons/obj/structures.dmi'
	icon_state = "brutswer"
	density = 1
	throwpass = 0//we can throw grenades despite its density
	anchored = 1
	flags = OBJ_CLIMBABLE
	var/basic_chance = 20

/obj/structure/brutswehr/New()
	..()
	flags |= ON_BORDER
	set_dir(dir)

/obj/structure/brutswehr/Destroy()
	basic_chance = null
	..()

/obj/structure/brutswehr/set_dir(direction)
	dir = direction

/obj/structure/brutswehr/attackby(var/obj/item/I, mob/user)
	if(istype(I,/obj/item/weapon/saperka))
		to_chat(user, "<span class='notice'>Digging [name]...</span>")
		if(do_after(user, 15, src) && in_range(user, src))
			new /obj/item/weapon/ore/glass(user.loc)
			src.Destroy()

/obj/structure/brutswehr/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover, /obj/item/projectile))
		var/obj/item/projectile/proj = mover

		if(proj.firer && Adjacent(proj.firer))
			return 1

		if (get_dist(proj.starting, loc) <= 1)//allows to fire from 1 tile away of sandbag
			return 1

		return check_cover(mover, target)

	if(istype(mover, /obj/item/weapon/grenade))
		if(get_dir(loc, target) == dir)
			return !density
		else
			return 1

	return !density

//checks if projectile 'P' from turf 'from' can hit whatever is behind the table. Returns 1 if it can, 0 if bullet stops.
/obj/structure/brutswehr/proc/check_cover(obj/item/projectile/P, turf/from)
	var/turf/cover = get_turf(src)
	var/chance = basic_chance

	if(!cover)
		return 1

	for(var/mob/living/carbon/human/H in view(src, 2))//if there are mob somewhere near in range of 1 tile
		chance = initial(chance) + 10

	if(prob(chance))
		visible_message("<span class='warning'>[P] hits \the [src]!</span>")
		return 0

	return 1

/obj/structure/brutswehr/MouseDrop_T(obj/O as obj, mob/user as mob)
	..()
	if ((!( istype(O, /obj/item/weapon) ) || user.get_active_hand() != O))
		return
	if(isrobot(user))
		return
	//user.drop_item()
	if (O.loc != user.loc)
		to_chat(user, "you start climbing onto [O]...")
		step(O, get_dir(O, src))
	return

/obj/structure/brutswehr/ex_act(severity)
	switch(severity)
		if(1.0)
			new /obj/item/weapon/ore/glass(src.loc)
			qdel(src)
			return
		if(2.0)
			new /obj/item/weapon/ore/glass(src)
			new /obj/item/weapon/ore/glass(src)
			qdel(src)
			return
		else
	return

/obj/item/weapon/ore/glass/proc/check4struct(mob/user as mob)
	if((locate(/obj/structure/chezh_hangehog) || \
		locate(/obj/structure/brutswehr) || \
		locate(/obj/structure/sandbag) || \
		locate(/obj/structure/sandbag/concrete_block)) in user.loc.contents \
		)
		to_chat(user, "\red There is no more space.")
		return 0
	return 1

/obj/item/weapon/ore/glass/attack_self(mob/user as mob)
	if(!isturf(user.loc))
		to_chat(user, "\red Haha. Nice try.")
		return

	if(!check4struct(user))
		return

	var/obj/structure/brutswehr/B = new(user.loc)
	B.set_dir(user.dir)
	user.drop_item()
	qdel(src)
