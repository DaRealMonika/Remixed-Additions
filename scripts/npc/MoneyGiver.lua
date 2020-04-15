--[[
    Created by mike.
    DateTime: 19.01.19 21:24
    This file is part of pixel-dungeon-remix
]]

local RPD = require "scripts/lib/revampedCommonClasses"

local mob = require"scripts/lib/mob"

local npc
local client

local Potions = {"PotionOfExperience","PotionOfPurity","PotionOfToxicGas","PotionOfFrost","PotionOfParalyticGas","PotionOfHealing","PotionOfLiquidFlame","ManaPotion","PotionOfStrength","PotionOfMight","PotionOfInvisibility","PotionOfLevitation","PotionOfMindVision"}
local Scrolls = {"ScrollOfUpgrade","ScrollOfTerror","ScrollOfChallenge","ScrollOfLullaby","ScrollOfRemoveCurse","ScrollOfCurse","ScrollOfMirrorImage","ScrollOfPsionicBlast","ScrollOfIdentify","ScrollOfDomination","ScrollOfSummoning","ScrollOfRecharging","ScrollOfTeleportation","ScrollOfWeaponUpgrade","ScrollOfMagicMapping","BlankScroll"}
local Wands = {"WandOfMagicMissile","WandOfPoison","WandOfBlink","WandOfSlowness","WandOfFirebolt","WandOfIcebolt","WandOfFlock","WandOfLightning","WandOfTelekinesis","WandOfDisintegration","WandOfTeleportation","WandOfAmok","WandOfAvalanche","WandOfRegrowth","WandOfShadowbolt"}
local Food = {--[["Ration","OverpricedRation","RottenRation","Pasty","RottenPasty","Candy","PumpkinPie","PseudoPasty","ChristmasTurkey","RottenPumpkinPie","ChargrilledMeat","FriedFish",]]"MysteryMeat","RawFish","FrozenCarpaccio","FrozenFish"}
local Modded = {"test/TestItem","MagicGun","CharmingRing","BlazingRing","SpecialSummon","TestingItem","TestMeleeWeapon","Board","OldShield","NecroticShield","ScrollOfReturning","CatchingCapsule","UltimateCatchingCapsule","Bandage","OldBandage","CactusFruit","NightmareEye","CrystallizedFlower","FrozenFlame"}
local Removed = {"RingOfStoneWalking","RingOfFrost","LloydsBeacon","ScrollOfWipeOut","HookedDagger"}

local dialog = function(index)
    if index == 0 then
        local toObtain
        local amount = 2^31-1
        if client:gold() == amount then
            RPD.showQuestWindow( npc,"You already have maximum Money")
            return
        elseif client:gold() < amount then
            toObtain = amount - client:gold()
            client:spendGold(-toObtain)
        end
        RPD.showQuestWindow( npc,"Gave you up to maximum Money")
    end
    
    if index == 1 then
        if client:gold() > 0 then
            client:spendGold(client:gold())
            RPD.showQuestWindow( npc,"Removed all of your Money")
            return
        end
        RPD.showQuestWindow( npc,"No money to Remove")
    end

    if index == 2 then
        local hero = RPD.Dungeon.hero
        local pets = 0
        local heal = 0
        local mobs = RPD.Dungeon.level.mobs
        local iterator = mobs:iterator()
        if hero:hp() ~= 1 then
            hero:damage(hero:hp()-1, npc)
        else
            hero:heal(hero:ht(), npc)
            heal = heal+1
        end
        while iterator:hasNext() do
            local mob = iterator:next()
            if mob:isPet() then
                if mob:hp() ~= 1 then
                    mob:damage(mob:hp()-1, npc)
                else
                    mob:heal(mob:ht(), npc)
                    heal = heal+1
                end
                pets = pets+1
            end
        end
        if pets > 0 then
            if heal == 0 then
                RPD.showQuestWindow( npc,"Damaged you and your pets.")
            else
                RPD.showQuestWindow( npc,"Healed you and your pets.")
            end
        else
            if heal == 0 then
                RPD.showQuestWindow( npc,"Damaged you.")
            else
                RPD.showQuestWindow( npc,"Healed you.")
            end
        end
    end

    if index == 3 then
        local hero = RPD.Dungeon.hero
        hero:lvl(10000)
        hero:ht(10000)
        hero:hp(hero:ht())
        hero:STR(2^31-1)
        RPD.showQuestWindow( npc,"Set everything of to "..tostring(2^31-1)..".")
    end

    if index == 4 then
        local hero = RPD.Dungeon.hero
        local bags = 0
        if not hero:getBelongings():getItem("PotionBelt") then
            hero:collect(RPD.ItemFactory:itemByName("PotionBelt"))
            bags = bags+1
        end
        if not hero:getBelongings():getItem("Keyring") then
            hero:collect(RPD.ItemFactory:itemByName("Keyring"))
            bags = bags+1
        end
        if not hero:getBelongings():getItem("ScrollHolder") then
            hero:collect(RPD.ItemFactory:itemByName("ScrollHolder"))
            bags = bags+1
        end
        if not hero:getBelongings():getItem("WandHolster") then
            hero:collect(RPD.ItemFactory:itemByName("WandHolster"))
            bags = bags+1
        end
        if not hero:getBelongings():getItem("Quiver") then
            hero:collect(RPD.ItemFactory:itemByName("Quiver"))
            bags = bags+1
        end
        if not hero:getBelongings():getItem("SeedPouch") then
            hero:collect(RPD.ItemFactory:itemByName("SeedPouch"))
            bags = bags+1
        end
        if bags > 0 then
            RPD.showQuestWindow( npc,"Gave you all of the Bags.")
        elseif bags <= 0 then
            RPD.showQuestWindow( npc,"You already have all of the bags")
        end
    end

    if index == 5 then
        local hero = RPD.Dungeon.hero
        RPD.showQuestWindow( npc,hero:getPets())
    end

    if index == 6 then
        RPD.showQuestWindow( npc,"Bye")
    end

    if index == 7 then
        local hero = RPD.Dungeon.hero
        if not hero:getBelongings():getItem("PotionBelt") then
            hero:collect(RPD.ItemFactory:itemByName("PotionBelt"))
        end
        for p = 1, #Potions do
            if Potions[p] ~= "ManaPotion" then
                RPD.ItemFactory:itemByName(Potions[p]):setKnown()
            end
            if Potions[p] == "PotionOfExperience" or Potions[p] == "PotionOfHealing" or Potions[p] == "ManaPotion" or Potions[p] == "PotionOfStrength" or Potions[p] == "PotionOfMight" then
                hero:collect(RPD.item(Potions[p], 10000))
            else
                hero:collect(RPD.createItem(Potions[p], {level=100,quantity=10000}))
            end
        end
        if not hero:getBelongings():getItem("ScrollHolder") then
            hero:collect(RPD.ItemFactory:itemByName("ScrollHolder"))
        end
        for s = 1, #Scrolls do
            hero:collect(RPD.item(Scrolls[s], 10000))
            RPD.ItemFactory:itemByName(Scrolls[s]):setKnown()
        end
        if not hero:getBelongings():getItem("WandHolster") then
            hero:collect(RPD.ItemFactory:itemByName("WandHolster"))
        end
        for w = 1, #Wands do
            local wand = RPD.createItem(Wands[w], {level=100})
            hero:collect(wand)
            wand:setKnown()
            wand:setChargeKnown(true)
        end
