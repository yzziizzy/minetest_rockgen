
local mn = "rockgen"
local modpath = minetest.get_modpath(mn)

local has_technic = false
if nil ~= minetest.get_modpath("technic") then
	has_technic = true
end

local has_moreores = false
if nil ~= minetest.get_modpath("moreores") then
	has_moreores = true
end
--dofile(modpath.."/rocks.lua")



local vc = 64
local vc2 = 64


local np_caves = {
    offset = 0,
    scale = 1,
    spread = {x=64, y=64, z=64}, --squash the layers a bit
    seed = 54333,
    octaves = 3,
    persist = 0.67
}
local np_caves2 = {
    offset = 0,
    scale = 1,
    spread = {x=64, y=64, z=64}, --squash the layers a bit
    seed = 453467,
    octaves = 5,
    persist = 0.67
}


local np_stone = {
    offset = .5,
    scale = 1,
    spread = {x=256, y=128, z=256}, --squash the layers a bit
    seed = 34033,
    octaves = 2,
    persist = 0.67
}

local np_terrain1 = {
    offset = 0,
    scale = 1,
    spread = {x=vc, y=vc, z=vc},
    seed = 5900033,
    octaves = 1,
    persist = 0.67
}
local np_terrain2 = {
    offset = 0,
    scale = 1,
    spread = {x=vc, y=vc, z=vc},
    seed = 59002,
    octaves = 1,
    persist = 0.67
}
local np_terrain3 = {
    offset = 0,
    scale = 1,
    spread = {x=vc, y=vc, z=vc},
    seed = 5900232,
    octaves = 1,
    persist = 0.67
}
local np_terrain4 = {
    offset = 0,
    scale = 1,
    spread = {x=vc, y=vc, z=vc},
    seed = 334502,
    octaves = 1,
    persist = 0.67
}
local np_terrain5 = {
    offset = 0,
    scale = 1,
    spread = {x=vc, y=vc, z=vc},
    seed = 756742,
    octaves = 1,
    persist = 0.67
}


local np_abundance1 = {
    offset = 0,
    scale = 8,
    spread = {x=256, y=256, z=256},
    seed = 4876,
    octaves = 3,
    persist = 0.60
}

--[[
minetest.register_node( "mapgen:glowshroom", {
    description = "Glowing Mushroom",
    tiles = { "default_bookshelf.png" },
    is_ground_content = true,
    sounds = default.node_sound_wood_defaults(),
    groups = {choppy=2,flammable=2},
    light_source = LIGHT_MAX-3,
    node_box = {
        type = "fixed",
        fixed = {-1/7, -1/2, -1/7, 1/7, 1/2, 1/7},
    },
    selection_box = {
        type = "fixed",
        fixed = {-1/7, -1/2, -1/7, 1/7, 1/2, 1/7},
    },
})]]
--mgv7_np_terrain_base = 4,    120,  (1300, 1300, 1300), 82341, 6, 0.7
--mgv7_np_terrain_alt = 4,    70,  (1000, 1000, 1000), 5934,  3, 0.6


--[[  weird cool cliff world

mgv7_np_terrain_base = 4,    520,  (1300, 1300, 1300), 82341, 3, 0.7
mgv7_np_terrain_alt = 4,    525,  (1228, 1228, 1228), 5934,  1, 0.6
mgv7_np_height_select = -1, 100,  (1250, 1250, 1250), 4213,  5, 0.7

mgv7_np_mount_height    = 400,  700,  (500, 500, 500), 72449, 4, 0.6


]]


-- minetest.register_on_respawnplayer(function(player)
--     player:setpos({x=571, y=50, z=70})
--     return true
-- end)

local scaler = 4

local choose = function(cond, a, b)
	if cond then 
		return a 
	else 
		return b 
	end
end


core.clear_registered_ores()

