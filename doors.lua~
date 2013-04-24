doors = {}

-- Registers a door
--  name: The name of the door
--  def: a table with the folowing fields:
--    description
--    inventory_image
--    groups
--    tiles_bottom: the tiles of the bottom part of the door {front, side}
--    tiles_top: the tiles of the bottom part of the door {front, side}
--    If the following fields are not defined the default values are used
--    node_box_bottom
--    node_box_top
--    selection_box_bottom
--    selection_box_top
--    only_placer_can_open: if true only the player who placed the door can
--                          open it
function doors:register_door(name, def)
	def.groups.not_in_creative_inventory = 1
	stack_max=1
	local box = {{-0.5, -0.5, -0.5,   0.5, 0.5, -0.5+1.5/16}}
	
	if not def.node_box_bottom then
		def.node_box_bottom = box
	end
	if not def.node_box_top then
		def.node_box_top = box
	end
	if not def.selection_box_bottom then
		def.selection_box_bottom= box
	end
	if not def.selection_box_top then
		def.selection_box_top = box
	end
	
	minetest.register_craftitem(name, {
		description = def.description,
		inventory_image = def.inventory_image,
		stack_max=1,

		
		on_place = function(itemstack, placer, pointed_thing)
			
			if not pointed_thing.type == "node" then
				return itemstack
			end
			local pt = pointed_thing.above
			local pt2 = {x=pt.x, y=pt.y, z=pt.z}
			pt2.y = pt2.y+1
			if
				not minetest.registered_nodes[minetest.env:get_node(pt).name].buildable_to or
				not minetest.registered_nodes[minetest.env:get_node(pt2).name].buildable_to or
				not placer or
				not placer:is_player()
			then
				return itemstack
			end
			
			local p2 = minetest.dir_to_facedir(placer:get_look_dir())
			local pt3 = {x=pt.x, y=pt.y, z=pt.z}
			if p2 == 0 then
				pt3.x = pt3.x-1
			elseif p2 == 1 then
				pt3.z = pt3.z+1
			elseif p2 == 2 then
				pt3.x = pt3.x+1
			elseif p2 == 3 then
				pt3.z = pt3.z-1
			end
			if not string.find(minetest.env:get_node(pt3).name, name.."_b_") then
				
				minetest.env:set_node(pt, {name=name.."_b_1", param2=p2})
				minetest.env:set_node(pt2, {name=name.."_t_1", param2=p2})
				--print("place_node1")
			else
				minetest.env:set_node(pt, {name=name.."_b_2", param2=p2})
				minetest.env:set_node(pt2, {name=name.."_t_2", param2=p2})
				--print("place_node2")
			end
			if def.can_destruct ==false then
				local can_destruct = minetest.env:get_meta(pt)
				can_destruct:set_string("can_destruct",tostring(def.can_destruct))
				local can_destruct = minetest.env:get_meta(pt2)
				can_destruct:set_string("can_destruct",tostring(def.can_destruct))
			end
			if def.only_placer_can_open then
				if itemstack:to_table().metadata=="" then 
					local key_random=closed_by_key.key_gen(5,"qwertyuiopasdfghjklzxcvbnm1234567890")
					local meta = minetest.env:get_meta(pt)
					
					meta:set_string("key_required", key_random)
					meta:set_string("infotext", "door closed by key "..meta:get_string("key_required").."")
					meta = minetest.env:get_meta(pt2)
					
					meta:set_string("key_required", key_random)
					meta:set_string("infotext", "door closed by key "..meta:get_string("key_required").."")
					itemstack:replace({name="closed_by_key:key",count=1,metadata=key_random})				
				else
					local meta = minetest.env:get_meta(pt)
					meta:set_string("key_required",itemstack:to_table().metadata )
					meta:set_string("infotext", "door closed by key "..meta:get_string("key_required").."")
					meta = minetest.env:get_meta(pt2)
					meta:set_string("key_required", itemstack:to_table().metadata)
					meta:set_string("infotext", "door closed by key "..meta:get_string("key_required").."")
					itemstack:clear()					
				end
			end
			return itemstack			
		end,
	})
	
	local tt = def.tiles_top
	local tb = def.tiles_bottom

	minetest.register_node(name.."_b_1", {
		tiles = {tb[2], tb[2], tb[2], tb[2], tb[1], tb[1].."^[transformfx"},
		paramtype = "light",
		paramtype2 = "facedir",
		drop = name,
		stack_max = 1,
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = def.node_box_bottom
		},
		selection_box = {
			type = "fixed",
			fixed = def.selection_box_bottom
		},
		groups = def.groups,
		on_punch=function(pos)
			print("on punch B1 start")
			print(tostring(def.can_destruct))
			print("on punch B1 end")
		end,
		on_construct=function(pos)
			print("cosB1 start ")
			print("cosB1 end ")
		end,
		on_rightclick = function(pos, node, clicker)
			print("on rightclick B1 start")
			if closed_by_key.has_locked_chest_privilege(pos, clicker) then
				closed_by_key.on_rightclick_door(pos, 1, name.."_t_1", name.."_b_2", name.."_t_2", {1,2,3,0})
			end
			print("on rightclick B1 end")
		end,
		
		on_dig=function(pos,node,digger)
			print("on dig B1 start")			
		  	if  closed_by_key.has_locked_chest_privilege(pos,digger) then
		    		closed_by_key.on_dig_door(pos,digger)
		    		pos.y = pos.y+1
		    		closed_by_key.dig_other_door(pos, name.."_t_1")
		  	else
		    		minetest.log("action", digger:get_player_name()..
				" try to remove closed steel door at "..minetest.pos_to_string(pos))	 
		  	end		
			print("on dig b1 end")
		end,

		on_destruct=function(pos)
			print("desB1 start")
			closed_by_key.on_destruct_door(pos)
			print("desB1 end")
		end,

		after_destruct=function(pos,oldnode)
			print("aftB1start")
			closed_by_key.after_destruct_door(pos,oldnode)
			print("aftB1end")
		end,

	})
	
	minetest.register_node(name.."_t_1", {
		tiles = {tt[2], tt[2], tt[2], tt[2], tt[1], tt[1].."^[transformfx"},
		paramtype = "light",
		paramtype2 = "facedir",
		drop = name,
		stack_max = 1,
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = def.node_box_top
		},
		selection_box = {
			type = "fixed",
			fixed = def.selection_box_top
		},
		groups = def.groups,

		on_punch=function(pos)
			print("on punch T1 start")
			print(tostring(def.can_destruct))
			print("on punch T1 end")
		end,

		on_construct=function(pos)
			print("cosT1 start ")
			print("cosT1 end")
		end,		
		
		on_rightclick = function(pos, node, clicker)
			print("on rightclick T1 start")
			if closed_by_key.has_locked_chest_privilege(pos, clicker) then
				closed_by_key.on_rightclick_door(pos, -1, name.."_b_1", name.."_t_2", name.."_b_2", {1,2,3,0})
			end
			print("on rightclick T1 end")
		end,

		on_dig=function(pos,node,digger)
			print("on dig T1 start")
		  	if  closed_by_key.has_locked_chest_privilege(pos,digger) then		
		    		closed_by_key.on_dig_door(pos,digger)
		    		pos.y = pos.y-1
		    		closed_by_key.dig_other_door(pos, name.."_b_1")
		  	else
		    		minetest.log("action", digger:get_player_name()..
				" try to remove closed steel door at "..minetest.pos_to_string(pos))
		  	end
			print("on dig T1 end")
		end,

		on_destruct=function(pos)
			print("des T1 start")
			closed_by_key.on_destruct_door(pos)
			print("des T1 end")
		end,

		after_destruct=function(pos,oldnode)
			print("aft T1 start")
			closed_by_key.after_destruct_door(pos,oldnode)
			print("aft T1 end")
		end,

	})
	
	minetest.register_node(name.."_b_2", {
		tiles = {tb[2], tb[2], tb[2], tb[2], tb[1].."^[transformfx", tb[1]},
		paramtype = "light",
		paramtype2 = "facedir",
		drop = name,
		stack_max = 1,
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = def.node_box_bottom
		},
		selection_box = {
			type = "fixed",
			fixed = def.selection_box_bottom
		},
		groups = def.groups,

		on_punch=function(pos)
			print("on punch B2 start")
			print(tostring(def.can_destruct))
			print("on punch B2 end")
		end,
		
		on_construct=function(pos)
			print("cos B2 start ")
			print("cos B2 end")
		end,
		
		on_rightclick = function(pos, node, clicker)
			print("on rightclick B2 start")
			if closed_by_key.has_locked_chest_privilege(pos, clicker) then
				closed_by_key.on_rightclick_door(pos, 1, name.."_t_2", name.."_b_1", name.."_t_1", {3,0,1,2})
			end
			print("on rightclick B2 end")
		end,

		on_dig=function(pos,node,digger)
			print("on dig B2 start")
			if  closed_by_key.has_locked_chest_privilege(pos,digger) then	
		    		closed_by_key.on_dig_door(pos,digger)
		    		pos.y = pos.y+1
		    		closed_by_key.dig_other_door(pos, name.."_t_2")
		  	else
		    	minetest.log("action", digger:get_player_name()..
				" try to remove closed steel door at "..minetest.pos_to_string(pos))
		  	end
		
			print("on dig B2 end")
		end,	
		on_destruct=function(pos)
			print("des B2 start")
			closed_by_key.on_destruct_door(pos)
			print("des B2 end")
		end,
		after_destruct=function(pos,oldnode)
			print("aft B2 start")
			closed_by_key.after_destruct_door(pos,oldnode)
			print("aft B2 end")
		end,
	})
	
	minetest.register_node(name.."_t_2", {
		tiles = {tt[2], tt[2], tt[2], tt[2], tt[1].."^[transformfx", tt[1]},
		paramtype = "light",
		paramtype2 = "facedir",
		drop = name,
		drawtype = "nodebox",
		stack_max = 1,
		node_box = {
			type = "fixed",
			fixed = def.node_box_top
		},
		selection_box = {
			type = "fixed",
			fixed = def.selection_box_top
		},
		groups = def.groups,

		on_punch=function(pos)
			print("on punch T2 start")
			print(tostring(def.can_destruct))
			print("on punch T2 end")
		end,
		
		on_construct=function(pos)
			print("cos T2 start ")
			print("cos T2 end")
		end,
		
		on_rightclick = function(pos, node, clicker)
			print("on rightclick T2 start")


			if closed_by_key.has_locked_chest_privilege(pos, clicker) then
				closed_by_key.on_rightclick_door(pos, -1, name.."_b_2", name.."_t_1", name.."_b_1", {3,0,1,2})
			end
			print("on rightclick T2 end")			
		end,
		on_dig=function(pos,node,digger)
			print("on dig T2 start")
		  	if  closed_by_key.has_locked_chest_privilege(pos,digger) then
		    		closed_by_key.on_dig_door(pos,digger)
		    		pos.y = pos.y-1
		    		closed_by_key.dig_other_door(pos, 	name.."_b_2")
		  	else
		    		minetest.log("action", digger:get_player_name()..
				" try to remove closed steel door at "..minetest.pos_to_string(pos))
			end
			print("on dig T2 end")

		end,		
		on_destruct=function(pos)
			print("des T2 start")
			closed_by_key.on_destruct_door(pos)
			print("des T2 end")
		end,
		after_destruct=function(pos,oldnode)
			print("aft T2 start")
			closed_by_key.after_destruct_door(pos,oldnode)
			print("aft T2 end")
		end,
	})
	
