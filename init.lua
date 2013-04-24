--[[

closed by key v0.5

Copyright (c) 2013 pandaro <padarogames@gmail.com>

Source Code:
License: GPLv3
pictures:WTFPL
contributor:0gb.us(chest start code) & PilzAdam(start door code) 



KEY
and
KEYRING	
and
KEY-MANAGER.
CLOSED CHEST and
CLOSED DOOR


]]--

-- expose api
closed_by_key={}
closed_by_key.block={}
closed_by_key.door={}
dofile(minetest.get_modpath("closed_by_key").."/chest.lua")
dofile(minetest.get_modpath("closed_by_key").."/doors.lua")


closed_by_key.after_place_chest=function(pos,placer,itemstack)
  local meta=minetest.env:get_meta(pos)
  local metastack=itemstack:to_table().metadata
  local inv = meta:get_inventory()
  inv:set_size("main", 8*4)
  if metastack=="" then
    local key_random=closed_by_key.key_gen(5,"qwertyuiopasdfghjklzxcvbnm1234567890")
    meta:set_string("key_required",key_random)
    inv:set_stack("main",1,{name="closed_by_key:key",metadata=key_random})
    itemstack:clear()
  else
    meta:set_string("key_required",metastack)
    itemstack:clear()
    minetest.log("action", placer:get_player_name()..
		  " place closed chest at "..minetest.pos_to_string(pos))
  end
end

closed_by_key.on_dig_chest=function(pos,node,digger)
  --print(dump(node.name))
  local meta=minetest.env:get_meta(pos)
  local inv=meta:get_inventory()
  if  inv:is_empty("main")==false then
    minetest.log("action", digger:get_player_name()..
			" try to remove not empty closed chest at "..minetest.pos_to_string(pos))
    return
  end
  local meta=minetest.env:get_meta(pos)
  local code=meta:get_string("key_required")
  minetest.env:remove_node(pos)
  minetest.log("action", digger:get_player_name()..
		" remove closed chest at "..minetest.pos_to_string(pos))
  local inv=digger:get_inventory()
  inv:add_item("main",{name="closed_by_key:chest",metadata=code})
end

closed_by_key.on_rightclick_chest=function(pos,node,clicker)
  local strpos=minetest.pos_to_string(pos)
  local meta=minetest.env:get_meta(pos)
  if closed_by_key.has_locked_chest_privilege(pos,clicker) then--if has privilege show formspec
	  minetest.show_formspec(clicker:get_player_name(), "closed_by_key:chest","size[9,10]".. 
			  "label[0,0;chest "..meta:get_string("key_required").."]"..
			  "list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";main;0,1;8,4;]"..				
			  "list[current_player;main;0,6;8,4;]")
  else--else not
	  meta:set_string("infotext", "closed chest ")
  end
end

closed_by_key.on_destruct_destructable=function(pos,percent)
	local meta=minetest.env:get_meta(pos)
	local inv=meta:get_inventory()
	local main=inv:get_list("main")
	for i,v in ipairs(main) do
		if v:to_table() ~= nil then
			obj=minetest.env:add_item(pos,{wear=v:get_wear(),name=v:get_name(),count=math.random(0+(((v:get_count())/100)*percent),v:get_count()),metadata=v:get_metadata()})
			inv:set_stack("main",i,{})
			if obj == nil then
				return
			end
			obj:get_luaentity().collect = true
			obj:setacceleration({x=0, y=-10, z=0})
			obj:setvelocity({x=math.random(0,6)-3, y=10, z=math.random(0,6)-3})
		end
	end
end

closed_by_key.on_blast_undestructable=function(pos)
  --print("ciao")
  local meta=minetest.env:get_meta(pos)
  local inv=meta:get_inventory() 
  local list=inv:get_list("main")
  closed_by_key.block[minetest.pos_to_string(pos)]={meta:get_string("key_required"),list}
  --print("riciao")
end

closed_by_key.after_blast_undestructable=function(pos,oldnode)
  local meta= minetest.env:get_meta(pos)
  minetest.env:set_node(pos,oldnode)
  meta:set_string("key_required",closed_by_key.block[minetest.pos_to_string(pos)][1])
  local inv = meta:get_inventory()
  inv:set_size("main", 8*4)
  inv:set_list("main",closed_by_key.block[minetest.pos_to_string(pos)][2])
  closed_by_key.block[minetest.pos_to_string(pos)]=nil
end



