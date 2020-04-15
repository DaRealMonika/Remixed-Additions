---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mike.
--- DateTime: 02.05.19 14:36
---

local RPD  = require "scripts/lib/revampedCommonClasses"
local buff = require "scripts/lib/buff"

local immune = {"Burning","LiquidFlame","Fire","FireElemental"}

local immuneMobs = {MirrorImage=true,Shopkeeper=true,BellaNPC=true,ImpShopkeeper=true,TownsfolkLootNPC=true,Quest1TowsfolkfolkNPC=true,Ques21TowsfolkfolkNPC=true,Quest3TowsfolkfolkNPC=true,Quest4TowsfolkfolkNPC=true,TempMoney=true,InnkeeperNPC=true,Barman=true,ChefNPC=true,ChargrilledMeatNPC=true,FriedFishNPC=true,ShadyNPC=true,BishopNPC=true,BlackCat=true,CockerSpaniel=true,CockerSpanielNPC=true,BoneDragon=true,LostSoul=true,GhostWarrior=true,GhostWarriorNPC=true,GhostAssassin=true,GhostArcher=true,GhostMage=true}

return buff.init{
    desc  = function ()
        return {
            icon          = 52,
            name          = "BlazingFieryBuff_Name",
            info          = "BlazingFieryBuff_Info",
        }
    end,

    attachTo = function(self, buff, target)
        return true
    end,

    detach = function(self, buff)
    end,

    act = function(self,buff)
        buff:spend(1)
    end,

    charAct = function(self,buff)
        local function burnThem(cell)
            local target = RPD.Actor:findChar(cell)
            if target then
                if target ~= buff.target and not target:isPet() and not immuneMobs[target:getEntityKind()] and not (target:buffLevel("GodMode") > 0) then
                    RPD.affectBuff(target, RPD.Buffs.Burning, 5)
                    if target:buffLevel(RPD.Buffs.Burning) > 0 then
                        RPD.affectBuff(target, RPD.Buffs.Light, 5)
                    end
                end
            end
        end
        RPD.forCellsAround(buff.target:getPos(), burnThem)
    end,

    immunities = function(self, buff)
        return immune
    end
}