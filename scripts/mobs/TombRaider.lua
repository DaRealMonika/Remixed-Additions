--
-- User: mike
-- Date: 24.01.2018
-- Time: 23:58
-- This file is part of Remixed Pixel Dungeon.
--

local RPD = require "scripts/lib/revampedCommonClasses"
local mob = require"scripts/lib/mob"

local golden = {GoldenSword=true,DarkGold=true,GoldenKey=true,Gold=true,RubyBow=true,RubyCrossbow=true,Anhk=true,UltimateCatchingCapsule=true}
local chaos = {ChaosCrystal=true,ChaosSword=true,ChaosStaff=true,ChaosArmor=true,ChaosBow=true,NecroticShield=true}
local item

return mob.init{
    die = function(self, cause)
        if item then
            RPD.Dungeon.level:drop(item, self:getPos())
        end
    end,

    attackProc = function(self, enemy, dmg)
        if not item then
            local belongins = enemy:getBelongings()
            if belongins then
                local items = belongins.backpack.items

                local nItems = items:size()

                if nItems == 0 then
                    return dmg
                end

                item = items:get(math.random(0,nItems-1))
                if golden[item:getClassName()] or chaos[item:getClassName()] then
                    item:removeItemFrom(enemy)
                    RPD.glogw("Thief_Stole", self:name(), item:name())
                    RPD.setAi(self, "ThiefFleeing")
                else
                    item = nil
                end
            end
        end
        return dmg
    end
}