--
-- User: mike
-- Date: 24.01.2018
-- Time: 23:58
-- This file is part of Remixed Pixel Dungeon.
--

local RPD = require "scripts/lib/revampedCommonClasses"

local mob = require"scripts/lib/mob"

return mob.init{
    stats = function(self)
        local level = RPD.Dungeon.level
        local owner = self
        if self:getOwner() then
            owner = self:getOwner()
        end
        if owner ~= self then
            if level then
                if level:distance(self:getPos(), owner:getPos()) > 2 then
                    RPD.permanentBuff(self, RPD.Buffs.Invisibility)
                end
            end
        end
        if owner ~= self then
            if level then
                if level:distance(self:getPos(), owner:getPos()) == 2 then
                    RPD.affectBuff(owner, RPD.Buffs.MindVision, 5)
                end
            end
        end
        self:immunities():add("WandOfFirebolt")
    end,

    move = function(self,mob,cell)
        local level = RPD.Dungeon.level
        local owner = self
        if self:getOwner() then
            owner = self:getOwner()
        end
        for i = 0, level:getLength()-1 do
            local target = RPD.Actor:findChar(i)
            if target then
                if target ~= self then
                    if level:distance(self:getPos(), target:getPos()) <= 2 then
                        if self:hp() > 5 and target ~= owner then
                            RPD.permanentBuff(self, RPD.Buffs.Invisibility)
                        end
                        if (self:buffLevel("Invisibility") > 0 and self:hp() <= 5) or target == owner then
                            RPD.removeBuff(self, RPD.Buffs.Invisibility)
                        end
                        if owner ~= self then
                            if target == owner then
                                RPD.affectBuff(owner, RPD.Buffs.MindVision, 5)
                            end
                        end
                    end
                end
            end
        end
    end,

    attackProc = function(self, enemy, dmg)
        if self:buffLevel(RPD.Buffs.Invisibility) > 0 and not (dmg >= enemy:hp()) then
            RPD.removeBuff(self, RPD.Buffs.Invisibility)
        end
        RPD.affectBuff(enemy, RPD.Buffs.Necrotism, math.random(3,8))
    end,

    defenceProc = function(self, mob, enemy, damage)
        if self:buffLevel(RPD.Buffs.Invisibility) > 0 then
            RPD.removeBuff(self, RPD.Buffs.Invisibility)
        end
    end,

    act = function(self)
        local level = RPD.Dungeon.level
        local owner = self
        if self:getOwner() then
            owner = self:getOwner()
        end
        if self:buffLevel("Invisibility") > 0 then
            RPD.Sfx.CellEmitter:get(self:getPos()):pour(RPD.Sfx.SnowParticle.FACTORY, 3)
        end
        if owner ~= self then
            if level:distance(self:getPos(), owner:getPos()) > 2 then
                RPD.permanentBuff(self, RPD.Buffs.Invisibility)
            end
        end
        if owner ~= self then
            if level:distance(self:getPos(), owner:getPos()) == 2 then
                RPD.affectBuff(owner, RPD.Buffs.Awareness, 5)
            end
        end
    end
}
