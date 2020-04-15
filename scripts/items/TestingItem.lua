--
-- User: mike
-- Date: 29.01.2019
-- Time: 20:33
-- This file is part of Remixed Pixel Dungeon.
--

local RPD = require "scripts/lib/revampedCommonClasses"
local item = require "scripts/lib/item"
local mob = require "scripts/lib/mob"
local quest = require "scripts/lib/quest"
local storage = require "scripts/lib/storage"

local mob
local DeathCounter = "DeathCounter"
local Mobs
local summon
local mobName
local mobId
local floor = {[1]=true,[2]=true,[3]=true,[5]=true,[6]=true,[7]=true,[8]=true,[9]=true,[11]=true,[14]=true,[15]=true,[17]=true,[18]=true,[19]=true,[20]=true,[21]=true,[22]=true,[23]=true,[25]=true,[26]=true,[27]=true,[28]=true,[29]=true,[30]=true,[31]=true,[32]=true,[33]=true,[34]=true,[37]=true,[38]=true,[39]=true,[40]=true,[42]=true,[47]=true,[48]=true,[49]=true,[50]=true,[51]=true,[52]=true,[53]=true,[54]=true,[55]=true,[56]=true,[57]=true,[58]=true,[59]=true,[60]=true,[61]=true,[62]=true,[63]=true}
local areaName = {"Test Level","Home","Amulet","Bone Dragon","Fairy Overlord","Ceaseless Void","Sleep"}
local areaId = {"testLevel","home","36","tombFinal","dreamFinal","nightmareFinal","sleepPortal_room_lvl1"}
local buffNames = {"God Mode","Your Nightmare","Fairy's Blessings","Fairy's Curse","SubZero","Blazing Fiery","Charmful","Mind Vision","Light","Paralysis","Shield","Necrotic Exchange"}
local buffsToGive = {"GodMode","Nightmare","FairySpell","FairySpell","Subzero Frost","BlazingFiery","Charmful",RPD.Buffs.MindVision,RPD.Buffs.Light,RPD.Buffs.Paralysis}
local buffsToRemove = {"GodMode","Nightmare","FairySpell","FairySpell","SubZero","BlazingFiery","Charmful",RPD.Buffs.MindVision,RPD.Buffs.Light,RPD.Buffs.Paralysis,"ShieldLeft","NecroShieldLeft"}
local className = {"None","Warrior","Mage","Rouge","Huntress","Elf","Necromancer","Gnoll"}
local classId = {"none","warrior","mage","rouge","huntress","elf","necromancer","Gnoll"}
local subClassName = {"None","Gladiator","Berserker","Warlock","Battle Mage","Assassin","Freerunner","Sniper","Warden","Scout","Shaman","Lich"}
local subClassId = {"NONE","GLADIATOR","BERSERKER","WARLOCK","BATTLEMAGE","ASSASSIN","FREERUNNER","SNIPER","WARDEN","SCOUT","SHAMAN","LICH"}
local subClassSId = {"none","gladiator","berserker","warlock","battlemage","assassin","freerunner","sniper","warden","scout","shaman","lich"}
local selectedGiveBuff
local selectedRemoveBuff
local mobSelected
local selectedArea
local selectedClass
local selectedSubClass
local giveSelectedBuff
local removeSelectedBuff

