--
-- User: mike
-- Date: 25.11.2017
-- Time: 22:56
-- This file is part of Remixed Pixel Dungeon.
--

local RPD = require "scripts/lib/revampedCommonClasses"

local mob = require"scripts/lib/mob"

local quest = require"scripts/lib/quest"

local client

local questName = "Kill Mobs"

return mob.init({
    interact = function(self, chr)
        client = chr
        if not quest.isGiven(questName) then
            RPD.showQuestWindow(self, "Hi adventurer! I need you to kill 50 of each of these mobs\n"..RPD.MobFactory:mobByName("Rat"):name().."s,\n"..RPD.MobFactory:mobByName("Albino"):name().."s,\n"..RPD.MobFactory:mobByName("Gnoll"):name().."s,\n"..RPD.MobFactory:mobByName("Skeleton"):name().."s,\nand "..RPD.MobFactory:mobByName("Thief"):name().."s.")
            RPD.Journal:add(self:name().." "..questName)
            quest.give(questName,self,  {kills={"Rat","Albino","Gnoll","Skeleton","Thief"}})
            quest.debug(true)
            return
        end

        if quest.isCompleted(questName) then
            RPD.showQuestWindow(self, "Thank you so much!")
            return
        end

        local ratsKilled = quest.state(questName).kills.Rat or 0
        local alratsKilled = quest.state(questName).kills.Albino or 0
        local gnollsKilled = quest.state(questName).kills.Gnoll or 0
        local skeletonsKilled = quest.state(questName).kills.Skeleton or 0
        local theifsKilled = quest.state(questName).kills.Thief or 0

        if ratsKilled < 50 and alratsKilled < 50 and gnollsKilled < 50 and skeletonsKilled < 50 and theifsKilled < 50 then
            RPD.showQuestWindow(self, ratsKilled.." out of 50 "..RPD.MobFactory:mobByName("Rat"):name().."s killed so far,\n"..alratsKilled.." out of 50 "..RPD.MobFactory:mobByName("Albino"):name().."s killed so far,\n"..gnollsKilled.." out of 50 "..RPD.MobFactory:mobByName("Gnoll"):name().."s killed so far,\n"..skeletonsKilled.." out of 50 "..RPD.MobFactory:mobByName("Skeleton"):name().."s killed so far,\nand "..theifsKilled.." out of 50 "..RPD.MobFactory:mobByName("Thief"):name().."s killed so far, keep going!")
        else
            RPD.showQuestWindow(self, "Great Work! Here's your reward!")
            RPD.Journal:remove(self:name().." "..questName)
            hero:collect(RPD.item("Gold", 1000000))
            quest.complete(questName)
        end
        quest.debug(true)
    end,

    spawn = function(self, level)
        RPD.permanentBuff(self, "DmgImmune")
    end,
})
