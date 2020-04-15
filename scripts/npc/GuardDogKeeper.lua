--[[
    Created by mike.
    DateTime: 19.01.19 21:24
    This file is part of pixel-dungeon-remix
]]

local RPD = require "scripts/lib/revampedCommonClasses"

local mob = require"scripts/lib/mob"

local npc
local client

local hero
local level
local selMob

local normalPrice
local strengthenedPrice
local bestPrice

local dialog = function(index)
    if index == 0 then
        if client:gold() >= normalPrice then
            local pos = level:getEmptyCellNextTo(hero:getPos())
            if level:cellValid(pos) then
                client:spendGold(normalPrice)
                RPD.setAi(selMob, "Wandering")
                selMob:setPos(pos)
                selMob:makePet(selMob, hero)
                level:spawnMob(selMob)
                RPD.playSound("snd_gold.mp3")
                RPD.showQuestWindow(npc, RPD.textById("Guard_DogBought"):format("a "..selMob:getName()))
                return
            else
                RPD.showQuestWindow(npc, RPD.textById("Guard_NoSpace"):format("a "..selMob:getName()))
                return
            end
        end
        RPD.showQuestWindow(npc, RPD.textById("Guard_NoMoney"):format("a "..selMob:getName()))
    end

    if index == 1 then
        if client:gold() >= strengthendPrice then
            local pos = level:getEmptyCellNextTo(hero:getPos())
            if level:cellValid(pos) then
                client:spendGold(strengthendPrice)
                RPD.setAi(selMob, "Wandering")
                selMob:setPos(pos)
                selMob:ht(25)
                selMob:hp(selMob:ht())
                selMob:makePet(selMob, hero)
                level:spawnMob(selMob)
                RPD.playSound("snd_gold.mp3")
                RPD.showQuestWindow(npc, RPD.textById("Guard_DogBought"):format("one of my better "..selMob:getName().."'s"))
                return
            else
                RPD.showQuestWindow(npc, RPD.textById("Guard_NoSpace"):format("one of my better "..selMob:getName().."'s"))
                return
            end
        end
        RPD.showQuestWindow(npc, RPD.textById("Guard_NoMoney"):format("one of my better "..selMob:getName().."'s"))
    end

    if index == 2 then
        if client:gold() >= bestPrice then
            local pos = level:getEmptyCellNextTo(hero:getPos())
            if level:cellValid(pos) then
                client:spendGold(bestPrice)
                RPD.setAi(selMob, "Wandering")
                selMob:setPos(pos)
                selMob:ht(35)
                selMob:hp(selMob:ht())
                selMob:makePet(selMob, hero)
                level:spawnMob(selMob)
                RPD.playSound("snd_gold.mp3")
                RPD.showQuestWindow(npc, RPD.textById("Guard_DogBought"):format("one of my best "..selMob:getName().."'s"))
                return
            else
                RPD.showQuestWindow(npc, RPD.textById("Guard_NoSpace"):format("one of my best "..selMob:getName().."'s"))
                return
            end
        end
        RPD.showQuestWindow(npc, RPD.textById("Guard_NoMoney"):format("one of my best "..selMob:getName().."'s"))
    end

    if index == 3 then
        RPD.showQuestWindow(npc, RPD.textById("Guard_Bye"):format(selMob:getName()))
    end
end

return mob.init({
    interact = function(self, chr)
        hero = RPD.Dungeon.hero
        level = RPD.Dungeon.level
        selMob = RPD.MobFactory:mobByName("CockerSpaniel")
        client = chr
        npc = self

        normalPrice = 35
        strengthendPrice = 50
        bestPrice = 125

        if client:gold() <= 50 then
            greaterPrice = 47
        end
        if client:gold() <= 100 then
            bestPrice = 108
        end

        RPD.chooseOption( dialog,
            "Guard_title",
            "Guard_text",
            RPD.textById("Guard_BuyDog"):format(selMob:getName(), normalPrice),
            RPD.textById("Guard_BuyDog"):format(selMob:getName(), strengthendPrice),
            RPD.textById("Guard_BuyDog"):format(selMob:getName(), bestPrice),
            "Guard_leave"
        )
    end,

    spawn = function(self, level)
        RPD.permanentBuff(self, "DmgImmune")
    end,
})