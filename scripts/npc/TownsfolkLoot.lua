--
-- User: mike
-- Date: 25.11.2017
-- Time: 22:56
-- This file is part of Remixed Pixel Dungeon.
--

local RPD = require "scripts/lib/revampedCommonClasses"
local mob = require "scripts/lib/mob"
local quest = require "scripts/lib/quest"

local npc
local client

local amountKill = 25
local amountCollect = 20

--local Quest = RPD.textById("QuestKill"):format(tostring(amountKill), RPD.textById(RPD.MobFactory:mobByName("Thief"):getEntityKind().."_NamePlural"), RPD.textById("QuestCollect"):format(tostring(amountCollect), RPD.textById(RPD.ItemFactory:itemByName("SoulShard"):getClassName().."_NamePlural")))

local questName = RPD.textById("QuestName"):format(Quest)"Kill "..RPD.MobFactory:mobByName("Thief"):name().."s, Collect "..RPD.ItemFactory:itemByName("SoulShard"):name().."s"

return mob.init({
    interact = function(self, chr)
        local hero = RPD.Dungeon.hero
        client = chr
        npc = self
        if not quest.isGiven(questName) then
            RPD.showQuestWindow(npc, "Hi adventurer! I need you to kill "..amountKill.." "..RPD.MobFactory:mobByName("Thief"):name().."s and collect "..amountCollect.." "..RPD.ItemFactory:itemByName("SoulShard"):name().."s!")
            RPD.Journal:add(npc:name().." "..questName)
            quest.give(questName, npc, {kills={"Thief"}})
            quest.debug(true)
            return
        end

        if quest.isCompleted(questName) then
            RPD.showQuestWindow( npc,"Thank you so much!\nHope you enjoy what was left in that house.")
            quest.debug(true)
            return
        end

        local thiefKilled = quest.state(questName).kills.Thief or 0
        local soulShardCollected = hero:getBelongings():getItem("SoulShard"):quantity() or 0

        if thiefKilled < amountKill or soulShard < amountCollect then
            RPD.showQuestWindow( npc,thiefKilled.." out of "..amountKill.." "..RPD.MobFactory:mobByName("Thief"):name().."s killed so far,"..soulShardCollected.." out of "..amountCollect.." "..RPD.ItemFactory:itemByName("SoulShard"):name().."s, please keep going!")
        else
            RPD.ItemFactory:itemByName("SoulShard"):detach(hero:getBelongings().backpack, amountCollect)
            RPD.showQuestWindow( npc,"Great job, Here's your reward!")
            RPD.Journal:remove(npc:name().." "..questName)
            local key = RPD.createItem("IronKey", {levelId="house2",depth=0})
            hero:collect(key)
            local book = RPD.createItem("Codex", {text="abandonedHouse_Info"})
            hero:collect(book)
            RPD.showQuestWindow( npc,"The book that I just gave you I made it to give you info about what that key goes to and what happened.")
            quest.complete(questName)
        end
        quest.debug(true)
    end,

    spawn = function(self, level)
        RPD.permanentBuff(self, "DmgImmune")
    end,
})
