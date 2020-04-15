--
-- User: mike
-- Date: 23.11.2017
-- Time: 21:04
-- This file is part of Remixed Pixel Dungeon.
--

local RPD = require "scripts/lib/revampedCommonClasses"
local mob = require "scripts/lib/mob"
local storage = require "scripts/lib/storage"

local floor = {[1]=true,[2]=true,[3]=true,[5]=true,[6]=true,[7]=true,[8]=true,[9]=true,[11]=true,[14]=true,[15]=true,[17]=true,[18]=true,[19]=true,[20]=true,[21]=true,[22]=true,[23]=true,[25]=true,[26]=true,[27]=true,[28]=true,[29]=true,[30]=true,[31]=true,[32]=true,[33]=true,[34]=true,[37]=true,[38]=true,[39]=true,[40]=true,[42]=true,[47]=true,[48]=true,[49]=true,[50]=true,[51]=true,[52]=true,[53]=true,[54]=true,[55]=true,[56]=true,[57]=true,[58]=true,[59]=true,[60]=true,[61]=true,[62]=true,[63]=true}
local chasm = {[0]=true,[43]=true,[44]=true,[45]=true,[46]=true}
local Potions = {"ManaPotion","PotionOfLevitation","PotionOfExperience","PotionOfStrength","PotionOfMindVision"}
local PotionAmount
local Scrolls = {"BlankScroll","ScrollOfMagicMapping","ScrollOfRemoveCurse","ScrollOfPsionicBlast","ScrollOfWipeOut","ScrollOfReturning"}
local ScrollAmount
local Rings = {"RingOfMending","RingOfEvasion","RingOfElements","CharmingRing"}
local Items = {"SpecialSummon","UltimateCatchingCapsule","Bandage","CrystallizedFlower"}
local ItemAmount

local entity
local answered = false
local portal = {kind="PortalGateSender",target={levelId="inn",x=14,y=10}}

