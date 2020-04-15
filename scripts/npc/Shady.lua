--[[
    Created by mike.
    DateTime: 19.01.19 21:24
    This file is part of pixel-dungeon-remix
]]

local RPD = require "scripts/lib/revampedCommonClasses"
local mob = require "scripts/lib/mob"
local storage = require "scripts/lib/storage"

local npc
local client

local Swordtier2 = {"SacrificialSword"}
local Swordtier3 = {"GoldenSword","SacrificialSword"}
local Swordtier4 = {"Longsword","GoldenSword","SacrificialSword"}
local Swordtier6 = {"Claymore","Longsword","GoldenSword","SacrificialSword"}
local Bowtier1 = {"WoodenBow","WoodenCrossbow"}
local Bowtier2 = {"CompoundBow","CompositeCrossbow","WoodenBow","WoodenCrossbow"}
local Bowtier3 = {"RubyBow","RubyCrossbow","CompoundBow","CompositeCrossbow","WoodenBow","WoodenCrossbow"}
local BattleWandtier1 = {"WandOfAvalanche","WandOfFirebolt","WandOfDisintegration"}
local PassiveWandtier1 = {"WandOfFlock","WandOfRegrowth","WandOfAmok"}
local BattleWandtier2 = {"WandOfLightning","WandOfIcebolt","WandOfShadowbolt"}
local PassiveWandtier2 = {"WandOfPoison","WandOfSlowness","WandOfTeleportation"}
local MovementWand = {"WandOfBlink","WandOfTelekinesis"}

local Mobs = {"Yog","YogsEye","ShadowLord","King","DM300","Tengu","Goo"}

local currentTier

local lesserPrice
local greaterPrice
local higherPrice

for i = 1, # Mobs do
    if not storage.get(Mobs[i].." kills") then
        storage.put(Mobs[i].." kills", 0)
    end
end

