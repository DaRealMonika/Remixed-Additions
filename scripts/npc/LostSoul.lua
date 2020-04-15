--[[
    Created by mike.
    DateTime: 19.01.19 21:24
    This file is part of pixel-dungeon-remix
]]

local RPD = require "scripts/lib/revampedCommonClasses"
local mob = require "scripts/lib/mob"

local npc
local client

local dialog = function(index)
    if index == 0 then
        local level = RPD.Dungeon.level
        local levelId = RPD.Dungeon.levelId
        local mob = RPD.MobFactory:mobByName("WarriorGhost")
        mob:setPos(npc:getPos())
        RPD.setAi(mob, "Hunting")
        RPD.affectBuff(mob, RPD.Buffs.Paralysis, 1)
        level:spawnMob(mob)
        npc:destroy()
        npc:getSprite():killAndErase()
        client:spendAndNext(1)
        if levelId == "house2_basement" then
            level:set(level:cell(11,20), 10)
            RPD.GameScene:updateMap()
        end
    end
end

return mob.init({
    interact = function(self, chr)
        npc = self
        client = chr
        RPD.showQuestWindow(self, RPD.textById("NotFinished_test"))
--        RPD.chooseOption(dialog, self:name(), "Soul_SureFight", "Yes_Option", "No_Option")
    end,

    spawn = function(self, level)
        RPD.permanentBuff(self, "DmgImmune")
    end,
})
