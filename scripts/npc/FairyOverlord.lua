--
-- User: mike
-- Date: 23.11.2017
-- Time: 21:04
-- This file is part of Remixed Pixel Dungeon.
--

local RPD = require "scripts/lib/revampedCommonClasses"
local mob = require "scripts/lib/mob"
local storage = require "scripts/lib/storage"

local client
local npc

local interactions = 0
local price = 550

local dialog = function(index)
    if index == 0 then
        local level = RPD.Dungeon.level
        if client:gold() >= price then
            local pos = level:getEmptyCellNextTo(client:getPos())
            if level:cellValid(pos) then
                local Mob = RPD.MobFactory:mobByName("Fairy")
                client:spendGold(price)
                RPD.setAi(Mob, "Wandering")
                Mob:setPos(pos)
                Mob:makePet(Mob, client)
                level:spawnMob(Mob)
                RPD.playSound("snd_gold.mp3")
                RPD.showQuestWindow(npc, RPD.textById("FairyOverlord_BuyThanks"))
                return
            else
                RPD.showQuestWindow(npc, RPD.textById("FairyOverlord_NoSpace"))
                return
            end
        end
        RPD.showQuestWindow(npc, RPD.textById("FairyOverlord_NoMoney"))
    end

    if index == 1 then
        RPD.glogp("FairyOverlord_ComeBack")
    end
end

return mob.init({
    interact = function(self, chr)
        if interactions <= 0 then
            RPD.showQuestWindow(self, RPD.textById("FairyOverlord_Thanks"))
        else
            client = chr
            npc = self
            local chrName = chr:name()
            if chr == RPD.Dungeon.hero then
                chrName = chr:className()
            end
            RPD.chooseOption(dialog,
                self:name(),
                RPD.textById("FairyOverlord_NeedFairy"):format(chrName, tostring(price)),
                "Yes_Option",
                "No_Option"
            )
        end
        interactions = interactions+1
    end,

    die = function(self, cause)
        local hero = RPD.Dungeon.hero
        if cause == hero then
            storage.put("FairyOverlord Saved", false)
            local amount = storage.get("FairyOverlord kills") or 0
            storage.put("FairyOverlord kills", amount+1)
            RPD.BuffIndicator:refreshHero()
            RPD.showQuestWindow(self, RPD.textById("FairyOverlord_Backstab"):format(hero:className()))
            RPD.playSound("snd_cursed.mp3")
            RPD.glog(tostring(cause))
        end
    end,

    spawn = function(self, level)
        RPD.permanentBuff(self, "DmgImmune")
    end,
})