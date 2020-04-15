--
-- User: mike
-- Date: 23.11.2017
-- Time: 21:04
-- This file is part of Remixed Pixel Dungeon.
--

local RPD = require "scripts/lib/revampedCommonClasses"
local mob = require"scripts/lib/mob"

local Potions = {"ManaPotion","PotionOfMindVision","PotionOfLevitation","PotionOfExperience","PotionOfInvisibility","PotionOfMight","PotionOfToxicGas"}
local PotionAmount
local Scrolls = {"BlankScroll","ScrollOfUpgrade","ScrollOfMagicMapping","ScrollOfCurse","ScrollOfChallenge","ScrollOfPsionicBlast","ScrollOfWipeOut","ScrollOfReturning"}
local ScrollAmount
local Wands = {"WandOfBlink","WandOfAvalanche","WandOfShadowbolt","WandOfAmok"}
local Rings = {"RingOfPower","RingOfAccuracy","RingOfEvasion"}
local Items = {"SpecialSummon","UltimateCatchingCapsule","OldBandage"}
local ItemAmount

local portal = {kind="PortalGateSender",target={levelId="inn",x=14,y=10}}

return mob.init({
    die = function(self, cause)
        local level = RPD.Dungeon.level
        local levelId = RPD.Dungeon.levelId
        local cellPos = self:getPos()
        local Chasm = {[0]=true,[43]=true,[44]=true,[45]=true,[46]=true}
        local target
        for i = 0, level:getLength()-1 do 
            if levelId == "nightmareFinal" then
                if Chasm[level.map[i]] then
                    level:set(i-1, 1)
                    RPD.GameScene:updateMap()
                end
                RPD.createLevelObject(portal, cause:getPos())
            end
            target = RPD.Actor:findChar(i)
            if target then
                if target ~= RPD.Dungeon.hero then
                    if target:getMobClassName() == "NightmareClone" then
                        target:damage(target:hp(), cause)
                    end
                end
            end
        end
        for i = 1, 3 do
            PotionAmount = math.random(2,7)
            local ranPots = math.random(1,#Potions)
            if Potions[ranPots] == "ManaPotion" or Potions[ranPots] == "PotionOfExperience" or Potions[ranPots] == "PotionOfStrength" or Potions[ranPot] == "PotionOfMight" then
                local item = RPD.createItem(Potions[ranPots], {quanity=PotionAmount})
                level:drop(item, cellPos)
            else
                local item = RPD.createItem(Potions[ranPots], {level=PotionAmount*2,quanity=PotionAmount})
                level:drop(item, cellPos)
            end
            ScrollAmount = math.random(2,6)
            local ranScr = math.random(1,#Scrolls-2)
            if Scrolls[ranScr] == "BlankScroll" or Scrolls[ranScr] == "ScrollOfCurse" then
                ScrollAmount = ScrollAmount*2
            end
            if Scrolls[ranScr] == "ScrollOfUpgrade" or Scrolls[ranScr] == "ScrollOfPsionicBlast" then
                ScrollAmount = ScrollAmount/2
            end
            level:drop(RPD.item(Scrolls[ranScr], ScrollAmount), cellPos)
            local ranRin = math.random(1,#Rings)
            level:drop(RPD.createItem(Rings[ranRin], {level=ScrollAmount*2}), cellPos)
            local ranWan = math.random(1,#Wands)
            if Wands[ranWan] == "WandOfAvalanche" then
                ScrollAmount = ScrollAmount*2
            end
            level:drop(RPD.createItem(Wands[ranWan], {level=ScrollAmount}), cellPos)
            if i == 3 then
                level:drop(RPD.item(Items[2]), cellPos)
            end
        end
        ItemAmount = math.random(2,28)
        level:drop(RPD.item(Items[3], ItemAmount/2), cellPos)
        level:drop(RPD.createItem(Items[1], {level=ItemAmount/2}), cellPos)
        level:drop(RPD.item(Scrolls[7]), cellPos)
        level:drop(RPD.createItem(Scrolls[8], {quantity=math.random(1,3)}), cellPos)
    end,

    defenceProc = function(self, enemy, dmg)
        local dmgMod1 = 1
        local dmgMod2 = 1
        if enemy:buffLevel("Blesses") > 0 or enemy:buffLevel("Light") > 0 then
            local targetBlessed = true
        else
            local targetBlessed = false
        end
        if enemy:buffLevel("Blindness") > 0 or enemy:buffLevel("Terror") > 0 or enemy:buffLevel("Sleep") or enemy:buffLevel("Shadows") or enemy:buffLevel("Weakness") then
            local targetCursed = true
        else
            local targetCursed = false
        end
        if targetBlessed then
            dmgMod1 = 2
        end
        if targetCursed then
            dmgMod2 = 2
        end
        return self:damage(dmg*dmgMod1/dmgMod2, enemy)
    end,

    zapProc = function(self, enemy, dmg)
        local dmgMod1 = 1
        local dmgMod2 = 1
        if enemy then
            local time = math.random(42,67)
            if enemy:buffLevel("Blessed") > 0 or enemy:buffLevel("Light") > 0 then
                local targetBlessed = true
            else
                local targetBlessed = false
            end
            if enemy:buffLevel("Blindness") > 0 or enemy:buffLevel("Terror") > 0 or enemy:buffLevel("Sleep") or enemy:buffLevel("Shadows") or enemy:buffLevel("Weakness") then
                local targetCursed = true
            else
                local targetCursed = false
            end
            RPD.affectBuff(enemy, RPD.Buffs.Blindness, time/2)
            RPD.affectBuff(enemy, RPD.Buffs.Ooze, time/3)
            if math.random(1,100) <= 55 then
                RPD.affectBuff(enemy, RPD.Buffs.Sleep, time/5)
            else
                RPD.affectBuff(enemy, RPD.Buffs.Necrotism, time/2)
            end
        end
        if targetBlessed then
            dmgMod1 = 2
        end
        if targetCursed then
            dmgMod2 = 2
        end
        return enemy:damage(dmg*dmgMod2/dmgMod1, self)
    end,

    attackProc = function(self, enemy, dmg)
        local dmgMod1 = 1
        local dmgMod2 = 1
        if enemy then
            local time = math.random(42,67)
            if enemy:buffLevel("Blessed") > 0 or enemy:buffLevel("Light") > 0 then
                local targetBlessed = true
            else
                local targetBlessed = false
            end
            if enemy:buffLevel("Blindness") > 0 or enemy:buffLevel("Terror") > 0 or enemy:buffLevel("Sleep") or enemy:buffLevel("Shadows") or enemy:buffLevel("Weakness") then
                local targetCursed = true
            else
                local targetCursed = false
            end
            RPD.affectBuff(enemy, RPD.Buffs.Blindness, time/2)
            RPD.affectBuff(enemy, RPD.Buffs.Ooze, time/3)
            if math.random(1,100) <= 55 then
                RPD.affectBuff(enemy, RPD.Buffs.Paralysis, time/8)
            else
                RPD.affectBuff(enemy, RPD.Buffs.Necrotism, time/2)
            end
        end
        if targetBlessed then
            dmgMod1 = 2
        end
        if targetCursed then
            dmgMod2 = 2
        end
        return enemy:damage(dmg*dmgMod2/dmgMod1, self)
    end,

    stats = function(self)
        self:immunities():add(RPD.Blobs)
        self:immunities():add(RPD.Glyphs)
        self:immunities():add(RPD.Enchantments)
        self:immunities():add(RPD.PseudoBlobs)
        self:immunities():add(RPD.Buffs.Paralysis)
        self:immunities():add(RPD.Buffs.Vertigo)
        self:immunities():add(RPD.Buffs.Invisibility)
        self:immunities():add(RPD.Buffs.Hunger)
        self:immunities():add(RPD.Buffs.Poison)
        self:immunities():add(RPD.Buffs.Frost)
        self:immunities():add(RPD.Buffs.Light)
        self:immunities():add(RPD.Buffs.Cripple)
        self:immunities():add(RPD.Buffs.Charm)
        self:immunities():add(RPD.Buffs.Blessed)
        self:immunities():add(RPD.Buffs.MindVision)
        self:immunities():add(RPD.Buffs.Necrotism)
        self:immunities():add(RPD.Buffs.RageBuff)
        self:immunities():add(RPD.Buffs.Amok)
        self:immunities():add(RPD.Buffs.Awareness)
        self:immunities():add(RPD.Buffs.Barkskin)
        self:immunities():add(RPD.Buffs.Sleep)
        self:immunities():add(RPD.Buffs.Slow)
        self:immunities():add(RPD.Buffs.Blindness)
        self:immunities():add(RPD.Buffs.Burning)
        self:immunities():add(RPD.Buffs.Fury)
        self:immunities():add(RPD.Buffs.Ooze)
        self:immunities():add(RPD.Buffs.Combo)
        self:immunities():add(RPD.Buffs.Speed)
        self:immunities():add(RPD.Buffs.Terror)
        self:immunities():add(RPD.Buffs.Shadows)
        self:immunities():add(RPD.Buffs.Bleeding)
        self:immunities():add(RPD.Buffs.Weakness)
        self:immunities():add(RPD.Buffs.SnipersMark)
        self:immunities():add(RPD.Buffs.Regeneration)
        self:immunities():add(RPD.Buffs.CandleMineVision)
        self:immunities():add("NecroShieldLeft")
        self:immunities():add("SubZero")
        self:immunities():add("Charmful")
        self:immunities():add("BlazingFiery")
        self:immunities():add("Nightmare")
        self:immunities():add("FairySpell")
        self:immunities():add(RPD.ItemFactory:itemByName("WandOfShadowbolt"))
        self:immunities():add(RPD.ItemFactory:itemByName("WandOfFirebolt"))
        self:immunities():add(RPD.ItemFactory:itemByName("WandOfIcebolt"))
        self:immunities():add(RPD.ItemFactory:itemByName("WandOfAvalanche"))
        self:immunities():add(RPD.ItemFactory:itemByName("WandOfShadowbolt"))
        self:immunities():add(RPD.ItemFactory:itemByName("WandOfDisintegration"))
        self:immunities():add(RPD.ItemFactory:itemByName("ScrollOfTerror"))
        self:immunities():add(RPD.ItemFactory:itemByName("ScrollOfPsionicBlast"))
        self:immunities():add(RPD.ItemFactory:itemByName("ScrollOfWipeOut"))
        RPD.permanentBuff(self, RPD.Buffs.Roots)
    end,

    act = function(self)
        local level = RPD.Dungeon.level
        local hero = RPD.Dungeon.hero
        local iterator = level.mobs:iterator()
        local effect = 0
        RPD.permanentBuff(self, RPD.Buffs.Roots)
        while iterator:hasNext() do
            local mob = iterator:next()
            if mob == hero then
                effect = effect+1
            elseif mob:getEntityKind() ~= "CeaselessVoid" and mob:getEntityKind() ~= "NightmareClone" then
                effect = effect+1
            end
            if effect > 0 then
                RPD.permanentBuff(mob, "Nightmare")
                RPD.permanentBuff(mob, RPD.Buffs.Roots)
                effect = 0
            end
        end
        if math.random(1,100) <= 36 then
            local pos = math.random(level:getLength())-1
            if level:cellValid(pos) then
                self:getSprite():emitter():burst(RPD.Sfx.ShadowParticle.CURSE, 6)
                self:placeTo(pos)
                self:getSprite():place(pos)
            end
        end
        if math.random(1,100) <= 27 then
            local mob = RPD.MobFactory:mobByName("NightmareClone")
            local pos = math.random(level:getLength())-1
            mob:setPos(pos)
            RPD.setAi(mob, tostring(self:getState():getTag()))
            if level:cellValid(pos) then
                level:spawnMob(mob)
            end
        end
    end
})