--
-- User: mike
-- Date: 23.11.2017
-- Time: 21:04
-- This file is part of Remixed Pixel Dungeon.
--

local RPD = require "scripts/lib/revampedCommonClasses"
local mob = require "scripts/lib/mob"

local interactions

return mob.init({
    interact = function(self, chr)
        if not interactions or interactions <= 0 then
            RPD.showQuestWindow(self, RPD.textById("Fairy_Thanks"))
        else
            RPD.glog("Fairy_TempMsg"..math.random(0,2))
        end
        if interactions then
            interactions = interactions+1
        else
            interactiins = 1
        end
    end,

    die = function(self, cause)
        local hero = RPD.Dungeon.hero
        if cause == hero then
            RPD.playSound("snd_cursed.mp3")
        end
    end,

    spawn = function(self, level)
        RPD.permanentBuff(self, "DmgImmune")
    end
})