--
-- User: mike
-- Date: 03.06.2018
-- Time: 22:51
-- This file is part of Remixed Pixel Dungeon.
--

local RPD = require "scripts/lib/revampedCommonClasses"

local spell = require "scripts/lib/spell"

local mob = require "scripts/lib/mob"

local storage = require "scripts/lib/storage"

local summonMob = {"AirElemental","WaterElemental","EarthElemental","IceElemental","FireElemental","DarkElemental","LightElemental"}

return spell.init{
    desc  = function ()
        return {
            image         = 0,
            imageFile     = "spellsIcons/elementalsummon.png",
            name          = "ElementalSummon_Name",
            info          = "ElementalSummon_Info",
            magicAffinity = "Elemental",
            targetingType = "none",
            spellCost     = 15,
            level         = 3
        }
    end,
    cast = function(self, spell, chr)
        local clevel = chr:level()
        local level = RPD.Dungeon.level
        local cell
        for i = 1,8 do
            cell = level:getEmptyCellNextTo(chr:getPos())
            if not RPD.Actor:findChar(cell) then
                break
            end
        end

        if level:cellValid(cell) then
            local mob
            mob = RPD.MobFactory:mobByName(summonMob[math.random(1,7)])
            mob:setPos(cell)
            mob:loot(RPD.ItemFactory:itemByName("Gold"))
            mob:makePet(mob, chr)
            RPD.setAi(mob, "Wandering")
            level:spawnMob(mob)
            RPD.glogp("Summoned_Mob",mob:getName())
            return true
        end
        RPD.glogn("Summon_NoSpace")
        return false
    end
}