--
-- User: mike
-- Date: 06.11.2017
-- Time: 23:57
-- This file is part of Remixed Pixel Dungeon.
--

local RPD = require "scripts/lib/commonClasses"
local actor = require "scripts/lib/actor"
local storage = require "scripts/lib/storage"
local mob = require "scripts/lib/mob"

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
        local levelSize = RPD.Dungeon.level:getLength()
        for i = 0 , levelSize - 1 do
            local emitter = RPD.Sfx.CellEmitter:get(i)
            emitter:pour(RPD.Sfx.SnowParticle.FACTORY, 2)
        end
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