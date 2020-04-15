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

local questName = {"Boss Rush Goo","Boss Rush Tengu","Boss Rush DM_300","Boss Rush Dwarf King","Boss Rush Shadow Lord","Boss Rush Yog-Dzewa"}

local questText = {"Hi adventurer! I need you to kill... Goo.","Ok next I need you to kill... Tengu.","Now I need you to kill... DM 300.","Next it's time for you to kill... Dwarf King.","Now it's time for you to kill... Shadow Lord.","And now the last boss i need you to kill is... Yog-Dzewa, Good luck adventurer!"}

return mob.init({
    interact = function(self, chr)
        client = chr
        npc = self

        if not quest.isGiven(questName[1]) then
            RPD.showQuestWindow( npc,questText[1])
            quest.give(questName[1], npc, {kills={"Goo"}})
            RPD.Journal:add(npc:name().." "..questName[1])
            quest.debug(true)
            return
        elseif not quest.isGiven(questName[2]) and quest.isCompleted(questName[1]) then
            RPD.showQuestWindow( npc,questText[2])
            quest.give(questName[2], npc, {kills={"Tengu"}})
            RPD.Journal:add(npc:name().." "..questName[2])
            quest.debug(true)
            return
        elseif not quest.isGiven(questName[3]) and quest.isCompleted(questName[2]) then
            RPD.showQuestWindow( npc,questText[3])
            quest.give(questName[3], npc, {kills={"DM300"}})
            RPD.Journal:add(npc:name().." "..questName[3])
            quest.debug(true)
            return
        elseif not quest.isGiven(questName[4]) and quest.isCompleted(questName[3]) then
            RPD.showQuestWindow( npc,questText[4])
            quest.give(questName[4], npc, {kills={"King"}})
            RPD.Journal:add(npc:name().." "..questName[4])
            quest.debug(true)
            return
        elseif not quest.isGiven(questName[5]) and quest.isCompleted(questName[4]) then
            RPD.showQuestWindow( npc,questText[5])
            quest.give(questName[5], npc, {kills={"ShadowLord"}})
            RPD.Journal:add(npc:name().." "..questName[5])
            quest.debug(true)
            return
        elseif not quest.isGiven(questName[6]) and quest.isCompleted(questName[5]) then
            RPD.showQuestWindow( npc,questText[6])
            quest.give(questName[6], npc, {kills={"YogsEye"}})
            RPD.Journal:add(npc:name().." "..questName[6])
            quest.debug(true)
            return
        end

        if quest.isCompleted(questName[6]) then
            RPD.showQuestWindow( npc,"Thanks for doing this boss rush.")
            quest.debug(true)
        end

        local bossKilled
        if quest.isGiven(questName[1]) then
            bossKilled = quest.state(questName[1]).kills.Goo--[[ or storage.get("Goo kills")]] or 0
        elseif quest.isGiven(questName[2]) then
            bossKilled = quest.state(questName[2]).kills.Tengu--[[ or storage.get("Tengu kills")]] or 0
        elseif quest.isGiven(questName[3]) then
            bossKilled = quest.state(questName[3]).kills.DM300--[[ or storage.get("DM300 kills")]] or 0
        elseif quest.isGiven(questName[4]) then
            bossKilled = quest.state(questName[4]).kills.King--[[ or storage.get("King kills")]] or 0
        elseif quest.isGiven(questName[5]) then
            bossKilled = quest.state(questName[5]).kills.ShadowLord--[[ or storage.get("ShadowLord kills")]] or 0
        elseif quest.isioven(questName[6]) then
            bosssKilled = quest.state(questName[6]).kills.YogsEye or storage.get("Yog kills")--[[ or storage.get(YogsEye kills")]] or 0
        end

        if bossKilled == 0 then
            if quest.isGiven(questName[1]) then
                RPD.showQuestWindow( npc,"Remember your current quest is "..questName[1]..".")
            elseif quest.isGiven(questName[2]) then
                RPD.showQuestWindow( npc,"Remember your current quest is "..questName[2]..".")
            elseif quest.isGiven(questName[3]) then
                RPD.showQuestWindow( npc,"Remember your current quest is "..questName[3]..".")
            elseif quest.isGiven(questName[4]) then
                RPD.showQuestWindow( npc,"Remember your current quest is "..questName[4]..".")
            elseif quest.isGiven(questName[5]) then
                RPD.showQuestWindow( npc,"Remember your current quest is "..questName[5]..".")
            elseif quest.isGiven(questName[6]) then
                RPD.showQuestWindow( npc,"Remember your current quest is "..questName[6]..".")
            end
            quest.debug(true)
            return
        end

        if not (bossKilled < 1) then
            local rewardMultiplier
            if quest.isGiven(questName[1]) then
                rewardMultiplier = 1
                quest.complete(questName[1])
                RPD.Journal:remove(npc:name().." "..questName[1])
            elseif quest.isGiven(questName[2]) then
                rewardMultiplier = 2
                RPD.Journal:remove(npc:name().." "..questName[2])
                quest.complete(questName[2])
            elseif quest.isGiven(questName[3]) then
                rewardMultiplier = 3
                RPD.Journal:remove(npc:name().." "..questName[3])
                quest.complete(questName[3])
            elseif quest.isGiven(questName[4]) then
                rewardMultiplier = 4
                RPD.Journal:remove(npc:name().." "..questName[4])
                quest.complete(questName[4])
            elseif quest.isGiven(questName[5]) then
                rewardMultiplier = 5
                RPD.Journal:remove(npc:name().." "..questName[5])
                quest.complete(questName[5])
            elseif quest.isGiven(questName[6]) then
                rewardMultiplier = 6
                RPD.Journal:remove(npc:name().." "..questName[6])
                quest.complete(questName[6])
            end
            hero:collect(RPD.item("Gold", 250*rewardMultiplier))
        end
        quest.debug(true)
    end,

    spawn = function(self, level)
        RPD.permanentBuff(self, "DmgImmune")
    end,
})
