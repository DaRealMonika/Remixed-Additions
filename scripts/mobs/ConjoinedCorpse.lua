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
        local mob1 = RPD.MobFactory:mobByName("CorpseLarva")
        local mob2 = RPD.MobFactory:mobByName("SplitCorpse")
        if math.random(1,100) <= 25 then
            local pos = self:getPos()
            mob1:setPos(pos)
            if self:isPet() then
                mob:makePet(mob1, RPD.Dungeon.hero)
            end
            level:spawnMob(mob1)
        end
        if math.random(1,100) <= 75 then
            local pos = self:getPos()
            mob2:setPos(pos)
            if self:isPet() then
                mob:makePet(mob2, RPD.Dungeon.hero)
            end
            level:spawnMob(mob2)
        end
    end
})