--
-- User: mike
-- Date: 26.05.2018
-- Time: 21:32
-- This file is part of Remixed Pixel Dungeon.
--

local RPD = require "scripts/lib/revampedCommonClasses"

local item = require "scripts/lib/item"

local buffs = {"Poison","Necrotism","Burning","Paralysis","Frost","Cripple","Sleep","Slow","Ooze","Bleeding","Weakness"}

local npcs = {Shopkeeper=true,ImpShopkeeper=true,TownGuardNPC=true,TownsfolkNPC=true,TownsfolkSilentNPC=true,TownsfolkMovieNPC=true,PlagueDoctorNPC=true,Quest1TownsfolkNPC=true,ShadyNPC=true,CockerSpanielNPC=true,BlackCat=true,FortuneTellerNPC=true,MonikaMPC=true,LibrarianNPC=true,InnkeeperNPC=true,BarmanNPC=true,Quest2TownsfolkNPC=true,Quest3TownsfolkNPC=true,Quest4TownsfolkNPC=true,ChefNPC=true,ChargrilledMeatNPC=true,FriedFishNPC=true,TownsfolkLootNPC=true,LostSoulNPC=true,BoneDragonNPC=true,GuardDogKeeperNPC=true,ServiceManNPC=true,TempMoney=true,RoomServiceNPC=true}

return item.init{
    desc  = function ()
        return {
            image     = 0,
            imageFile = "items/bandages.png",
            name      = "Bandage_Name",
            info      = "Bandage_Desc",
            stackable = true,
            defaultAction = "Weightstone_ACApply",
            price         = 160*2/5
        }
    end,
    actions = function(self, item, hero)
        return {RPD.Actions.apply,"Bandage_ACPet"}
    end,

    cellSelected = function(self, item, action, cell)
        if action == "Bandage_ACPet" then
            local target = RPD.Actor:findChar(cell)
            local hero = RPD.Dungeon.hero
            local level = RPD.Dungeon.level
            local removed = 0
            local user = item:getUser()
            if target then
                if level:distance(user:getPos(), cell) == 1 or target == user then
                    if target ~= hero then
                        if npcs[target:getEntityKind()] then
                            RPD.glog("Bandage_Npc")
                            return
                        elseif not target:isPet() then
                            RPD.glogn("Bandage_Enemy")
                            return
                        end
                    end
                    for i = 1, #buffs do
                        if target:buffLevel(buffs[i]) > 0 then
                            RPD.removeBuff(target, buffs[i])
                            removed = removed+1
                        end
                    end
                    if target:hp() ~= target:ht() then
                        target:heal(target:ht()/3, item)
                        removed = removed+1
                    end
                    if removed > 0 then
                        if target == hero or target == user then
                            RPD.glogp("Bandage_Text", item:name())
                        elseif target:isPet() then
                            RPD.glogp("Bandage_PetText", target:getName(), item:name())
                        end
                        item:detach(user:getBelongings().backpack)
                        return
                    else
                        RPD.glogn("Bandage_NoHeal", target:getName())
                        return
                    end
                else
                    RPD.glogn("Bandage_ToFar", target:getName())
                    return
                end
            end
        end
    end,

    execute = function(self, item, user, action)
        if action == RPD.Actions.apply then
            local removed = 0
            for i = 1, #buffs do
                if user:buffLevel(buffs[i]) > 0 then
                    RPD.removeBuff(user, buffs[i])
                    removed = removed+1
                end
            end
            if user:hp() ~= user:ht() then
                user:heal(user:ht()/3, item)
                removed = removed+1
            end
            if removed > 0 then
                RPD.glogp("Bandage_Text", item:name())
                item:detach(user:getBelongings().backpack)
                user:spendAndNext(1)
                return
            else
                RPD.glogn("Bandage_NoHeal", user:getName())
                user:spendAndNext(1)
                return
            end
        end
        if action == "Bandage_ACPet" then
            item:selectCell("Bandage_ACPet", "Bandage_Use")
        end
    end,

    burn = function()
        return nil
    end,

    poison = function()
        return RPD.ItemFactory:itemByName("OldBandage")
    end
}
