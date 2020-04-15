--
-- User: mike
-- Date: 24.01.2018
-- Time: 23:58
-- This file is part of Remixed Pixel Dungeon.
--

local RPD = require "scripts/lib/revampedCommonClasses"
local mob = require"scripts/lib/mob"

local Buffs = RPD.Buffs

local Buffs = {Buffs.Paralysis,Buffs.Vertigo,Buffs.Hunger,Buffs.Poison,Buffs.Cripple,Buffs.Necrotism,Buffs.Blindness,Buffs.Ooze,Buffs.Terror,Buffs.Weakness,"Nightmare"}

return mob.init{
    attackProc = function(self, enemy, dmg)
        if math.random(1,100) <= 35 and dmg > 0 then
            RPD.affectBuff(enemy, Buffs[math.random(1,#Buffs)], (dmg/2)+math.random(5,13))
        end
        return dmg
    end
}