local dialog = function(index)
    if index == 0 then
        if client:gold() >= higherPrice then
            local hero = RPD.Dungeon.hero
            if currentTier == "Tier 1" then
                RPD.showQuestWindow( npc,RPD.textById("Shady_noWeapon"):format("Sword for "..currentTier.."."))
            elseif currentTier == "Tier 2" then
                hero:collect(RPD.ItemFactory:itemByName(Swordtier2[1]))
            elseif currentTier == "Tier 3" then
                hero:collect(RPD.ItemFactory:itemByName(Swordtier3[math.random(1,2)]))
            elseif currentTier == "Tier 4" or currentTier == "Tier 5" then
                hero:collect(RPD.ItemFactory:itemByName(SwordTier4[math.random(1,3)]))
            elseif currentTier >= "Tier 6" or currentTier == "Any" then
                hero:collect(RPD.ItemFactory:itemByName(SwordTier6[math.random(1,4)]))
            end
            if currentTier ~= "Tier 1" then
                client:spendGold(higherPrice)
                RPD.playSound("snd_gold.mp3")
                RPD.showQuestWindow( npc,RPD.textById("Shady_thanks"))
            end
            return
        end
        RPD.showQuestWindow( npc,RPD.textById("Shady_no_money"))
    end

    if index == 1 then
        if client:gold() >= lesserPrice then
            local hero = RPD.Dungeon.hero
            local bowRandom = math.random(1,2)
            if currentTier == "Tier 1" then
                hero:collect(RPD.ItemFactory:itemByName(Bowtier1[math.random(1,2)]))
            elseif currentTier == "Tier 2" then
                hero:collect(RPD.ItemFactory:itemByName(Bowtier2[math.random(1,4)]))
            elseif currentTier == "Tier 3" or currentTier == "Tier 4" or currentTier == "Tier 5" or currentTier == "Tier 4"  or currentTier == "Any" then
                hero:collect(RPD.ItemFactory:itemByName(Bowtier3[math.random(1,6)]))
            end
            client:spendGold(lesserPrice)
            RPD.playSound("snd_gold.mp3")
            RPD.showQuestWindow( npc,RPD.textById("Shady_thanks"))
            return
        end
        RPD.showQuestWindow( npc,RPD.textById("Shady_no_money"))
    end

    if index == 2 then
        if client:gold() >= greaterPrice then
            local hero = RPD.Dungeon.hero
            local wandType = {"Battle","Passive","Movement"}
            local wandSel = math.random(1,3)
            local wandRandom = math.random(1,2)
            if wandType[wandSel] == "Movement" then
                hero:collect(RPD.ItemFactory:itemByName(MovementWand[math.random(1,2)]))
            elseif currentTier == "Tier 1" then
                if wandType[wandSel] == "Battle" then
                    hero:collect(RPD.ItemFactory:itemByName(BattleWandtier1[math.random(1,3)]))
                elseif wandType[wamdSel] == "Passive" then
                    hero:collect(RPD.ItemFactory:itemByName(PassiveWandtier1[math.random(1,3)]))
                end
            elseif currentTier >= "Tier 2" then
                if wandType[wandSel] == "Battle" then
                    if wandRandom == 1 then
                        hero:collect(RPD.ItemFactory:itemByName(BattleWandtier1[math.random(1,3)]))
                    elseif wandRandom == 2 then
                        hero:collect(RPD.ItemFactory:itemByName(BattleWandtier2[math.random(1,3)]))
                    end
                elseif wandType[wandSel] == "Passive" then
                    if wandRandom == 1 then
                        hero:collect(RPD.ItemFactory:itemByName(PassiveWandtier1[math.random(1,3)]))
                    elseif wandRandom == 2 then
                        hero:collect(RPD.ItemFactory:itemByName(PassiveWandtier2[math.random(1,3)]))
                    end
                end
            elseif currentTier == "Any" then
                if wandRandom == 1 then
                    if wandType[wandSel] == "Battle" then
                        hero:collect(RPD.ItemFactory:itemByName(BattleWandtier1[math.random(1,3)]))
                    elseif wandType[wandSel] == "Passive" then
                        hero:collect(RPD.ItemFactory:itemByName(PassiveWandtier2[math.random(1,3)]))
                    end
                elseif wandRandom == 2 then
                    if wandType[wandSel] == "Battle" then
                        hero:collect(RPD.ItemFactory:itemByName(BattleWandtier2[math.random(1,3)]))
                    elseif wandType[wandSel] == "Passive" then
                        hero:collect(RPD.ItemFactory:itemByName(PassiveWandtier2[math.random(1,3)]))
                    end
                end
            end
            client:spendGold(greaterPrice)
            RPD.playSound("snd_gold.mp3")
            RPD.showQuestWindow( npc,RPD.textById("Shady_thanks"))
            return
        end
        RPD.showQuestWindow( npc,RPD.textById("Shady_no_money"))
    end

    if index == 3 then
        RPD.showQuestWindow( npc,RPD.textById("Shady_bye"))
    end
end

return mob.init({
    interact = function(self, chr)
        client = chr
        npc = self
        RPD.showQuestWindow(npc, RPD.textById("NotFinished_text"))

--[[        currentTier = "Tier 1"
        if storage.get("Goo kills") then
            currentTier = "Tier 2"
        end
        if storage.get("Tengu kills") then
            currentTier = "Tier 3"
        end
        if storage.get("DM300 kills") then
            currentTier = "Tier 4"
        end
        if storage.get("King kills") then
            currentTier = "Tier 5"
        end
        if storage.get("ShadowLord kills") then
            currentTier = "Tier 6"
        end
        if storage.get("Yog kills") > 0 or storage.get("YogsEye kills") > 0 then
            currentTier = "Any"
        end

        lesserPrice = 100
        greaterPrice = 200
        higherPrice = 300

        RPD.chooseOption( dialog,
            "Shady_title",
            "Shady_text",
            RPD.textById("Shady_buySword"):format(currentTier,higherPrice),
            RPD.textById("Shady_buyBow"):format(currentTier,lesserPrice),
            RPD.textById("Shady_buyWand"):format(currentTier,greaterPrice),
            "Shady_leave"
            )]]
    end,

    die = function(self, cause)
        local hero = RPD.Dungeon.hero
        RPD.zapEffect(self:getPos(), hero:getPos(), "Lightning")
        hero:damage(hero:hp()-1, hero)
        hero:getSprite():emitter():burst(RPD.Sfx.ShadowParticle.CURSE, 6)
        RPD.playSound("snd_cursed.mp3")
    end,

    spawn = function(self, level)
        RPD.permanentBuff(self, "DmgImmune")
    end,
})
