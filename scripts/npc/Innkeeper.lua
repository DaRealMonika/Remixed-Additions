--[[
    Created by mike.
    DateTime: 19.01.19 21:24
    This file is part of pixel-dungeon-remix
]]

local RPD = require "scripts/lib/revampedCommonClasses"

local mob = require"scripts/lib/mob"

local npc
local client

local lesserPrice

local dialog = function(index)
    if index == 0 then
        if client:gold() >= lesserPrice then
            local hero = RPD.Dungeon.hero
            local hunger = hero:hunger()
            local level = RPD.Dungeon.level
            local mobs = level.mobs
            local iterator = mobs:iterator()
            client:spendGold(lesserPrice)
            hero:heal(hero:ht(), npc)
            hero:setSoulPoints(hero:getSkillPointsMax())
            hunger:satisfy(hunger:getHungerLevel())
            while iterator:hasNext() do
                local mob = iterator:next()
                if mob:isPet() then
                    mob:heal(mob:ht(), npc)
                end
            end
            RPD.playSound("snd_dewdrop.mp3")
            RPD.showQuestWindow( npc,RPD.textById("Innkeeper_thanks"))
            return
        end
        RPD.showQuestWindow( npc,RPD.textById("Innkeeper_no_money"))
    end

    if index == 1 then
        RPD.showQuestWindow( npc,RPD.textById("Innkeeper_bye"))
    end
end


return mob.init({
    interact = function(self, chr)
        client = chr
        npc = self
        local hero = RPD.Dungeon.hero

        if client:gold() <= 100 then
            lesserPrice = 85
        else
            lesserPrice = 100
        end

        RPD.chooseOption( dialog,
            "Innkeeper_title",
            "Innkeeper_text",
            RPD.textById("Innkeeper_stay"):format(lesserPrice),
            "Innkeeper_leave"
        )
    end,

    spawn = function(self, level)
        RPD.permanentBuff(self, "DmgImmune")
    end,
})
