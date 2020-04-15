--
-- User: mike
-- Date: 23.11.2017
-- Time: 21:04
-- This file is part of Remixed Pixel Dungeon.
--

local RPD = require "scripts/lib/revampedCommonClasses"

local mob = require"scripts/lib/mob"

return mob.init({
    die = function(self, cause)
        local level = RPD.Dungeon.level
        local mob
        if math.random(1,100) <= 25 then
            if math.random(1,100) >= 26 then
                mob = RPD.MobFactory:mobByName("Husk")
            else
                mob = RPD.MobFactory:mobByName("Zombie")
            end
            local pos = self:getPos()
            mob:setPos(pos)
            if self:isPet() then
                mob:makePet(mob, RPD.Dungeon.hero)
            end
            level:spawnMob(mob)
        end
    end
})