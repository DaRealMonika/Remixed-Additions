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
        local function gasses(cell)
--            if level:cellValid(cell) then
                RPD.placeBlob(RPD.Blobs.ParalyticGas, cell, 20)
                RPD.placeBlob(RPD.Blobs.ToxicGas, cell, 20)
--            end
        end
        RPD.forCellsAtAround(self:getPos(), gasses)
    end,

    attackProc = function(self, enemy, dmg)
        if math.random(1,100) < 15 then
            RPD.affectBuff(enemy, RPD.Buffs.Bleeding, dmg+math.random(5,9))
        end
        return enemy:damage(dmg, self)
    end,

    stats = function(self)
        self:immunities():add(RPD.Blobs.ToxicGas)
        self:immunities():add(RPD.Blobs.ParalyticGas)
        self:immunities():add(RPD.Blobs.ConfusionGas)
    end
})