--
-- User: mike
-- Date: 29.01.2019
-- Time: 20:33
-- This file is part of Remixed Pixel Dungeon.
--

local RPD = require "scripts/lib/revampedCommonClasses"
local item = require "scripts/lib/item"

local snowTownMaps = {home=true,crossroads=true,snowTown=true,tower1=true,tower2=true,house1=true,house2_basement=true,library=true,attic=true,town_shop=true,fortune=true,inn=true,cinema=true,shed=true}

local map

return item.init{
    desc  = function (self, item)
        return {
            image         = 18,
            imageFile     = "items/scrolls.png",
            name          = "ScrollOfReturning_Name",
            info          = "ScrollOfReturning_Desc",
            stackable     = true,
            upgradable    = false,
            identified    = true,
            defaultAction = "Return_SnowTown",
            price         = 399
        }
    end,
    actions = function(self, item, hero)
        self.data.returnData = self.data.returnData or {map="home",x=9,y=3}
        map = RPD.textById(self.data.returnData.map.."Map_Name")
        return {"Return_SnowTown",RPD.textById("Return_ToMap"):format(map)}
    end,

    execute = function(self, item, hero, action)
        local level = RPD.Dungeon.level
        local levelId = RPD.Dungeon.levelId
        local user = item:getUser()
        local target
        for i = 0, level:getLength()-1 do
            target = RPD.Actor:findChar(i)
            if target then
                if level:distance(user:getPos(), target:getPos()) == 1 then
                    RPD.glogn("LloidsBeacon_Creatures")
                    break
                    return
                end
            end
        end
        if action == "Return_SnowTown" then
            local pos = RPD.getXy(user)
            if snowTownMaps[levelId] then
                RPD.glogn("Return_Failed", RPD.textById("snowTownMap_Name"))
                return
            end
            self.data.returnData = {map=levelId,x=pos[1],y=pos[2]}
            RPD.teleportTo("snowTown", 12, 28)
            user:spendAndNext(TIME_TO_READ)
            RPD.glogp("Return_Successful", RPD.textById("snowTownMap_Name"))
        end

        if action == RPD.textById("Return_ToMap"):format(map) then
            if self.data.returnData.map ~= "home" then
                if self.data.returnData.map ~= levelId then
                    RPD.teleportTo(self.data.returnData.map, self.data.returnData.x, self.data.returnData.y)
                    item:detach(user:getBelongings().backpack)
                    user:spendAndNext(TIME_TO_READ)
                    RPD.glogp("Return_Successful", map)
                    self.data.returnData = {map="home",x=9,y=3}
                    return
                end
            end
            RPD.glogn("Return_Failed", map)
        end
    end,

    bag = function(self, item)
        return "ScrollHolder"
    end
}
