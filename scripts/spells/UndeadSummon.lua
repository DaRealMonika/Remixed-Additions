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

local summonMob = {"Deathling","Skeleton","Shadow","Undead","Wraith","ZombieGnoll"}
local optionalSummon = {"EnslavedSoul","DreadKnight","DeathKnight","Zombie","ExplodingSkull"}

return spell.init{
    desc  = function ()
        return {
            image         = 0,
            imageFile     = "spellsIcons/undeadsummon.png",
            name          = "UndeadSummon_Name",
            info          = "UndeadSummon_Info",
            magicAffinity = "Necromancy",
            targetingType = "none",
            spellCost     = 15,
            castTime      = 5,
            level         = 1
        }
    end,
    cast = function(self, spell, chr)
        local tier = tier or 1
        local clevel = chr:level()
        local level = RPD.Dungeon.level
        local cell
        for i = 1,8 do
            cell = level:getEmptyCellNextTo(chr:getPos())
            if not RPD.Actor:findChar(cell) then
                break
            end
        end

        if RPD.checkBadge("SHADOW_LORD_SLAIN") then
            tier = 6
        elseif RPD.checkBadge("BOSS_SLAIN_4") then
            tier = 5
        elseif RPD.checkBadge("BOSS_SLAIN_3") then
            tier = 4
        elseif RPD.checkBadge("BOSS_SLAIN_2") then
            tier = 3
        elseif RPD.checkBadge("BOSS_SLAIN_1") then
            tier = 2
        else
            tier = 1
        end

        if level:cellValid(cell) then
            local mob
            if math.random(1, 10) <= 5 then
                mob = RPD.MobFactory:mobByName(summonMob[tier])
            else
                mob = RPD.MobFactory:mobByName(optionalSummon[math.random(1, 5)])
            end
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