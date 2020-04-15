--[[
    Created by mike.
    DateTime: 19.01.19 21:24
    This file is part of pixel-dungeon-remix
]]

local RPD = require "scripts/lib/revampedCommonClasses"

local mob = require"scripts/lib/mob"

local hero = RPD.Dungeon.hero
local belongings = hero:getBelongings()
local foods = {"MysteryMeat","RawFish","FrozenCarpaccio","FrozenFish"}
local cooked = {"ChargrilledMeat","FriedFish"}
return mob.init({
    interact = function(self, chr)
        local npc = self
        local interactions = math.random(0, 10)
        local selectedFood
        if interactions <= 9 then
            npc:say("Chef_text")
            return
        else
            selectedFood = math.random(1, 4)
            if belongings:getItem(foods[selectedFood]) then
            elseif belongings:getItem(foods[1]) then
                selectedFood = 1
            elseif belongings:getItem(foods[2]) then
                selectedFood = 2
            elseif belongings:getItem(foods[3]) then
                selectedFood = 3
            elseif belongings:getItem(foods[4]) then
                selectedFood = 4
            else
                RPD.showQuestWindow( npc,RPD.textById("Chef_NoFood"))
                return
            end
            belongings:getItem(foods[selectedFood]):detach(belongings.backpack)
            if selectedFood == 1 or selectedFood == 3 then
                hero:collect(RPD.ItemFactory:itemByName(cooked[1]))
            elseif selectedFood == 2 or selectedFood == 4 then
                hero:collect(RPD.ItemFactory:itemByName(cooked[2]))
            end
            RPD.showQuestWindow( npc,RPD.textById("Chef_cookedFood"):format(tostring(RPD.ItemFactory:itemByName(foods[selectedFood]))))
            RPD.playSound("snd_burning.mp3")
            return
        end
    end,

    spawn = function(self, level)
        RPD.permanentBuff(self, "DmgImmune")
    end,
})
