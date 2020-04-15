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
        local amount = math.random(1,9)
        if math.random(1,100) <= 33 then
            for i = 1, amount do
                local mob = RPD.MobFactory:mobByName("WormLarva")
                local pos
                if i == 1 then
                    pos = self:getPos()
                else
                    pos = level:getEmptyCellNextTo(self:getPos())
                end
                if level:cellValid(pos) then
                    mob:setPos(pos)
                    if self:isPet() then
                        mob:makePet(mob, RPD.Dungeon.hero)
                    end
                    level:spawnMob(mob)
                end
            end
        end
    end,

    stats = function(self)
        self:immunities():add(RPD.Blobs.ToxicGas)
        self:immunities():add(RPD.Blobs.ParalyticGas)
        self:immunities():add(RPD.Blobs.ConfusionGas)
        self:immunities():add(RPD.Buffs.Paralysis)
        self:immunities():add(RPD.Buffs.Burning)
        self:immunities():add(RPD.Buffs.Blindness)
        self:immunities():add(RPD.Buffs.Roots)
        self:immunities():add(RPD.Buffs.Levitation)
    end
})