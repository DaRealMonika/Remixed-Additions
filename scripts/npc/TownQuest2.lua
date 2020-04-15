--
-- User: mike
-- Date: 25.11.2017
-- Time: 22:56
-- This file is part of Remixed Pixel Dungeon.
--

local RPD = require "scripts/lib/revampedCommonClasses"

local mob = require"scripts/lib/mob"

local quest = require"scripts/lib/quest"

local npc
local client

local hero = RPD.Dungeon.hero

local questName = "Kill "..RPD.MobFactory:mobByName("Albino"):name().."s"

return mob.init({
    interact = function(self, chr)
        client = chr
        npc = self
        if not quest.isGiven(questName) then
            RPD.showQuestWindow( npc,"Hi adventurer! I need you to kill a few "..RPD.MobFactory:mobByName("Albino"):name().."s!")
            RPD.Journal:add(npc:name().." "..questName)
            quest.give(questName, npc, {kills={"Albino"}})
            quest.debug(true)
            return
        end

        if quest.isCompleted(questName) then
            RPD.showQuestWindow( npc,"Thank you so much!")
            quest.debug(true)
            return
        end

        local alratKilled = quest.state(questName).kills.Albino or 0

        if alratKilled < 3 then
            RPD.showQuestWindow( npc,alratKilled.." out of 3 "..RPD.MobFactory:mobByName("Albino"):name().."s killed so far, please keep going!")
        else
            RPD.showQuestWindow( npc,"Great Work! Here's your reward!")
            RPD.Journal:remove(npc:name().." "..questName)
            RPD.ItemFactory:itemByName("Gold"):quantity(300)
            hero:collect(RPD.ItemFactory:itemByName("Gold"))
            quest.complete(questName)
        end
        quest.debug(true)
    end,

    spawn = function(self, level)
        RPD.permanentBuff(self, "DmgImmune")
    end,
})
