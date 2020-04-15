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
        local function paralysis(cell)
--            if level:cellValid(cell) then
                RPD.placeBlob(RPD.Blobs.ParalyticGas, cell, 20)
--            end
        end
        RPD.forCellsAtAround(self:getPos(), paralysis)
    end,
    defenceProc = function(self, enemy, dmg)
        if math.random(1,100) < 15 then
            RPD.affectBuff(enemy, RPD.Buffs.Paralysis, 3)
        end
        return self:damage(dmg, enemy)
    end,

    zapProc = function(self, enemy, dmg)
        if math.random(1,100) >= 25 then
            RPD.affectBuff(enemy, RPD.Buffs.Paralysis, 3)
        end
        return enemy:damage(dmg, self)
    end,

    attackProc = function(self, enemy, dmg)
        if math.random(1,100) < 15 then
            RPD.affectBuff(enemy, RPD.Buffs.Paralysis, 3)
        end
        return enemy:damage(dmg, self)
    end,

    stats = function(self)
        self:immunities():add(RPD.Blobs)
        self:immunities():add(RPD.Buffs.Poison)
        self:immunities():add(RPD.Buffs.Paralysis)
        self:immunities():add(RPD.Buffs.Burning)
        self:immunities():add(RPD.Buffs.Blindness)
        self:immunities():add(RPD.Buffs.Terror)
        self:immunities():add(RPD.Buffs.Bleeding)
        self:immunities():add(RPD.Buffs.Slow)
        self:immunities():add(RPD.Buffs.Vertigo)
        self:immunities():add(RPD.Buffs.Charm)
        self:immunities():add(RPD.ItemFactory:itemByName("WandOfShadowbolt"))
        self:immunities():add(RPD.ItemFactory:itemByName("WandOfLightning"))
    end
})