return item.init{
    desc = function (self, item)
        return {
            image         = 5,
            imageFile     = "items/rings.png",
            name          = "Testing Item",
            info          = "Item for tests and target dummies.",
            stackable     = false,
            upgradable    = false,
            identified    = true,
            defaultAction = "Tp to Cell",
            price         = 0
        }
    end,

    image = function(self, item)
        return math.random(0,15)
    end,

    actions = function(self, item, hero)
        local godMode
        local debuffImmune
        local giveBuffs
        local removeBuffs
        selectedArea = math.random(1,#areaName)
        selectedGiveBuff = math.random(1,#buffsToGive)
        selectedRemoveBuff = math.random(1,#buffsToRemove)
        selectedClass = math.random(2,#className)
        if className[selectedClass] == "None" or hero:className() == "Gnoll" or className[selectedClass] == "Gnoll" then
            selectedSubClass = 1
        elseif className[selectedClass] == "Warrior" or hero:getSubClass():name() == subClassId[2] or hero:getSubClass():name() == subClassId[3] then
            selectedSubClass = math.random(2,3)
        elseif className[selectedClass] == "Mage" or hero:getSubClass():name() == subClassId[4] or hero:getSubClass():name() == subClassId[5] then
            selectedSubClass = math.random(4,5)
        elseif className[selectedClass] == "Rouge" or hero:getSubClass():name() == subClassId[6] or hero:getSubClass():name() == subClassId[7] then
            selectedSubClass = math.random(6,7)
        elseif className[selectedClass] == "Huntress" or hero:getSubClass():name() == subClassId[8] or hero:getSubClass():name() == subClassId[9] then
            selectedSubClass = math.random(8,9)
        elseif className[selectedClass] == "Elf" or hero:getSubClass():name() == subClassId[10] or hero:getSubClass():name() == subClassId[11] then
            selectedSubClass = math.random(10,11)
        elseif className[selectedClass] == "Necromamcer" or hero:getSubClass():name() == subClassId[12] then
            selectedSubClass = 12
        end
        giveSelectedBuff = buffsToGive[selectedGiveBuff]
        removeSelectedBuff = buffsToRemove[selectedRemoveBuff]
        if not storage.get("MobData") then
            storage.put("MobData",{class="Nothing",name="Nothing",ai=nil,ht=nil,hp=nil})
        end
        if not summon then
            summon = storage.get("MobData")
        end
        mobName = {"Money Giver","Shopkeeper","Target","Targets across entire map","Pet",summon.name,summon.name.." as Pet",summon.name.." across entire map"}
        mobId = {"TempMoney","Shopkeeper",nil,nil,nil,summon.id,summon.id,summon.id}
        mobSelected = math.random(1,#mobName)
        if storage.get("RemoveDebuffs") then
            debuffImmune = "No longer remove debuffs"
        else
            debuffImmune = "Remove debuffs"
        end
        giveBuffs = "Give "..buffNames[selectedGiveBuff]
        removeBuffs = "Remove "..buffNames[selectedRemoveBuff]
        return {"Tp to Cell","Get Level Data","Refresh Level","Get Mob Data","Get Specific Mob Data","Summon "..mobName[mobSelected],--[["Fill map with "..summon.name,]]"Fill map with Mobs","Hurt Everything","Tp to "..areaName[selectedArea],debuffImmune,"Death Counter",giveBuffs,removeBuffs,"Give/Remove God Mode to/from target"--[[,"Change class to "..className[selectedClass],"Change sub class to "..subClassName[selectedSubClass]],"Fill Area"}
    end,

    cellSelected = function(self, item, action, cell)
        if action == "Get Specific Mob Data" then
            local level = RPD.Dungeon.level
            local target = RPD.Actor:findChar(cell)
            local owner
            local subClass = "None"
            if target then
                if target:name() ~= "you" then
                    owner = target
                    if target:getOwner() then
                        owner = target:getOwner()
                    end
                    RPD.glog("Mob: "..target:name()
                    ..",\nMob Id: "..tostring(target:getId())
                    ..",\nMob Class: "..target:getMobClassName()
                    ..",\nAi State: "..tostring(target:getState())
                    ..",\nAi State Tag: "..tostring(target:getState():getTag())
                    ..",\nHt: "..tostring(target:ht())
                    .."\nHp: "..tostring(target:hp())
                    ..",\nCell X: "..tostring(level:cellX(target:getPos()))
                    ..",\nCell Y: "..tostring(level:cellY(target:getPos()))
                    ..",\nOwner: "..owner:name()
                    ..",\nOwner Id: "..tostring(owner:getId()))
                    storage.put("MobData",{class=target:getMobClassName(),name=target:name(),ai=tostring(target:getState():getTag()),ht=target:ht(),hp=target:hp()})
                    summon = storage.get("MobData")
                else
                    if target:getSubClass():name() then
                        subClass = target:getSubClass():name()
                    end
                    RPD.glog("Mob: "..target:name()
                        ..",\nClass Name: "..target:className()
                        ..",\nSub Class Name: "..subClass
                        ..",\nLevel: "..target:lvl()
                        ..",\nHt: "..tostring(target:ht())
                        .."\nHp: "..tostring(target:hp())
                        ..",\nMt: "..tostring(target:getSkillPointsMax())
                        ..",\nMp: "..tostring(target:getSkillPoints())
                        ..",\nStr: "..tostring(target:STR())
                        ..",\nDr: "..tostring(target:dr())
                        ..",\nCell X: "..tostring(level:cellX(target:getPos()))
                        ..",\nCell Y: "..tostring(level:cellY(target:getPos())))
--                    storage.put("MobData",{class="MirrorImage",name="Mirror Image",ai="WANDERING",ht=1,hp=1})
--                    summon = storage.get("MobData")
                end
            end
        end

        if action == "Give/Remove God Mode to/from target" then
            local target = RPD.Actor:findChar(cell)
            if target then
                if target:buffLevel("GodMode") > 0 then
                    RPD.removeBuff(target, "GodMode")
                    if target:name() ~= "you" then
                        RPD.glogp(target:name().." no longer has God Mode!")
                    else
                        RPD.glogn(target:name().." no longer have God Mode!")
                    end
                else
                    RPD.permanentBuff(target, "GodMode")
                    if target:name() ~= "you" then
                        RPD.glogn(target:name().." has God Mode!")
                    else
                        RPD.glogp(target:name().." have God Mode!")
                    end
                end
            end
        end

        if action == "Tp to Cell" then
            local level = RPD.Dungeon.level
            local target = RPD.Actor:findChar(cell)
            local user = item:getUser()
            if not target and cell then
                if level:cellValid(cell) then
                    RPD.zapEffect(user, cell, RPD.Sfx.SnowParticle)
                    user:placeTo(cell)
                    user:getSprite():place(cell)
                end
            else
                RPD.glogn("Can't tp there bc that cell isn't valid.")
            end
        end
    end,

    execute = function(self, item, hero, action)
        local hero = RPD.Dungeon.hero
        local levelId = RPD.Dungeon.levelId
        local level = RPD.Dungeon.level
        local user = item:getUser()
        local heroPos = RPD.getXy(hero)
        local userPos = RPD.getXy(user)

        if action == "Tp to Cell" then
            item:selectCell(action, "Select cell to tp to.")
        end

        if action == "Get Level Data" then
            RPD.glog("Level: "..tostring(level)
            ..",\nLevel ID: "..tostring(levelId)
            ..",\nLevel Name: "..RPD.textById(levelId.."Map_Name")
            ..",\nCell X: "..userPos[1]
            ..",\nCell Y: "..userPos[2]
            ..",\nMax Width: "..level:getWidth()
            ..",\nMax Height: "..level:getHeight()
            ..",\nMex Length: "..level:getLength())
        end

        if action == "Refresh Level" then
            RPD.GameScene:updateMap()
        end

        if action == "Get Mob Data" then
            local level = RPD.Dungeon.level
            local target
            local owner
            local subClass = "None"
            for x = 0, level:getWidth() do
                for y = 0, level:getHeight() do
                    target = RPD.Actor:findChar(level:cell(x,y))
                    if target then
                        if target:name() ~= "you" then
                            owner = target
                            if target:getOwner() then
                                owner = target:getOwner()
                            end
                            RPD.glog("Mob: "..target:name()
                            ..",\nMob Id: "..tostring(target:getId())
                            ..",\nMob Class: "..target:getMobClassName()
                            ..",\nAi State: "..tostring(target:getState())
                            ..",\nAi State Tag: "..tostring(target:getState():getTag())
                            ..",\nHt: "..tostring(target:ht())
                            .."\nHp: "..tostring(target:hp())
                            ..",\nCell X: "..tostring(level:cellX(target:getPos()))
                            ..",\nCell Y: "..tostring(level:cellY(target:getPos()))
                            ..",\nOwner: "..owner:name()
                            ..",\nOwner Id: "..tostring(owner:getId()))
                            storage.put("MobData",{class=target:getMobClassName(),name=target:name(),ai=tostring(target:getState():getTag()),ht=target:ht(),hp=target:hp()})
                            summon = storage.get("MobData")
                        else
                            if target:getSubClass():name() then
                                subClass = target:getSubClass():name()
                            end
                            RPD.glog("Mob: "..target:name()
                            ..",\nClass Name: "..target:className()
                            ..",\nSub Class Name: "..subClass
                            ..",\nLevel: "..target:lvl()
                            ..",\nHt: "..tostring(target:ht())
                            .."\nHp: "..tostring(target:hp())
                            ..",\nMt: "..tostring(target:getSkillPointsMax())
                            ..",\nMp: "..tostring(target:getSkillPoints())
                            ..",\nStr: "..tostring(target:STR())
                            ..",\nDr: "..tostring(target:dr())
                            ..",\nCell X: "..tostring(level:cellX(target:getPos()))
                            ..",\nCell Y: "..tostring(level:cellY(target:getPos())))
--                            storage.put("MobData",{class="MirrorImage",name="Mirror Image",ai="WANDERING",ht=1,hp=1})
--                            summon = storage.get("MobData")
                        end
                    end
                end
            end
        end

        if action == "Get Specific Mob Data" then
            item:selectCell(action, "Get Mob Data")
        end

        if action == "Summon "..mobName[mobSelected] then
            local cell = level:getEmptyCellNextTo(user:getPos())
            local pet = 0
            local mobData = 0
            local map = 0
            mob = nil
            if mobName[mobSelected] == "Target" then
                Mobs = {--[["Fairy","OmnipotentEye","TheRejected","CorpseLarva","ConjoinedCorpse","SplitCorpse","EuropeanShorthair","AngryNimbus","LightElemental","DarkElemental",]]"DarkMage","FireMage","IceMage","WaterMage","EarthMage","LightMage"--[[,"UndeadSpiderMutant","BlackRat"]]}
                mob = RPD.MobFactory:mobByName(Mobs[math.random(1,#Mobs)])
                mob:ht(2^31-1)
                mob:hp(mob:ht())
                RPD.permanentBuff(mob, RPD.Buffs.Roots)
            end
            if mobName[mobSelected] == "Targets across entire map" then
                map = map+1
                Mobs = {--[["Fairy","OmnipotentEye","TheRejected","CorpseLarva","ConjoinedCorpse","SplitCorpse","EuropeanShorthair","AngryNimbus","LightElemental","DarkElemental",]]"DarkMage","FireMage","IceMage","WaterMage","EarthMage","LightMage"--[[,"UndeadSpiderMutant","BlackRat"]]}
                mob = RPD.MobFactory:mobByName(Mobs[math.random(1,#Mobs)])
                RPD.permanentBuff(mob, RPD.Buffs.Roots)
            end
            if mobName[mobSelected] == "Pet" then
                Mobs = {--[["Fairy","OmnipotentEye","TheRejected","CorpseLarva","ConjoinedCorpse","SplitCorpse","EuropeanShorthair","AngryNimbus","LightElemental","DarkElemental",]]"DarkMage","FireMage","IceMage","WaterMage","EarthMage","LightMage"--[[,"UndeadSpiderMutant","BlackRat"]]}
                mob = RPD.MobFactory:mobByName(Mobs[math.random(1,#Mobs)])
                pet = pet+1
                mob:makePet(mob, hero)
            end
            if mobName[mobSelected] == "Nothing" then
                RPD.glogn("There's nothing to summon.")
                return true
            else
                if action == "Summon "..summon.name and summon.name ~= "Nothing" then
                    mobData = mobData+1
                end
                if action == "Summon "..summon.name.." as Pet" and summon.name ~= "Nothing" then
                    mobData = mobData+1
                    pet = pet+1
                    mob = RPD.MobFactory:mobByName(summon.class)
                    mob:makePet(mob, hero)
                end
                if action == "Summon "..summon.name.." across entire map" and summon.name ~= "Nothing" then
                    mobData = mobData+1
                    map = map+1
                end
            end
            if level:cellValid(cell) then
                if mobData > 0 then
                    mob = mob or RPD.MobFactory:mobByName(summon.class)
                else
                    mob = mob or RPD.MobFactory:mobByName(mobId[mobSelected])
                end
                RPD.setAi(mob, "Wandering")
                if map > 0 then
                    for x = 0, level:getWidth() do
                        for y = 0, level:getHeight() do
                            local target = RPD.Actor:findChar(level:cell(x,y))
                            if level:cellValid(level:cell(x,y)) and floor[level.map[level:cell(x,y)]] and not target then
                                mob:setPos(level:cell(x-1,y))
                                level:spawnMob(mob)
                                if Mobs then
                                    mob = RPD.MobFactory:mobByName(Mobs[math.random(1,#Mobs)])
                                else
                                    mob = RPD.MobFactory:mobByName(mob:getEntityKind())
                                end
                                if level.map[level:cell(x,y)] == 5 then
                                    level:set(level:cell(x-1,y), 6)
                                    RPD.GameScene:updateMap()
                                end
                            end
                        end
                    end
                else
                    mob:setPos(cell)
                    level:spawnMob(mob)
                end
                if pet > 0 then
                    if mobData > 0 then
                        RPD.glogw("Summoned "..summon.name.." as a pet.")
                    else
                        RPD.glogw("Summoned "..mob:name().." as a pet.")
                    end
                else
                    if mobData > 0 then
                        if map > 0 then
                            RPD.glogw("Filled the current map with "..summon.name..".")
                        else
                            RPD.glogw("Summoned "..summon.name..".")
                        end
                    else
                        if map > 0 then
                            if mobName[mobSelected] == "targets across entire map" then
                                RPD.glogw("Filled the current map with targets.")
                            else
                                RPD.glogw("Filled the current map with "..mob:name()..".")
                            end
                        else
                            RPD.glogw("Summoned "..mob:name()..".")
                        end
                    end
                end
                mob = nil
                pet = nil
                mobData = nil
                map = nil
                return true
            end
            RPD.glogn("There's not enough space for the summon.")
            return false
        end

        if summon then
            if action == "Fill map with "..summon.name then
                if summon.class == "Nothing" then
                    RPD.glogn("There's nothing to summon.")
                    return true
                end
                for i = 0, level:getLength() do
                    local target = RPD.Actor:findChar(i)
                    if level:cellValid(i) and floor[level.map[i]] and not target then
                        mob = RPD.MobFactory:mobByName(summon.class)
                        mob:setPos(cell)
                        level:spawnMob(mob)
                        if level.map[i] == 5 then
                            level:set(i-1, 6)
                            RPD.GameScene:updateMap()
                        end
                    end
                end
                RPD.glogp("Filled the current map with "..summon.name..".")
            end
        end

        if action == "Fill map with Mobs" then
            Mobs = {"MazeShadow","Kobold","SpiderServant","FireElemental"}
            for i = 0, level:getLength()-1 do
                local target = RPD.Actor:findChar(i)
                if level:cellValid(i) and floor[level.map[i]] and not target then
                    mob = RPD.MobFactory:mobByName(Mobs[math.random(1,#Mobs)])
                    RPD.setAi(mob, "Wandering")
                    mob:setPos(i)
                    level:spawnMob(mob)
                    if level.map[i] == 5 then
                        level:set(i-1, 6)
                        RPD.GameScene:updateMap()
                    end
                end
                RPD.glogp("Filled the current map with Shadows, Kobolds, Spider Servants, and Fire Elementals.")
            end
        end

        if action == "Hurt Everything" then
            for x = 0, level:getWidth() do
                for y = 0, level:getHeight() do
                    local target = RPD.Actor:findChar(level:cell(x,y))
                    if target then
                        if target ~= user and not target:isPet() then
                            target:hp(1)
                        end
                    end
                end
            end
        end

        if action == "Tp to "..areaName[selectedArea] then
            local portal
            local posX
            local posY
            if areaName[selectedArea] == "Amulet" then
                posX = 5
                posY = 5
            elseif areaName[selectedArea] == "Bone Dragon" then
                posX = 7
                posY = 11
            elseif areaName[selectedArea] == "Fairy Overlord" or areaName[selectedArea] == "Ceaseless Void" then
                posX = 7
                posY = 6
            elseif areaName[selectedArea] == "Sleep" then
                posX = 7
                posY = 7
            elseif areaName[selectedAre] == "Home" then
                posX = 9
                posY = 3
            else
                posX = 1
                posY = 1
            end
            portal = {kind="PortalGateSender",target={levelId=areaId[selectedArea],x=posX,y=posY}}
            RPD.createLevelObject(portal, hero:getPos())
            RPD.glogp("Created a portal to "..areaName[selectedArea]..".")
        end

        if action == "No longer remove debuffs" then
            RPD.glog("You will no longer remove every debuff when God Mode is active.")
            storage.put("RemoveDebuffs", false)
        end

        if action == "Remove debuffs" then
            RPD.glog("You'll now remove every debuff when God Mode is active.")
            storage.put("RemoveDebuffs", true)
        end

        if action == "Death Counter" then
            Mobs = {"Rat","Gnoll","Albino","Mimic","MimicPie","MimicAmulet","TombRaider","SandWorm","TombWorm","BoneDragon","FairyOverlord","CeaselessVoid","Fairy","NightmareClone","Goo","Tengu","CactusMimic","Wraith","TempMoney","Shopkeeper","CockerSpaniel","CockerSpanielNPC","BlackCat"}
            for i = 1, #Mobs do
                if storage.get(Mobs[i].." kills") then
                    RPD.glog(Mobs[i].." kills: "..tostring(storage.get(Mobs[i].." kills")))
                else
                    RPD.glog(Mobs[i].." kills: 0")
                end
            end
        end

        if action == "Give "..buffNames[selectedGiveBuff] then
            if buffNames[selectedGiveBuff] == "Fairy's Blessings" then
                storage.put("FairyOverlord Saved", true)
                RPD.glog("Blessed")
            elseif buffNames[selectedGiveBuff] == "Fairy's Curse" then
                storage.put("FairyOverlord Saved", false)
                RPD.glog("Cursed")
            end
            if user:buffLevel(giveSelectedBuff) > 0 then
                RPD.removeBuff(user, giveSelectedBuff)
            end
            if buffNames[selectedGiveBuff] == "Paralysis" then
                RPD.affectBuff(user, giveSelectedBuff, 500*5)
            else
                RPD.permanentBuff(user, giveSelectedBuff)
            end
            RPD.BuffIndicator:refreshHero()
            RPD.glog("Gave you the "..buffNames[selectedGiveBuff].." de/buff.")
        end

        if action == "Remove "..buffNames[selectedRemoveBuff] then
            if user:buffLevel(removeSelectedBuff) > 0 then
                RPD.removeBuff(user, removeSelectedBuff)
                if buffNames[selectedRemoveBuff] == "Fairy's Blessings" or buffNames[selectedRemoveBuff] == "Fairy's Curse" then
                    RPD.glog("Removed "..buffNames[2].." or "..buffNames[3].."de/buff from you.")
                else
                    RPD.glog("Removed the "..buffNames[selectedRemoveBuff].." de/buff from you.")
                end
            end
        end

        if action == "Give/Remove God Mode to/from target" then
            item:selectCell(action, "Select a target")
        end--[[

        if action == "Change class to "..className[selectedClass] then
            if className[selectedClass] ~= "None" then
                hero:setClass(classId[selectedClass])
                hero:setSubClass(subClassId[1])
                RPD.glog("Set the hero's class to "..className[selectedClass]..".")
            else
                RPD.glogn("Can't set the hero's class to nothing.")
            end
        end

        if action == "Change sub class to "..subClassName[selectedSubClass] then
            if subClassName[selectedSubClass] ~= "None" or (subClassId[selectedSubClass] ~= "" or subClassSId[selectedSubClass] ~= "") then
                hero:setClass(subClassSId[selectedSubClass])
                hero:setSubClass(subClassId[selectedSubClass])
                RPD.glog("Set the hero's sub class to "..subClassName[selectedSubClass])
            else
                RPD.glogn("San't set the hero's class to nothing.")
            end
        end]]

        if action == "Fill Area" then
            local userPos = RPD.getXy(user)
            local tiles = {1,4,48}
            local tile = math.random(1,#tiles)
            for x = -5, 5 do
                for y = -5, 5 do
                    local pos = level:cell(userPos[1]+x,userPos[2]+y)
                    if level:cellValid(pos) then
                        level:set(pos-1, tile)
                        RPD.GameScene:updateMap()
                    end
                end
            end
            RPD.glogw("Filled a 5x5 area around you.")
        end
    end,

    bag = function(self, item)
        return "Keyring"
    end
}