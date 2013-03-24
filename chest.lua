minetest.register_craftitem("closed_by_key:key", {--define key
	description = "key",
	inventory_image = "key.png",
	stack_max = 1,	
}) 
	
minetest.register_craftitem("closed_by_key:empty_keyring", {	--def empty keyring
	description = "empty keyring",
	inventory_image = "empty_keyring.png",
	stack_max = 99,
})
	
minetest.register_craftitem("closed_by_key:full_keyring", {	--def full keyring
	description = "full_keyring",
	inventory_image = "full_keyring.png",
	stack_max = 1,

})
	

    
minetest.register_node("closed_by_key:chest", {	--define a closed by key chest
	description = "closed_by_key",
	tiles = {"closed_by_key_side.png", "closed_by_key_side.png", "closed_by_key_side.png",
					"closed_by_key_side.png", "closed_by_key_side.png", "closed_by_key_front.png"},
	is_ground_content = true,
	groups = {cracky=1},
	drop = "",
	legacy_mineral = true,
	stack_max = 1,
	paramtype2 = "facedir",
	legacy_facedir_simple=true,
	pointable=true,
		
	after_place_node = function(pos,placer,itemstack)--assign a code & create a unique key
	  return closed_by_key.after_place_chest(pos,placer,itemstack)
	end,

	on_dig=function(pos,node,digger)
	  return closed_by_key.on_dig_chest(pos,node,digger)
	end,	  

	on_rightclick=function(pos,node,clicker) --chek if clicker have permission  
	  return closed_by_key.on_rightclick_chest(pos,node,clicker)
	end,	    
	    
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff in closed chest at "..minetest.pos_to_string(pos))
	end,	    
	on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff to closed chest at "..minetest.pos_to_string(pos))
	end,	    
	on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" takes stuff from closed chest at "..minetest.pos_to_string(pos))
	end,
--uncomment to enable sensitivity to explosions (experimental)
	on_destruct=function(pos)
		return closed_by_key.on_destruct_destructable(pos,50)
	end,
-- 
-- 	on_blast=function(pos,intensity)
-- 		print("on:blast")
-- 	end,
})

minetest.register_node("closed_by_key:mese_chest", {	--define a closed by key chest
	description = "disguised_chest",
	tiles = {"default_mese.png"},
	is_ground_content = true,
	groups = {cracky=1},
	drop = "",
	legacy_mineral = true,
	stack_max = 1,
	paramtype2 = "facedir",
	legacy_facedir_simple=true,
	pointable=true,
		
	after_place_node = function(pos,placer,itemstack)--assign a code & create a unique key
	  return closed_by_key.after_place_chest(pos,placer,itemstack)
	end,

	on_dig=function(pos,node,digger)
	  return closed_by_key.on_dig_chest(pos,node,digger)
	end,	  

	on_rightclick=function(pos,node,clicker) --chek if clicker have permission  
	  return closed_by_key.on_rightclick_chest(pos,node,clicker)
	end,	    
	    
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff in closed chest at "..minetest.pos_to_string(pos))
	end,	    
	on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff to closed chest at "..minetest.pos_to_string(pos))
	end,	    
	on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" takes stuff from closed chest at "..minetest.pos_to_string(pos))
	end,	
      
	on_destruct=function(pos)
	  return closed_by_key.on_blast_undestructable(pos)
	end,

	after_destruct=function(pos,oldnode)
	  return closed_by_key.after_blast_undestructable(pos,oldnode)
	end,
      
})
	
