--
-- User: mike
-- Date: 29.01.2019
-- Time: 20:33
-- This file is part of Remixed Pixel Dungeon.
--

local RPD = require "scripts/lib/revampedCommonClasses"

local item = require "scripts/lib/item"

local list = {"FireMage","IceMage","WaterMage","DarkMage","LightMage","EarthMage"}
--local list = {"FireElemental","IceElemental","WaterElemental","Shadow","Wraith","EarthElemental"}
local waitTime = 25

return item.init{
    desc  = function (self, item)

        return {
            image         = 4,
            imageFile     = "items/books.png",
            name          = "SpecialSummon_Name",
            info          = "SpecialSummon_Desc",
            stackable     = false,
            upgradable    = true,
            identified    = false,
            defaultAction = "Scroll_ACRead",
            price         = 350
        }
    end,
    actions = function(self, item, hero)
        local multiplier = item:level()+1
        self.data.used = self.data.used or 0
        self.data.uses = self.data.uses or math.random(1,7)*multiplier
        return {"Scroll_ACRead"}
    end,

    execute = function(self, item, hero, action)
        if action == "Scroll_ACRead" then
            item:getUser():spendAndNext(TIME_TO_READ)
            local clevel = hero:level()
            local level = RPD.Dungeon.level
            local cell
            for i = 1,8 do
                cell = level:getEmptyCellNextTo(hero:getPos())
                if not RPD.Actor:findChar(cell) then
                    break
                end
            end

            if level:cellValid(cell) then
                local mob
                local hpMultiplier = 1
                if item:isIdentified() then
                    hpMultiplier = 3
                end
                mob = RPD.MobFactory:mobByName(list[math.random(1,#list)])
                mob:setPos(cell)
                mob:ht(mob:ht()*hpMultiplier)
                mob:hp(mob:ht())
                mob:loot(RPD.ItemFactory:itemByName("Gold"))
                mob:makePet(mob, hero)
                if item:isIdentified() then
                    RPD.setAi(mob, "Hunting")
                else
                    RPD.setAi(mob, "Wandering")
                end
                level:spawnMob(mob)
                RPD.glogp("Summoned_Mob",mob:getName())
                if self.data.used == self.data.uses-1 then
                    RPD.glogn("SpecialSummon_UseWarning",item:name())
                    self.data.used = self.data.used+1
                elseif self.data.used < self.data.uses then
                    self.data.used = self.data.used+1
                elseif self.data.used >= self.data.uses then
                    self.data.used = 0
                    RPD.glogn("SpecialSummon_Broke",item:name())
                    item:detach(item:getUser():getBelongings().backpack)
                end
                if not item:isIdentified() then
                    if self.data.uses >= 1 then
                        if math.random(1,100)+self.data.uses > 35 then
                            item:isIdentified(true)
                            RPD.glogp("Weapon_Identify","book",item:name()..". Your summons using this specific "..item:name().." will now be slightly stronger")
                        end
                    end
                end
                return true
            end
            RPD.glogn("Summon_NoSpace")
            return true
        end
    end,

    bag = function(self, item)
        return "ScrollHolder"
    end
}
