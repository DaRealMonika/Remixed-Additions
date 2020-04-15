--
-- User: mike
-- Date: 03.06.2018
-- Time: 22:51
-- This file is part of Remixed Pixel Dungeon.
--

local RPD = require "scripts/lib/revampedCommonClasses"

local spell = require "scripts/lib/spell"

local mob = require "scripts/lib/mob"

return spell.init{
    desc  = function ()
        return {
            image         = 4,
            imageFile     = "spellsIcons/necromancy.png",
            name          = "DeathlyRecruit_Name",
            info          = "DeathlyRecruit_Info",
            magicAffinity = "Necromancy",
            targetingType = "cell",
            spellCost     = 15,
            castTime      = 3,
            level         = 1
        }
    end,
    castOnCell = function(self, spell, caster, cell)
        local target = RPD.Actor:findChar(cell)
        local clevel = caster:skillLevel()
        local level = RPD.Dungeon.level

        if target ~= nil then
            if target == caster then
                RPD.glogn("Deathly_CantTargetSelf")
                return false
            end

            if not target:canBePet() and target:getMobClassName() ~= "MirrorImage" then
                RPD.glogn("Deathly_Failed", target:name())
                return false
            end

            if not target:isPet() and target:canBePet() then
                local damage = math.random(3, 12)*clevel
                if damage < target:hp() then
                    target:damage(math.random(3*clevel, 12*clevel), caster)
                else
                    target:hp(target:ht())
                    target:setPos(cell)
                    target:loot(RPD.ItemFactory:itemByName("Gold"))
                    RPD.Mob:makePet(target, caster)
                    RPD.setAi(target, "Wandering")
                    level:spawnMob(target)
                    RPD.glogp("Deathly_Recruited", target:name())
                    return true
                end
            else
                RPD.glogn("Deathly_CantBePet")
                return false
            end
        end

        RPD.glog("Deathly_MustTargetChar")
        return false
    end
}