--[[        for f = 1, #Food do
            hero:collect(RPD.item(Food[f], 10000))
        end]]
        RPD.showQuestWindow( npc,"Gave you max of all Potions, and Scrolls and 1 of each Wand.")
    end

    if index == 8 then
        local hero = RPD.Dungeon.hero
        local added = 0
        for m = 1, #Modded do
            if not hero:getBelongings():getItem(Modded[m]) then
                if Modded[m] == "ScrollOfReturning" or Modded[m] == "CactusFruit" or Modded[m] == "Bandage" or Modded[m] == "OldBandage" or Modded[m] == "FrozenFlame" then
                    hero:collect(RPD.item(Modded[m], 10000))
                elseif Modded[m] == "UltimateCatchingCapsule" then
                    hero:collect(RPD.item(Modded[m]))
                    hero:collect(RPD.item(Modded[m]))
                    hero:collect(RPD.item(Modded[m]))
                elseif Modded[m] == "CatchingCapsule" or Modded[m] == "TestMeleeWeapon" then
                    local quantity = 3
                    for i = 1, quantity do
                        if Modded[m] == "CatchingCapsule" or (Modded[m] == "TestMeleeWeapon" and i ~= 3) then
                            hero:collect(RPD.createItem(Modded[m], {level=10000}))
                        end
                    end
                elseif Modded[m] == "MagicGun" or Modded[m] == "CharmingRing" or Modded[m] == "Board" or Modded[m] == "OldShield" or Modded[m] == "NecroticShield" then
                    hero:collect(RPD.createItem(Modded[m], {level=10000}))
                else
                    hero:collect(RPD.item(Modded[m]))
                end
                added = added+1
            end
        end
        local key = RPD.createItem("IronKey", {levelId="house2",depth=0})
        if not hero:getBelongings():getItem(key) then
            hero:collect(key)
            added = added+1
        end
        local book = RPD.createItem("Codex", {text="abandonedHouse_Info"})
        if not hero:getBelongings():getItem(book) then
            hero:collect(book)
            added = added+1
        end
        if added > 0 then
            RPD.showQuestWindow( npc,"Gave you all of the Modded Items.")
        elseif added <= 0 then
            RPD.showQuestWindow( npc,"You already have all of the modded items.\nCan't give you more of them.")
        end
    end

    if index == 9 then
        local hero = RPD.Dungeon.hero
        local added = 0
        for r = 1, #Removed do
            if not hero:getBelongings():getItem(Removed[r]) then
                if Removed[r] == "ScrollOfWipeOut" then
                    hero:collect(RPD.item(Removed[r], 10000))
                else
                    hero:collect(RPD.ItemFactory:itemByName(Removed[r]))
                end
                added = added+1
            end
        end
        if added > 0 then
            RPD.showQuestWindow( npc,"Gave you all of the \"Removed\" Items.")
        elseif added <= 0 then
            RPD.showQuestWindow( npc,"You already have all of the Removed Items.\nCan't give you more of them")
        end
    end
end


return mob.init({
    interact = function(self, chr)
        client = chr
        npc = self
        local amount = 1.79769313486232E+308d

        RPD.chooseOption( dialog,
            "Temp Money",
            "Give/Remove Money (plus other things)\nFun Fact: \"1.79769313486232E+308d\" = "..tostring(amount),
            "Give max Money",
            "Remove Money",
            "Damage/Heal you and pet(s)",
            "Set everything of you to max and hp to 10k",
            "Give all Bags",
            "Get Pets id's",
            "Bye",
            "Give all Potions, Scrolls, Wands, and Food",
            "Give all Modded Items",
            "Give all Removed Items"
        )
    end,
})
