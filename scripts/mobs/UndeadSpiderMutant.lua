--
-- User: mike
-- Date: 23.11.2017
-- Time: 21:04
-- This file is part of Remixed Pixel Dungeon.
--

local RPD = require "scripts/lib/revampedCommonClasses"

local mob = require"scripts/lib/mob"

return mob.init({
    attackProc = function(self, enemy, dmg)
        if math.random(1,100) < 15 then
            RPD.affectBuff(enemy, RPD.Buffs.Poison, math.random(2,3) * RPD.Buffs.Poison.durationFactor(enemy))
        end
        return enemy:damage(dmg, self)
    end,

    die = function(self, cause)
        local level = RPD.Dungeon.level
        local mob = RPD.MobFactory:mobByName("CorpseLarva")
        if math.random(1,100) <= 25 then
            local pos = self:getPos()
            mob:setPos(pos)
            if self:isPet() then
                mob:makePet(mob, RPD.Dungeon.hero)
            end
            level:spawnMob(mob)
        end
    end
})