minetest.register_on_generated(function(minp, maxp, seed)
--      if maxp.y > 0 then
--          return
--      end


    local x1 = maxp.x
    local y1 = maxp.y
    local z1 = maxp.z
    local x0 = minp.x
    local y0 = minp.y
    local z0 = minp.z

    local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
    local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
    local data = vm:get_data()

    -- general
    local c_water = minetest.get_content_id("default:water_source")
    local c_water = minetest.get_content_id("default:river_water_source")
    local c_stone = minetest.get_content_id("default:stone")
    local c_desertstone = minetest.get_content_id("default:desert_stone")
    local c_sandstone = minetest.get_content_id("default:sandstone")
    local c_air = minetest.get_content_id("air")
    local c_wood = minetest.get_content_id("default:wood")
    local c_glass = minetest.get_content_id("default:glass")
    local c_dirt = minetest.get_content_id("default:dirt")
    local c_lava = minetest.get_content_id("default:lava_source")
    local c_mossycobble = minetest.get_content_id("default:mossycobble")

    -- ores
    local c_mese = minetest.get_content_id("default:stone_with_mese")
    local c_iron = minetest.get_content_id("default:stone_with_iron")
    local c_coal = minetest.get_content_id("default:stone_with_coal")
    local c_coalblock = minetest.get_content_id("default:coalblock")
    local c_copper = minetest.get_content_id("default:stone_with_copper")
    local c_diamond = minetest.get_content_id("default:stone_with_diamond")
    local c_gold = minetest.get_content_id("default:stone_with_gold")
	local c_tin = minetest.get_content_id("default:stone_with_tin")
	local c_hematite = minetest.get_content_id("geology:hematite")

	local c_uranium
	local c_chromium
	local c_zinc
	local c_silver
	local c_mithril
	if has_technic == true then
	    c_uranium = minetest.get_content_id("technic:mineral_uranium")
	    c_chromium = minetest.get_content_id("technic:mineral_chromium")
	    c_zinc = minetest.get_content_id("technic:mineral_zinc")
	else
		c_uranium = minetest.get_content_id("default:obsidian_glass")	
		c_chromium = minetest.get_content_id("default:stone_with_copper")	
		c_zinc = minetest.get_content_id("default:stone_with_tin")	
	end
	
	if has_moreores == true then
	    c_silver = minetest.get_content_id("moreores:mineral_silver")
	    c_mithril = minetest.get_content_id("moreores:mineral_mithril")
	else
		c_silver = minetest.get_content_id("default:stone_with_gold")
		c_mithril = minetest.get_content_id("default:stone_with_mese")
	end
		

    -- geologic
    local c_obglass = minetest.get_content_id("default:obsidian_glass")
    local c_sandstone = minetest.get_content_id("default:sandstone")
    local c_gravel = minetest.get_content_id("default:gravel")
    local c_desertstone = minetest.get_content_id("default:desert_stone")
    local c_granite = minetest.get_content_id("geology:granite")
    local c_marble = minetest.get_content_id("geology:marble")
    local c_slate = minetest.get_content_id("geology:slate")
    local c_gneiss = minetest.get_content_id("geology:gneiss")
    local c_basalt = minetest.get_content_id("geology:basalt")
    local c_schist = minetest.get_content_id("geology:schist")
    local c_chalk = minetest.get_content_id("geology:chalk")
    local c_shale = minetest.get_content_id("geology:shale")
    local c_ors = minetest.get_content_id("geology:ors")
    local c_jade = minetest.get_content_id("geology:jade")
    local c_serpentine = minetest.get_content_id("geology:serpentine")
    local c_anthracite = minetest.get_content_id("geology:anthracite")
    local c_clay = minetest.get_content_id("default:clay")

    local c_torch = minetest.get_content_id("default:torch")
    --local c_shroom = minetest.get_content_id("mapgen:glowshroom")
--     local c_lava = minetest.get_content_id("default:lava_source")


    local sidelen = x1 - x0 + 1
    local chulens = {x=sidelen, y=sidelen, z=sidelen}
    local minposxyz = {x=x0, y=y0, z=z0}
    local minposxz = {x=x0, y=z0}

--    local nvals_caves = minetest.get_perlin_map(np_caves, chulens):get3dMap_flat(minposxyz)
--    local nvals_caves2 = minetest.get_perlin_map(np_caves2, chulens):get3dMap_flat(minposxyz)
    local nvals_terrain_s = minetest.get_perlin_map(np_stone, chulens):get3dMap_flat(minposxyz)
    local nvals_terrain1 = minetest.get_perlin_map(np_terrain1, chulens):get3dMap_flat(minposxyz)
    local nvals_terrain2 = minetest.get_perlin_map(np_terrain2, chulens):get3dMap_flat(minposxyz)
    local nvals_terrain3 = minetest.get_perlin_map(np_terrain3, chulens):get3dMap_flat(minposxyz)
    local nvals_terrain4 = minetest.get_perlin_map(np_terrain4, chulens):get3dMap_flat(minposxyz)
    local nvals_terrain5 = minetest.get_perlin_map(np_terrain5, chulens):get3dMap_flat(minposxyz)
    local nvals_abundance1 = minetest.get_perlin_map(np_abundance1, chulens):get3dMap_flat(minposxyz)

    --[[
    .008 # holy fuck way too much
    .005 # thick consistent vein a few nodes in diameter
    .003 # continuous one node thick vein, occasinoally skips a node or becomes 2 thick
    .0015 # ores are spaced several nodes apart. easy to lose but easy to find again.

    ]]
    local thickness_abundant = .0025*scaler
    local thickness_normal = .0020*scaler
    local thickness_scarce = .0016*scaler
    local thickness_rare = .0011*scaler

    local nixyz = 1 -- 3D noise index
    for z = z0, z1 do -- for each xy plane progressing northwards
        for y = y0, y1 do -- for each x row progressing upwards
            local vi = area:index(x0, y, z)
            for x = x0, x1 do -- for each node do

--                 -- cave stuff
--                local cave_density = math.abs(nvals_caves[nixyz])
--                local cave_density2 = math.abs(nvals_caves2[nixyz])
--                local cave_density = nvals_caves[nixyz]
--                --local cave_density2 = nvals_caves2[nixyz]
--
--                 if data[vi] == c_air
--                     and cave_density > .7
--                     and cave_density2 > .7
--                     then
--                     data[vi] = c_schist
--                 end



				
                if data[vi] == c_air and y < 0 then
                    if math.random() < 0.1 and (data[vi-1] == c_mossycobble)  then
                        data[vi] = c_torch
                    end
                end
				

				local dy_limit = 2500
				local dy_ratio = .5
				
				local da_ratio = .5
				
				local dc2 = (x * x) + (z * z)
				local dc_scale =  .5 + ((dc2 / (200 * 200)) * .5)
				local dy_scale =  math.max(0, math.min(dy_ratio + ((-y / dy_limit) * (1 - dy_ratio)), 1)) 
				local abundance1 = math.max(0, math.min(math.abs(nvals_abundance1[nixyz]), 1)) 
				local da_scale =  math.max(0, math.min(da_ratio + (abundance1 * (1 - da_ratio)), 1))
				--print(abundance1)
				
				
				local thickness_abundant = .0025*scaler * dy_scale * da_scale
				local thickness_normal = .0020*scaler * dy_scale * da_scale
				local thickness_scarce = .0016*scaler * dy_scale * da_scale
				local thickness_rare = .0011*scaler * dy_scale * da_scale
				
				local on = data[vi]
                if on == c_stone or on == c_desertstone or on == c_sandstone 
					-- or on == c_air or on == c_sand -- debug
				then
                --if on == c_air then
                    local density_s = nvals_terrain_s[nixyz]
                    --local density1_f = math.abs(nvals_terrain1[nixyz])
                    local density1 = math.abs(nvals_terrain1[nixyz]) 
                    local density2 = math.abs(nvals_terrain2[nixyz]) 
                    local density3 = math.abs(nvals_terrain3[nixyz]) 
                    local density4 = math.abs(nvals_terrain4[nixyz]) 
					local density5 = math.abs(nvals_terrain5[nixyz]) 
					
					--print(dc_scale)
					
                    -- ore veins first
                    if     density1 < thickness_normal and density2 < thickness_normal then
                        data[vi] = choose(dc2 > 5000*5000, c_mese, c_tin)
                    elseif density1 < thickness_abundant and density3 < thickness_abundant then
                        data[vi] = choose(dc2 > 1000*1000, c_iron, c_tin)
                    elseif density1 < thickness_normal and density4 < thickness_normal then
                        data[vi] = c_copper
                    elseif density1 < thickness_rare and density5 < thickness_rare then
						data[vi] = choose(dc2 > 10000*10000, c_mithril, c_iron)
                    elseif density2 < thickness_rare and density3 < thickness_rare then
						data[vi] = choose(dc2 > 2000*2000, c_diamond, c_mese)
                    elseif density2 < thickness_scarce and density4 < thickness_scarce then
						data[vi] = choose(dc2 > 500*500, c_silver, c_copper)
                    elseif density2 < thickness_normal and density5 < thickness_normal then
						data[vi] = c_tin
                    elseif density3 < thickness_scarce and density4 < thickness_scarce then
						data[vi] = choose(y < 500, c_silver, c_copper)
                    elseif density3 < thickness_normal and density5 < thickness_normal then
						data[vi] = choose(dc2 > 750*750, c_chromium, c_tin)
                    elseif density4 < thickness_normal and density5 < thickness_normal then
						data[vi] = choose(dc2 > 500*500, c_zinc, c_tin)
                
                    -- then ore pockets
                    elseif density2 > 0.92 then
                        data[vi] = c_uranium

					-- elseif true == true then data[vi] = c_air -- debug
 
                    -- normal rocks
                    elseif density_s > 1.25 then
                        data[vi] = c_jade
                    elseif density_s > 1.10 then
                        data[vi] = c_serpentine
                    elseif density_s > 1.00 then
                        data[vi] = c_shale
                    elseif density_s > 0.90 then
                        data[vi] = c_granite
                    elseif density_s > 0.89 then
						if density1 < thickness_normal or density2 < thickness_rare or density3 < thickness_rare  or density4 < thickness_rare then
							data[vi] = c_gold
						else
							data[vi] = c_granite
						end
                    elseif density_s > 0.80 then
                        data[vi] = c_basalt
                    elseif density_s > 0.702 then
                        data[vi] = c_slate
                    elseif density_s > 0.70 then
                        data[vi] = c_anthracite
                    elseif density_s > 0.60 then
                        data[vi] = c_marble
                    elseif density_s > 0.505 then
                        data[vi] = c_gneiss
					elseif density_s > 0.40 and density2 > .7 then
                        data[vi] = c_hematite
                    elseif density_s > 0.40 then
                        data[vi] = c_desertstone
                    elseif density_s > 0.30 then
                        data[vi] = c_sandstone
                    elseif density_s > 0.202 then
                        data[vi] = c_schist

                    elseif density_s > 0.20 then
                        data[vi] = c_gravel
                    elseif density_s > 0.19 then
                        data[vi] = c_coalblock
                    elseif density_s > 0.188 then
                        data[vi] = c_gravel

                    elseif density_s > 0.10 then
                        data[vi] = c_chalk
                    elseif density_s > 0.00 then
                        data[vi] = c_clay
                    elseif density_s > -0.10 then
                        data[vi] = c_ors
                    else
                        data[vi] = c_stone

                    end

 --]]
                end

                nixyz = nixyz + 1 -- increment 3D noise index

                vi = vi + 1 
            end
        end
    end




    vm:set_data(data)
    vm:set_lighting({day=0, night=0})
    vm:calc_lighting()
    vm:write_to_map(data)
end)


