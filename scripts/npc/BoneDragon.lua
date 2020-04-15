--[[
    Created by mike.
    DateTime: 19.01.19 21:24
    This file is part of pixel-dungeon-remix
]]

local RPD = require "scripts/lib/revampedCommonClasses"

local mob = require"scripts/lib/mob"

return mob.init({
    interact = function(self, chr)
        local level = RPD.Dungeon.level
        local levelId = RPD.Dungeon.levelId
        local mob = RPD.MobFactory:mobByName("BoneDragon")
        mob:setPos(self:getPos())
        RPD.setAi(mob, "Hunting")
        RPD.affectBuff(mob, RPD.Buffs.Paralysis, 1)
        level:spawnMob(mob)
        self:destroy()
        self:getSprite():killAndErase()
        chr:spendAndNext(1)
        if levelId == "tombFinal" then
            level:set(level:cell(7,11), 12)
            RPD.GameScene:updateMap()
        end
    end,

    spawn = function(self, level)
        RPD.permanentBuff(self, "DmgImmune")
    end,
})