closed_by_key.has_locked_chest_privilege=function(pos, player)--check privilege function:search key or keyring in chest or player inv 
	local meta=minetest.env:get_meta(pos)
	local player_inv = player:get_inventory()
	local player_list= player_inv:get_list("main")
	local chest_inv= meta:get_inventory()
	local chest_list= chest_inv:get_list("main")
	local key_required=meta:get_string("key_required")
	if chest_inv:contains_item("main",{name="closed_by_key:key"})==false and player_inv:contains_item("main",{name="closed_by_key:key"})== false and chest_inv :contains_item("main",{name="closed_by_key:full_keyring"})==false and player_inv :contains_item("main",{name="closed_by_key:full_keyring"})==false then
		return false
	end
	if chest_inv :contains_item("main",{name="closed_by_key:full_keyring"})==true then
		for i,v in ipairs (chest_list) do
			if v:get_name() =="closed_by_key:full_keyring" then
				local keychain = v:get_metadata():split("*")
				for ii,vv in ipairs (keychain) do
					if vv==key_required then
						return true		    
					end
				end
			end
		end
	end
	if player_inv :contains_item("main",{name="closed_by_key:full_keyring"})==true then
		for i,v in ipairs (player_list) do
			if v:get_name() =="closed_by_key:full_keyring" then
				local keychain = v:get_metadata():split("*")
				for ii,vv in ipairs (keychain) do
					if vv==key_required then
						return true		    
					end
				end
			end
		end
	end
	if chest_inv:contains_item("main",{name="closed_by_key:key"})==true then
		for i,v in ipairs (chest_list) do
			if v:get_name() =="closed_by_key:key"then
				if v:get_metadata()==meta:get_string("key_required") then
					return true
				end
			end
		end
	end
	if player_inv:contains_item("main",{name="closed_by_key:key"})==true then
		for i,v in ipairs (player_list) do
			if v:get_name() =="closed_by_key:key"then
				if v:get_metadata()==meta:get_string("key_required") then
					return true
				end
			end
		end
	end
	return false	
end
	
closed_by_key.make=function(meta)--merge many kay in a keyring
	local inv=meta:get_inventory()
	local main =inv:get_list("main")
	local slot=inv:get_stack("slot",1)--place for keyring
	local keychain=""
	if slot:get_name()=="closed_by_key:empty_keyring" and slot:get_count()==1  then
		if inv:contains_item("main",{name="closed_by_key:key"}) ==true then      
			for i,v in ipairs (main) do
				if v:get_name()=="closed_by_key:key" then		
					keychain=(tostring(keychain).."*"..(tostring(v:get_metadata())))
					inv:set_stack("main",i,{})	  
				end
			end
			inv:set_stack("slot",1,{name="closed_by_key:full_keyring",count=1,metadata=keychain})
		end
	end  
end 

closed_by_key.unmake=function(meta)--disassemble a keyring
	local inv=meta:get_inventory()
	local slot=inv:get_stack("slot",1)  
	local main =inv:get_list("main")
	if slot:get_name()=="closed_by_key:full_keyring"then
		local keychain = slot:get_metadata():split("*")
		local count = table.getn(keychain)
		local empty=0
		for i,v in ipairs (main) do
			if v:get_count()<=0 then
				empty=empty+1
				if empty >= count then
					empty= true
					break
				end
			end
		end    
		if empty==true then      
			for i,v in ipairs (keychain) do
				inv:add_item("main",{name="closed_by_key:key",metadata=v})
			end
			inv:set_stack("slot",1,{name="closed_by_key:empty_keyring"})      
		end    
	end  
end

closed_by_key.copy=function(meta)--copy a key or a keyring
	local inv=meta:get_inventory()
	local keyslot=inv:get_stack("slot",1)  
	local main=inv:get_list("main")
	local keycode=(keyslot:get_metadata())
	if keyslot:get_name()=="closed_by_key:key" then
		if inv:contains_item("main",{name="steel_ingot"}) then
			if inv:room_for_item("main",{name="closed_by_key:key"})== true then
				inv:add_item("main",{name="closed_by_key:key",metadata=keycode})
				inv:remove_item("main",{name="steel_ingot"})	
			end
		end
	elseif keyslot:get_name()=="closed_by_key:full_keyring" then
		if inv:contains_item("main",{name="closed_by_key:empty_keyring"}) then
			local keys = keycode:split("*")
			local count=table.getn(keys)
			if inv:contains_item("main",{name="steel_ingot",count=count}) then		--need many steel
				if inv:room_for_item("main",{name="closed_by_key:empty_keyring"}) then
					inv:remove_item("main",{name="closed_by_key:empty_keyring"})
					inv:add_item("main",{name="closed_by_key:full_keyring",metadata=keycode})
					inv:remove_item("main",{name="steel_ingot",count=count})	  
				end
			end
		end
	end
