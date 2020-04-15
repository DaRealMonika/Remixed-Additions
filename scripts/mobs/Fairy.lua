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
        local cellPos = RPD.getXy(self)
        local function death(cell)
            local target = RPD.Actor:findChar(cell)
            RPD.placeBlob(RPD.Blobs.Regrowth, cell, 20)
            if target then
                if not self:isPet() and target:getEntityKind() ~= "Hero" then
                    RPD.affectBuff(target, RPD.Buffs.Roots, 5)
                end
            end
        end
        RPD.forCellsAround(cellPos, death)
    end,

    zapProc = function(self, enemy, dmg)
        if enemy then
            RPD.affectBuff(enemy, RPD.Buffs.Roots, dmg)
            RPD.placeBlob(RPD.Blobs.Regrowth, enemy:getPos(), 20)
        end
        return enemy:damage(dmg, self)
    end,

    attackProc = function(self, enemy, dmg)
        RPD.permanentBuff(self, RPD.Buffs.Barkskin)
        if enemy then
            RPD.affectBuff(enemy, RPD.Buffs.Weakness, dmg)
            RPD.affectBuff(enemy, RPD.Buffs.Ooze, dmg)
            RPD.affectBuff(enemy, RPD.Buffs.Vertigo, dmg)
        end
        return enemy:damage(dmg/2, self)
    end,

    stats = function(self)
        RPD.permanentBuff(self, RPD.Buffs.Barkskin)
        self:immunities():add(RPD.Blobs)
        self:immunities():add(RPD.Buffs.Blindness)
        self:immunities():add(RPD.Buffs.Roots)
        self:immunities():add(RPD.Buffs.Cripple)
        self:immunities():add(RPD.Buffs.Charm)
    end
})