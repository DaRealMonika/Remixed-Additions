---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mike.
--- DateTime: 04.08.18 18:14
---

local RPD = require "scripts/lib/commonClasses"
local actor = require "scripts/lib/actor"
local storage = require "scripts/lib/storage"
local mob = require "scripts/lib/mob"

local Walls = {[0]=true,[4]=true,[12]=true,[16]=true,[35]=true,[36]=true,[43]=true,[44]=true,[45]=true,[46]=true}

local ShadowType = {Shadow=true,MazeShadow=true,DarkElemental=true,ShadowLord=true,Lich=true,DreadKnight=true,DeadKnight=true,DarkMage=true}
local IceType = {Kobold=true,IceElemental=true,KoboldIcemancer=true,ColdSpirit=true,IceGuardian=true,IceGuardianCore=true,IceMage=true}
local SpiderType = {SpiderMind=true,SpiderGuard=true,SpiderQueen=true,SpiderServant=true,SpiderExploding=true,SpiderMindAmber=true,UndeadSpiderMutant=true}
local FireType = {FireElemental=true,BurningFist=true,FireMage=true}

local function updateLatestDeadMob(deadMob)
    local level = RPD.Dungeon.level
    local name = deadMob:getEntityKind()
    local counterId = name .."Kills"
    local prevAmount = storage.get(counterId) or 0
    storage.put(counterId, prevAmount+1)
    if ShadowType[name] then
        if math.random(1,100) <= 8 then
            level:drop(RPD.ItemFactory:itemByName("SoulShard"), deadMob:getPos())
        end
    end
    if IceType[name] then
        if math.random(1,100) <= 8 then
            level:drop(RPD.ItemFactory:itemByName("IceGuardianCoreModule"), deadMob:getPos())
        end
    end
    if SpiderType[name] then
        if math.random(1,100) <= 8 then
            level:drop(RPD.ItemFactory:itemByName("SpiderQueenCarapace"), deadMob:getPos())
        end
    end
    if FireType[name] then
        if math.random(1,100) <= 8 then
            level:drop(RPD.ItemFactory:itemByName("FrozenFlame"), deadMob:getPos())
        end
    end
end

mob.installOnDieCallback(updateLatestDeadMob)

return actor.init({
    act = function()
        return true
    end,
    actionTime = function()
        return 1
    end,
    activate = function()
        local level = RPD.Dungeon.level
        local hero = RPD.Dungeon.hero
        local wall = {4,12}
        local portal = {kind="PortalGateSender",target={levelId="home",x=9,y=3}}
        local portalSet = storage.get("PortalSet") or false
        if not portalSet then
            RPD.createLevelObject(portal,level:cell(level:getWidth()/2,level:getHeight()/2))
            storage.put("PortalSet",true)
        end
        for x = 0, level:getWidth()-1 do
            for y = 0, level:getHeight()-1 do
                if (x == 0 or x == level:getWidth()) and (y == 0 or y == level:getHeight()) then
                    if (level.map[level:cell(x,y)] ~= wall[1] or level.map[level:cell(x,y)] ~= wall[2]) then
                        level:set(level:cell(x,y), wall[math.random(1,#wall)])
                        RPD.GameScene:updateMap()
                    end
                elseif Walls[level.map[level:cell(x,y)]] or (x ~= 8 and y ~= 8) and level.map[level:cell(x,y)] == 7 then
                    level:set(level:cell(x-1,y),1)
                    RPD.GameScene:updateMap()
                end
            end
        end
        level:set(level:getLength()-1,1)
        RPD.GameScene:updateMap()
        for i = 0, level:getLength() do
            local target = RPD.Actor:findChar(i)
            if target then
                if target ~= hero then
                    if target:hp() < 0 then
                        target:hp(1)
                    end
                end
            end
        end
    end
})
