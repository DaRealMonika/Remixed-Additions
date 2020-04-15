--
-- User: mike
-- Date: 23.11.2017
-- Time: 21:04
-- This file is part of Remixed Pixel Dungeon.
--

local RPD = require "scripts/lib/revampedCommonClasses"

local mob = require"scripts/lib/mob"

local mobs = {CactusMimic=true,Mummy=true,Zombie=true,Husk=true,Skeleton=true,GnollZombie=true,SandWorm=true,TombWorm=true,WormLarva=true}
local fMobs = {Hero=true,CactusMimic=true}

return mob.init({
    die = function(self, cause)
        local function cactiPoison(cell)
            local target = RPD.Actor:findChar(cell)
            if target then
                if not self:isPet() then
                    if not mobs[target:getEntityKind()] then
                        RPD.affectBuff(target, RPD.Buffs.Poison, 10)
                    end
                end
                if self:isPet() then
                    if not fMobs[target:getEntityKind()] then
                        if not target:isPet() then
                            RPD.affectBuff(target, RPD.Buffs.Poison, 10)
                        end
                    end
                end
            end
        end
        RPD.forCellsAround(self:getPos(), cactiPoison)
    end,

    stats = function(self)
        self:immunities():add(RPD.Blobs.ToxicGas)
        self:immunities():add(RPD.Buffs.Poison)
    end
})