local dialog = function(index)
    if index == 0 then
        if entity then
            answered = true
            local hero = RPD.Dungeon.hero
            local level = RPD.Dungeon.level
            local mob = RPD.MobFactory:mobByName("FairyOverlordNPC")
            mob:setPos(entity:getPos())
            level:spawnMob(mob)
            entity:destroy()
            entity:getSprite():killAndErase()
            entity = mob
            RPD.showQuestWindow(entity,RPD.textById("FairyOverlord_Saved"):format(hero:className()))
            for i = 0, level:getLength() do
                local target = RPD.Actor:findChar(i)
                if target then
                    if target ~= hero then
                        if target:getEntityKind() == "Fairy" then
                            if not target:isPet() then
                                if math.random(1,100) <= 20 then
                                    target:damage(target:hp(), hero)
                                else
                                    local mob = RPD.MobFactory:mobByName("FairyNPC")
                                    mob:setPos(i)
                                    level:spawnMob(mob)
                                    target:destroy()
                                    target:getSprite():killAndErase()
                                end
                            end
                        end
                    end
                end
            end
            storage.put("FairyOverlord Saved", true)
            RPD.permanentBuff(hero, "FairySpell")
            RPD.BuffIndicator:refreshHero()
            if levelId == "dreamFinal" then
                level:set(level:cell(13,6), 7)
                RPD.GameScene:updateMap()
                RPD.createLevelObject(portal, hero:getPos())
            end
            hero:collect(RPD.item(Scrolls[#Scrolls]))
--            RPD.stopMusic()
--            RPD.playMusic("sound/snd_boss.mp3")
        end
    end

    if index == 1 then
        answered = true
        local hero = RPD.Dungeon.hero
        entity:damage(entity:hp(), hero)
        storage.put("FairyOverlord Saved", false)
    end
end

return mob.init({
    die = function(self, cause)
        local level = RPD.Dungeon.level
        local levelId = RPD.Dungeon.levelId
        local cellPos = self:getPos()
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
            level:drop(RPD.item(Scrolls[ranScr], ScrollAmount), cellPos)
            local ranRin = math.random(1,#Rings-1)
            level:drop(RPD.createItem(Rings[ranRin], {level=ScrollAmount*2}), cellPos)
            if i == 3 then
                level:drop(RPD.item(Items[2]), cellPos)
            end
        end
        ItemAmount = math.random(2,28)
        level:drop(RPD.item(Items[3], ItemAmount/2), cellPos)
        level:drop(RPD.createItem(Items[1], {level=ItemAmount/2}), cellPos)
        level:drop(RPD.item(Scrolls[#Scrolls-1], 5), cellPos)
        level:drop(RPD.item(Scrolls[#Scrolls]), cellPos)
        level:drop(RPD.createItem(Rings[#Rings], {level=math.random(-1,5)}), cellPos)
        level:drop(RPD.createItem(Items[4], {level=math.random(-2,3)}), cellPos)
        storage.put("FairyOverlord Saved", false)
        if levelId == "dreamFinal" then
            level:set(level:cell(13,6), 7)
            RPD.GameScene:updateMap()
            RPD.createLevelObject(portal, cause:getPos())
        end
--        RPD.stopMusic()
--        RPD.playSound("sound/snd_boss.mp3")
    end,

    defenceProc = function(self, enemy, dmg)
        local hero = RPD.Dungeon.hero
        local owner = enemy
        if enemy ~= hero then
            if enemy:getOwner() then
                owner = enemy:getOwner()
            end
        end
        if enemy == hero or owner == hero then
            if dmg >= self:hp() then
                RPD.permanentBuff(self, RPD.Buffs.Paralysis)
                entity = self
                if not answered then
                    RPD.chooseOption(dialog,
                        self:name(),
                        RPD.textById("FairyOverlord_Spare"):format(hero:className()),
                        "Yes_Option",
                        "No_Option"
                    )
                end
                return 0
            end
        end
        return self:damage(dmg, enemy)
    end,

    zapProc = function(self, enemy, dmg)
        local level = RPD.Dungeon.level
        local hero = RPD.Dungeon.hero
        local owner = enemy
        local mul = 1
        if enemy ~= hero then
            if enemy:getOwner() then
                owner = enemy:getOwner()
            end
        end
        if math.random(1,100) <= 17 then
            for i = 0, level:getLength() do
                local target = RPD.Actor:findChar(i)
                local targetOwner = target
                if target then
                    if target ~= hero then
                        if target:getOwner() then
                            targetOwner = target:getOwner()
                        end
                    end
                    if target:getEntityKind() == "Fairy" then
                        mul = 2
                    elseif target == self then
                        mul = 0.5
                    end
                    if targetOwner ~= enemy and target ~= enemy then
                        target:heal(math.random(8,14)*mul, self)
                        if target:buffLevel("Sleep") > 0 then
                            RPD.removeBuff(target, RPD.Buffs.Sleep)
                        end
                    end
                end
            end
        end
        for i = 1, math.random(2,6) do
            RPD.placeBlob(RPD.Blobs.Regrowth, math.random(level:getLength()-1), math.random(3,8))
        end
        return enemy:damage(dmg, self)
    end,

    attackProc = function(self, enemy, dmg)
        local level = RPD.Dungeon.level
        local hero = RPD.Dungeon.hero
        local owner = enemy
        if enemy ~= hero then
            if enemy:getOwner() then
                owner = enemy:getOwner()
            end
        end
        for i = 0, level:getLength() do
            local target = RPD.Actor:findChar(i)
            local targetOwner = target
            if target then
                if target ~= hero then
                    if target:getOwner() then
                        targetOwner = target:getOwner()
                    end
                end
                if targetOwner ~= enemy and target ~= enemy and target ~= self then
                    RPD.setAi(target, self:getState():getTag())
                    target:getSprite():showStatus(0xFF0000, "!!!")
                end
                if math.random(1,100) <= 23 then
                    self:heal(math.random(8,14), self)
                end
                if targetOwner == hero then
                    if math.random(1,100) <= 23 then
                        target:damage(math.random(dmg/2,dmg), self)
                        if math.random(1,100) <= 13 then
                            if math.random(1,100) <= 17 then
                                if target:buffLevel("Paralysis") > 0 then
                                    RPD.prolongBuff(target, RPD.Buffs.Paralysis, math.random(dmg/2,dmg))
                                else
                                    RPD.affectBuff(target, RPD.Buffs.Paralysis, math.rndom(dmg/2,dmg))
                                end
                            else
                                if target:buffLevel("Sleep") > 0 then
                                    RPD.prolongBuff(target, RPD.Buffs.Sleep, math.random(dmg/2,dmg))
                                else
                                    RPD.affectBuff(target, RPD.Buffs.Sleep, math.random(dmg/2,dmg))
                                end
                            end
                        end
                    end
                end
            end
        end
        return enemy:damage(dmg, self)
    end,

    spawn = function(self, mob, level)
        local level = RPD.Dungeon.level
        local levelId = RPD.Dungeon.levelId
        if levelId == "dreamFinal" then
            if level then
                level:set(level:cell(13,6), 4)
                RPD.GameScene:updateMap()
            end
        end
--        RPD.stopMusic()
--        RPD.playMusic("sound/ost_boss_1_fight", true)
    end,

    stats = function(self)
        self:immunities():add(RPD.Glyphs)
        self:immunities():add(RPD.Enchantments)
        self:immunities():add(RPD.Spells)
        self:immunities():add("DeathlyRecruit")
        self:immunities():add(RPD.PseudoBlobs)
        self:immunities():add(RPD.Buffs.Poison)
        self:immunities():add(RPD.Buffs.Paralysis)
        self:immunities():add(RPD.Buffs.Burning)
        self:immunities():add(RPD.Buffs.Terror)
        self:immunities():add(RPD.Buffs.Amok)
        self:immunities():add(RPD.Buffs.Slow)
        self:immunities():add(RPD.Buffs.Vertigo)
        self:immunities():add(RPD.Buffs.Frost)
        self:immunities():add(RPD.Buffs.Charm)
        self:immunities():add(RPD.Buffs.Roots)
        self:immunities():add(RPD.ItemFactory:itemByName("WandOfFirebolt"))
        self:immunities():add(RPD.ItemFactory:itemByName("WandOfLightning"))
        self:immunities():add(RPD.ItemFactory:itemByName("WandOfDisintegration"))
        self:immunities():add(RPD.ItemFactory:itemByName("ScrollOfPsionicBlast"))
        RPD.permanentBuff(self, RPD.Buffs.Barkskin)
    end,

    act = function(self)
        local level = RPD.Dungeon.level
        local hero = RPD.Dungeon.hero
        local emitter = RPD.Sfx.CellEmitter:get(self:getPos())
        local toSpawn
        local pos
        local mobSpawnChance = math.random(1,100)
        if math.random(1,100) <= 36 then
            local tpPos = math.random(level:getLength())-1
            local target = RPD.Actor:findChar(tpPos)
            if level:cellValid(tpPos) and (floor[level.map[tpPos]] or chasm[level.map[tpPos]]) and not target then
                emitter:burst(RPD.Sfx.EarthParticle.FACTORY, 3)
                self:placeTo(tpPos-1)
                self:getSprite():place(tpPos-1)
                emitter:burst(RPD.Sfx.EarthParticle.FACTORY, 3)
            end
        end
        if mobSpawnChance <= 16 then
            toSpawn = RPD.MobFactory:mobByName("AngryNimbus")
        elseif mobSpawnChance <= 23 then
            local mobs = {"EuropeanShorthair","CockerSpaniel"}
            toSpawn = RPD.MobFactory:mobByName(mobs[math.random(1,#mobs)])
        elseif mobSpawnChance <= 39 then
            toSpawn = RPD.MobFactory:mobByName("EarthElemental")
            toSpawn:ht(toSpawn:ht()*2)
            toSpawn:hp(toSpawn:hp()*2)
        elseif mobSpawnChance <= 45 then
            toSpawn = RPD.MobFactory:mobByName("Fairy")
            pos = math.random(level:getLength())-1
            toSpawn:ht(toSpawn:ht()*2)
            toSpawn:hp(toSpawn:hp()*2)
        end
        if toSpawn then
            if not pos then
                pos = level:getEmptyCellNextTo(self:getPos())
            end
            toSpawn:setPos(pos)
            RPD.setAi(toSpawn, self:getState():getTag())
            toSpawn:immunities():add(RPD.Buffs.Sleep)
            toSpawn:immunities():add(RPD.Buffs.Amok)
            if level:cellValid(pos) then
                level:spawnMob(toSpawn)
            end
        end
    end
})