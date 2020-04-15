--
-- User: mike
-- Date: 24.01.2018
-- Time: 23:58
-- This file is part of Remixed Pixel Dungeon.
--

local RPD = require "scripts/lib/revampedCommonClasses"

local mob = require"scripts/lib/mob"

return mob.init{
    attackProc = function(self, enemy, dmg)
        if math.random(1,100) <= 35 then
            RPD.affectBuff(enemy, RPD.Buffs.Poison, dmg/3)
        end
        return dmg
    end
}