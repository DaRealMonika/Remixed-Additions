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
        if math.random(1,100) <= 38 then
            for i = 1, amount do
                local mob = RPD.MobFactory:mobByName("CorpseLarva")
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
        local function gasses(cell)
            if level:cellValid(cell) then
                RPD.placeBlob(RPD.Blobs.ToxicGas, cell, 20)
                RPD.placeBlob(RPD.Blobs.ParalyticGas, cell, 20)
            end
        end
        RPD.forCellsAtAround(self:getPos(), gasses)
    end,

    attackProc = function(self, enemy, dmg)
        if math.random(1,100) < 15 then
            RPD.affectBuff(enemy, RPD.Buffs.Bleeding, dmg/2)
        end
        return enemy:damage(dmg, self)
    end,

    stats = function(self)
        RPD.permanentBuff(self, RPD.Buffs.Slow)
        self:immunities():add(RPD.Blobs)
        self:immunities():add(RPD.Buffs.Poison)
        self:immunities():add(RPD.Buffs.Blindness)
        self:immunities():add(RPD.Buffs.Levitation)
    end,

    act = function(self)
        local level = RPD.Dungeon.level
        if math.random(1,100) <= 17 then
            local mob = RPD.MobFactory:mobByName("CorpseLarva")
            local pos = self:getPos()
            if level:cellValid(pos) then
                mob:setPos(pos)
            end
            if self:isPet() then
                mob:makePet(mob, RPD.Dungeon.hero)
            end
            level:spawnMob(mob)
        end
    end
})