end



doors:register_door("closed_by_key:door_steel", {
	description = "Steel Door",
	inventory_image = "door_steel.png",
	stack_max = 1,
	groups = {snappy=1,bendy=2,cracky=1,melty=2,level=2,door=1},
	tiles_bottom = {"door_steel_b.png", "door_grey.png"},
	tiles_top = {"door_steel_a.png", "door_grey.png"},
	only_placer_can_open = true,
})

doors:register_door("closed_by_key:door_mese", {
	description = "Mese Door",
	drop = "",
	inventory_image = "door_mese.png",
	stack_max = 1,
	groups = {snappy=1,bendy=2,cracky=1,melty=2,level=2,door=1},
	tiles_bottom = {"door_mese_b.png", "door_mese_side.png"},
	tiles_top = {"door_mese_a.png", "door_mese_side.png"},
	only_placer_can_open = true,
	can_destruct=false,
})
	
doors:register_door("closed_by_key:fake_door", {
	description = "Fake Door",
	inventory_image = "default_stone.png",
	stack_max = 1,
	groups = {snappy=1,bendy=2,cracky=1,melty=2,level=2,door=1},
	tiles_bottom = {"default_stone.png", "door_grey.png"},
	tiles_top = {"default_stone.png", "door_grey.png"},
	only_placer_can_open = true,
})

minetest.register_craft({
	output = "closed_by_key:door_steel",
	stack_max = 1,
	recipe = {
		{"default:steel_ingot", "default:steel_ingot"},
		{"default:steel_ingot", "default:steel_ingot"},
		{"default:steel_ingot", "default:steel_ingot"}
	}
})

-- minetest.register_alias("closed_by_key:door_wood_a_c", "closed_by_key:door_wood_t_1")
-- minetest.register_alias("closed_by_key:door_wood_a_o", "closed_by_key:door_wood_t_1")
-- minetest.register_alias("closed_by_key:door_wood_b_c", "closed_by_key:door_wood_b_1")
-- minetest.register_alias("closed_by_key:door_wood_b_o", "closed_by_key:door_wood_b_1")
 
 