minetest.register_node("closed_by_key:disguised_chest", {	--define a closed by key chest
	description = "disguised_chest",
	tiles = {"default_stone.png","default_stone.png","default_stone.png","default_stone.png","default_stone.png","default_stone.png"},
	is_ground_content = true,
	groups = {cracky=1},
	drop = "closed_by_key:disguised_chest",
	legacy_mineral = true,
	stack_max = 1,
	paramtype2 = "facedir",
	legacy_facedir_simple=true,
	pointable=true,
		
	after_place_node = function(pos,placer,itemstack)--assign a code & create a unique key
	  return closed_by_key.after_place_chest(pos,placer,itemstack)
	end,

	on_dig=function(pos,node,digger)
	  return closed_by_key.on_dig_chest(pos,node,digger)
	end,	  

	on_rightclick=function(pos,node,clicker) --chek if clicker have permission  
	  return closed_by_key.on_rightclick_chest(pos,node,clicker)
	end,	    
	    
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff in closed chest at "..minetest.pos_to_string(pos))
	end,	    
	on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff to closed chest at "..minetest.pos_to_string(pos))
	end,	    
	on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" takes stuff from closed chest at "..minetest.pos_to_string(pos))
	end,	
	on_destruct=function(pos)
		return closed_by_key.on_destruct_destructable(pos,0)
	end,
})
	
minetest.register_node("closed_by_key:key_manager", {	--def a keymanager
	description = "key manager",
	tiles = {"key_manager.png"},
	is_ground_content = true,
	groups = {cracky=1},
	drop = 'closed_by_key:key_manager',
	legacy_mineral = true,
	stack_max = 99,
	paramtype2 = "facedir",
	legacy_facedir_simple=true,
	
	on_construct=function(pos)
		local meta=minetest.env:get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("main", 8*4)
		inv:set_size("slot", 1*1)
		meta:set_string("formspec",		  
			"size[12,9]"..
			"list[current_name;main;0,0;8,4;]"..
			"list[current_name;slot;2,4;1,1;]"..
			"list[current_player;main;0,5;8,4;]"..
			"button[0,4;2,1;make;make]"..
			"button[6,4;2,1;copy;copy]"..
			"button[3,4;2,1;unmake;unmake]")		
	end,
	
	
	on_receive_fields=function(pos,formname,fields,sender)	 --call necessary function 
		if fields.make== "make" then
			meta=minetest.env:get_meta(pos)
			closed_by_key.make(meta)
			minetest.log("action", sender:get_player_name()..
				" merge multiple key in a keyring "..minetest.pos_to_string(pos))
		end	  
		if fields.unmake== "unmake" then
			meta=minetest.env:get_meta(pos)
			closed_by_key.unmake(meta)
					minetest.log("action", sender:get_player_name()..
				" disassemble a keyring "..minetest.pos_to_string(pos))
		end
		if fields.copy== "copy" then
			meta=minetest.env:get_meta(pos)
			closed_by_key.copy(meta)
			minetest.log("action", sender:get_player_name()..
				" copy a key/keyring at "..minetest.pos_to_string(pos))
		end
	end,
	
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
			minetest.log("action", player:get_player_name()..
					" moves stuff in locked chest at "..minetest.pos_to_string(pos))		
	end,	    
	on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff to locked chest at "..minetest.pos_to_string(pos))
	end,
	on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" takes stuff from locked chest at "..minetest.pos_to_string(pos))
	end,
})
--def craft
minetest.register_craft({
	inventory_image='locked_chest_front.png',
	stack_max =1,
	output = 'closed_by_key:chest',
	recipe = {
		{'default:steel_ingot'},
		{'default:chest',},		
	}	
})

minetest.register_craft({
	inventory_image='empty_keyring.png',
	stack_max =99,
	output = 'closed_by_key:empty_keyring',
	recipe = {
		{'default:dry_shrub','','default:dry_shrub'},
		{'','default:dry_shrub',''},
		{'default:dry_shrub','','default:dry_shrub'},
	}	
})

minetest.register_craft({
	inventory_image='key_manager.png',
	stack_max =99,
	output = 'closed_by_key:key_manager',
	recipe = {
		{'','default:mese',''},
		{'','default:chest',''},
	}	
})
minetest.register_craft({
	type="cooking",
	inventory_image='steel_ingot.png',
	output = 'default:steel_ingot',
	recipe = 'closed_by_key:key',
		
})

minetest.log("action", "[MOD]"..minetest.get_current_modname().." -- loaded from "..minetest.get_modpath(minetest.get_current_modname()))
