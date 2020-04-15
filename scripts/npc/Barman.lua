--[[
    Created by mike.
    DateTime: 19.01.19 21:24
    This file is part of pixel-dungeon-remix
]]

local RPD = require "scripts/lib/revampedCommonClasses"

local mob = require"scripts/lib/mob"

local npc
local client

local hero = RPD.Dungeon.hero

local lesserPrice
local greaterPrice
local higherPrice

local dialog = function(index)
    if index == 0 then
        if client:gold() >= greaterPrice then
            if RPD.ItemFactory:itemByName("PotionOfHealing"):isKnown() then
                client:spendGold(greaterPrice)
                hero:collect(RPD.ItemFactory:itemByName("PotionOfHealing"))
                RPD.playSound("snd_gold.mp3")
                RPD.showQuestWindow( npc,RPD.textById("Barman_thanks"))
                return
            else
                RPD.showQuestWindow( npc,RPD.textById("Barman_unidentified"))
                return
            end
        end
        RPD.showQuestWindow( npc,RPD.textById("Barman_no_money"))
    end

    if index == 1 then
        if client:gold() >= higherPrice then
            client:spendGold(higherPrice)
            hero:collect(RPD.ItemFactory:itemByName("ManaPotion"))
            RPD.playSound("snd_gold.mp3")
            RPD.showQuestWindow( npc,RPD.textById("Barman_thanks"))
            return
        end
        RPD.showQuestWindow( npc,RPD.textById("Barman_no_money"))
    end

    if index == 2 then
        if client:gold() >= lesserPrice then
            client:spendGold(lesserPrice)
            hero:collect(RPD.ItemFactory:itemByName("ChargrilledMeat"))
            RPD.playSound("snd_gold.mp3")
            RPD.showQuestWindow( npc,RPD.textById("Barman_thanks"))
            return
        end
        RPD.showQuestWindow( npc,RPD.textById("Barman_no_money"))
    end

    if index == 3 then
        if client:gold() >= higherPrice then
            client:spendGold(higherPrice)
            hero:collect(RPD.ItemFactory:itemByName("FriedFish"))
            RPD.playSound("snd_gold.mp3")
            RPD.showQuestWindow( npc,RPD.textById("Barman_thanks"))
            return
        end
        RPD.showQuestWindow( npc,RPD.textById("Barman_no_money"))
    end

    if index == 4 then
        RPD.showQuestWindow( npc,RPD.textById("Barman_bye"))
    end
end

return mob.init({
    interact = function(self, chr)
        client = chr
        npc = self
        local item = hero:getBelongings():getItem("RingOfHaggler")
        local item1 = RPD.ItemFactory:itemByName("ManaPotion"):name()
        local item2 = RPD.ItemFactory:itemByName("ChargrilledMeat"):name()
        local item3 = RPD.ItemFactory:itemByName("FriedFish"):name()

        lesserPrice = 100
        greaterPrice = 200
        higherPrice = 300

        if client:gold() <= 100 then
            lesserPrice = 84
        end
        if client:gold() <= 200 then
            greaterPrice = 114
        end
        if client:gold() <= 300 then
            higherPrice = 214
        end
        if item and item:isEquipped(hero) then
            lesserPrice = lesserPrice/2
            greaterPrice = greaterPrice/2
            higherPrice = higherPrice/2
        end

        RPD.chooseOption( dialog,
            "Barman_title",
            "Barman_text",
            RPD.textById("Barman_buyPotion1"):format(greaterPrice),
            RPD.textById("Barman_buy"):format(item1, higherPrice),
            RPD.textById("Barman_buy"):format(item2, lesserPrice),
            RPD.textById("Barman_buy"):format(item3, higherPrice),
            "Barman_leave"
        )
    end,

    spawn = function(self, level)
        RPD.permanentBuff(self, "DmgImmune")
    end,
})