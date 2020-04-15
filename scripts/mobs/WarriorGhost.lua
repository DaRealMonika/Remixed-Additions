--
-- User: mike
-- Date: 23.11.2017
-- Time: 21:04
-- This file is part of Remixed Pixel Dungeon.
--

local RPD = require "scripts/lib/revampedCommonClasses"
local mob = require"scripts/lib/mob"

local Potions = {"ManaPotion","PotionOfLiquidFlame","PotionOfLevitation","PotionOfExperience","PotionOfStrength","PotionOfMight","PotionOfMindVision"}
local PotionAmount
local Scrolls = {"BlankScroll","ScrollOfWeaponUpgrade","ScrollOfUpgrade","ScrollOfMagicMapping","ScrollOfCurse","ScrollOfTerror","ScrollOfChallenge","ScrollOfPsionicBlast","ScrollOfWipeOut"}
local ScrollAmount
local Rings = {"RingOfPower","RingOfAccuracy","RingOfEvasion","RingOfMending","RingOfElements","BlazingRing"}
local Items = {"SpecialSummon","UltimateCatchingCapsule","Dart","OldBandage","ScrollOfReturning"}
local ItemAmount

return mob.init({
    die = function(self, cause)
        local level = RPD.Dungeon.level
        local cellPos = RPD.getXy(self)
        RPD.Actor:remove(RPD.new(RPD.Objects.Actors.ScriptedActor,"scripts/actors/Bosses/BoneDragon"))
        local function deathDmg(cell)
            local target = RPD.Actor:findChar(cell)
            if target then
                target:damage(math.random(25,40), self)
                RPD.affectBuff(target, RPD.Buffs.Paralysis, math.random(18,24))
                RPD.affectBuff(target, RPD.Buffs.Cripple, math.random(18,24))
                RPD.affectBuff(target, RPD.Buffs.Necrotism, math.random(18,24))
                RPD.affectBuff(target, RPD.Buffs.Weakness, math.random(18,24))
                RPD.affectBuff(target, RPD.Buffs.Bleeding, math.random(18,24))
                RPD.affectBuff(target, RPD.Buffs.Slow, math.random(18,24))
            end
        end
        RPD.forCellsAround(cellPos, deathDmg)
        RPD.forCellsAround(level:cell(cellPos[1]-1,cellPos[2]-1), deathDmg)
        RPD.forCellsAround(level:cell(cellPos[1]+1,cellPos[2]-1), deathDmg)
        RPD.forCellsAround(level:cell(cellPos[1]-1,cellPos[2]+1), deathDmg)
        RPD.forCellsAround(level:cell(cellPos[1]+1,cellPos[2]+1), deathDmg)
        RPD.createLevelObject(tombPortal, level:cell(7,2))
        RPD.createLevelObject(townPortal, level:cell(4,6))
        RPD.createLevelObject(desertTownPortal, level:cell(10,6))
        RPD.createLevelObject(sign, level:cell(7,6))
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
            local ranScr = math.random(1,#Scrolls-1)
            level:drop(RPD.item(Scrolls[ranScr], ScrollAmount), self:getPos())
            local ranRin = math.random(1,#Rings-1)
            level:drop(RPD.createItem(Rings[ranRin], {level=ScrollAmount*2}), self:getPos())
            if i ~= 3 then
                level:drop(RPD.item(Items[2]), self:getPos())
            end
        end
        ItemAmount = math.random(2,28)
        level:drop(RPD.item(Items[3], ItemAmount/2), self:getPos())
        level:drop(RPD.item(Items[4], ItemAmount), self:getPos())
        level:drop(RPD.item(Items[1]), self:getPos())
        level:drop(RPD.item(Items[5]), self:getPos())
        level:drop(RPD.item(Scrolls[#Scrolls], 5), self:getPos())
        level:drop(RPD.item(Rings[#Rings]), self:getPos())
        level:set(level:cell(7,11), 7)
        RPD.GameScene:updateMap()
    end,

    defenceProc = function(self, enemy, dmg)
        local level = RPD.Dungeon.level
        if enemy then
            if enemy:getEntityKind() == "CockerSpaniel" then
                return self:damage(dmg*3, enemy)
            end
        end
        if math.random(1,100) <= 5 then
            level:addScriptedActor(RPD.new(RPD.Objects.Actors.ScriptedActor,"scripts/actors/Bosses/BoneDragon"))
        end
        return self:damage(dmg, enemy)
    end,

    zapProc = function(self, enemy, dmg)
        local level = RPD.Dungeon.level
        if enemy then
            local time = math.random(30,47)
            if enemy:buffLevel("Burning") > 0 or enemy:buffLevel("BlazingFiery") > 0 then
                local dmgMod = true
            else
                local dmgMod = false
            end
            RPD.affectBuff(enemy, RPD.Buffs.Burning, time)
            RPD.affectBuff(enemy, RPD.Buffs.Light, time)
            RPD.placeBlob(RPD.Blobs.LiquidFlame, enemy:getPos(), 25)
            RPD.placeBlob(RPD.Blobs.Fire, enemy:getPos(), 25)
            if dmgMod then
                return enemy:damage(dmg*4, self)
            end
        end
        return enemy:damage(dmg, self)
    end,

    attackProc = function(self, enemy, dmg)
        if enemy then
            local time = math.random(42,67)
            if enemy:buffLevel("Bleeding") > 0 or enemy:buffLevel("Cripple") > 0 then
                local dmgMod = true
            else
                local dmgMod = false
            end
            RPD.affectBuff(enemy, RPD.Buffs.Blindness, time/2)
            RPD.affectBuff(enemy, RPD.Buffs.Bleeding, time/3)
            if math.random(1,100) <= 75 then
                RPD.affectBuff(enemy, RPD.Buffs.Cripple, time/2)
            end
            if math.random(1,100) <= 55 then
                RPD.affectBuff(enemy, RPD.Buffs.Paralysis, time/5)
            else
                RPD.affectBuff(enemy, RPD.Buffs.Vertigo, time/2)
            end
            if math.random(1,100) <= 5 then
                RPD.affectBuff(enemy, RPD.Buffs.Necrotism, time/4)
            end
            if dmgMod then
                return enemy:damage(dmg*8, self)
            end
        end
        return enemy:damage(dmg, self)
    end,

    stats = function(self)
        self:immunities():add(RPD.Blobs)
        self:immunities():add(RPD.Glyphs)
        self:immunities():add(RPD.Enchantments)
        self:immunities():add(RPD.Spells)
        self:immunities():add("DeathlyRecruit")
        self:immunities():add(RPD.PseudoBlobs)
        self:immunities():add(RPD.Buffs.Poison)
        self:immunities():add(RPD.Buffs.Paralysis)
        self:immunities():add(RPD.Buffs.Burning)
        self:immunities():add(RPD.Buffs.Blindness)
        self:immunities():add(RPD.Buffs.Terror)
        self:immunities():add(RPD.Buffs.Amok)
        self:immunities():add(RPD.Buffs.Slow)
        self:immunities():add(RPD.Buffs.Vertigo)
        self:immunities():add(RPD.Buffs.Frost)
        self:immunities():add(RPD.Buffs.Light)
        self:immunities():add(RPD.Buffs.Blessed)
        self:immunities():add(RPD.Buffs.Charm)
        self:immunities():add(RPD.ItemFactory:itemByName("WandOfShadowbolt"))
        self:immunities():add(RPD.ItemFactory:itemByName("WandOfLightning"))
        self:immunities():add(RPD.ItemFactory:itemByName("WandOfDisintegration"))
        self:immunities():add(RPD.ItemFactory:itemByName("ScrollOfPsionicBlast"))
    end
})