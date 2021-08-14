--
-- User: mike
-- Date: 23.11.2017
-- Time: 21:04
-- This file is part of Remixed Pixel Dungeon.
--

local RPD = require "scripts/lib/revampedCommonClasses"

local mob = require"scripts/lib/mob"

return mob.init({
    die = function(self, cause)
        local hero = RPD.Dungeon.hero
        if cause == hero and self:isPet() then
            hero:STR(math.max(hero:STR()-1,1))
            hero:getSprite():emitter():burst(RPD.Sfx.ShadowParticle.CURSE, 6)
            hero:getSprite():showStatus(0xFF0000, RPD.textById("Str_lose"))
            RPD.playSound("snd_cursed.mp3")
        else
            if cause.damage then
                cause:damage(math.random(1,10), self)
                cause:getSprite():emitter():burst(RPD.Sfx.ShadowParticle.CURSE, 6)
                RPD.playSound("snd_cursed.mp3")
            end
        end
        self:getSprite():emitter():burst(RPD.Sfx.ElmoParticle.FACTORY, 6)
    end,

    attackProc = function(self, enemy, dmg)
        if enemy then
            if math.random(1,100) < 15 or dmg >= 8 then
                RPD.affectBuff(enemy, RPD.Buffs.Poison, 8)
            end
        end
        return enemy:damage(dmg, self)
    end
})