end	






closed_by_key.on_dig_door=function(pos,digger)--dig the door
	local meta=minetest.env:get_meta(pos)
	local code=meta:get_string("key_required")
	local can_destruct=meta:set_string("can_destruct", "true")
	local inv=digger:get_inventory()
	minetest.env:remove_node(pos)
	minetest.log("action", digger:get_player_name()..
		    " remove closed steel door at "..minetest.pos_to_string(pos))		    
	inv:add_item("main",{name="closed_by_key:door_mese",metadata=code})
	local can_destruct=meta:set_string("can_destruct", "false")
end

closed_by_key.dig_other_door=function (pos, name)--dig the other node that make the door(copy from PilzAdam door) 
	if minetest.env:get_node(pos).name == name then
		local meta=minetest.env:get_meta(pos)
		local can_destruct=meta:set_string("can_destruct", "true")
		minetest.env:remove_node(pos)
		local can_destruct=meta:set_string("can_destruct", "false")
		
	end
end

closed_by_key.on_rightclick_door=function(pos, dir, check_name, replace, replace_dir, params)--open the door(copy from PilzAdam door
	print("rightclick door start dir= " ..tostring(dir))
	pos.y = pos.y+dir
	if not minetest.env:get_node(pos).name == check_name then
		return
	end
	local p2 = minetest.env:get_node(pos).param2
	p2 = params[p2+1]

	local meta = minetest.env:get_meta(pos):to_table()
	local beta =minetest.env:get_meta(pos)
	local can_destruct=beta:set_string("can_destruct", "true")
	minetest.env:set_node(pos, {name=replace_dir, param2=p2})
	minetest.env:get_meta(pos):from_table(meta)
	local can_destruct=beta:set_string("can_destruct", "false")

	pos.y = pos.y-dir

	meta = minetest.env:get_meta(pos):to_table()
	local beta =minetest.env:get_meta(pos)
	local can_destruct=beta:set_string("can_destruct", "true")
	minetest.env:set_node(pos, {name=replace, param2=p2})
	minetest.env:get_meta(pos):from_table(meta)
	local can_destruct=beta:set_string("can_destruct", "false")
	print("rightclick door end")
end

closed_by_key.on_destruct_door=function(pos)
	print("on_destruct_door start")
	local meta=minetest.env:get_meta(pos)
	local can_destruct=meta:get_string("can_destruct")
	print("can_destruct = "..tostring(can_destruct))
	if can_destruct == "false" then
		closed_by_key.door[minetest.pos_to_string(pos)]=meta:get_string("key_required")
	else
		closed_by_key.door[minetest.pos_to_string(pos)]="non determinato"
	end
	print("on_destruct_door end")
end

closed_by_key.after_destruct_door=function(pos,oldnode)
	print("after_destruct_door start")

	if closed_by_key.door[minetest.pos_to_string(pos)] == "non determinato" then
		print("non è il caso")
	else

		minetest.env:set_node(pos,oldnode)
		local meta=minetest.env:get_meta(pos)
		meta:set_string("key_required",closed_by_key.door[minetest.pos_to_string(pos)])
		print("key required = "..tostring(closed_by_key.door[minetest.pos_to_string(pos)]))
		closed_by_key.door[minetest.pos_to_string(pos)]=nil		
	end
	print("after_destruct_door end")
end

--generate alphanumeric random
local Chars = {}
for Loop = 0, 255 do
	Chars[Loop+1] = string.char(Loop)
end
local String = table.concat(Chars)
local Built = {['.'] = Chars}
local AddLookup = function(CharSet)
local Substitute = string.gsub(String, '[^'..CharSet..']', '')
local Lookup = {}
for Loop = 1, string.len(Substitute) do
	Lookup[Loop] = string.sub(Substitute, Loop, Loop)
end
	Built[CharSet] = Lookup
	return Lookup
end

closed_by_key.key_gen=function(Length, CharSet)
		-- Length (number)
		-- CharSet (string, optional); e.g. %l%d for lower case letters and digits
	local CharSet = CharSet or '.'
	if CharSet == '' then
		return ''
	else
		local Result = {}
		local Lookup = Built[CharSet] or AddLookup(CharSet)
		local Range = table.getn(Lookup)
		for Loop = 1,Length do
			Result[Loop] = Lookup[math.random(1, Range)]
		end
		return table.concat(Result)
	end
end


minetest.log("action", "[MOD]"..minetest.get_current_modname().." -- loaded from "..minetest.get_modpath(minetest.get_current_modname()))
