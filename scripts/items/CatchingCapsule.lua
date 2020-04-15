
--Кто прочитал
--Тот чебурек😉

local RPD = require "scripts/lib/revampedCommonClasses"

local storage = require "scripts/lib/storage"

local item = require "scripts/lib/item"

local mob = require "scripts/lib/mob"

local power = 30
local catchChance
local CapsuleMon = {id=nil,class=nil,ins=false,hp=nil,ht=nil,ai=nil,effects=nil}
local change = false

local function updateLatestDeadMob(mob)
    local id = mob:getId()
    capsule = storage.gameGet(capsule) or {}
    if id == CapsuleMon.id then
        RPD.glogn("Capsule_Killed",RPD.MobFactory:mobByName(mob:getEntityKind()):getName())
        CapsuleMon = {id=nil,class=nil,ins=false,hp=nil,ht=nil,ai=nil,effects=nil}
        change = true
    end
end

mob.installOnDieCallback(updateLatestDeadMob)

return item.init{
    desc  = function ()
        return {
            image     = 0,
            imageFile = "items/capsules.png",
            name      = "CatchingCapsule_Name",
            info      = "CatchingCapsule_Desc",
            stackable = false,
            upgradable= true,
            price     = 160*3
        }
    end,

    actions = function(self, item, hero)
        if not change then
            self.data.CapsuleMon = self.data.CapsuleMon or CapsuleMon
        else
            self.data.CapsuleMon = CapsuleMon
            change = false
        end
        if item:level() <= 0 then
            catchChance = 1
        else
            catchChance = item:level()+1
        end
        return {"Check_Mob","Release_Mob"}
    end,

    onThrow = function(self, item, cell)
        local level = RPD.Dungeon.level
        local target = RPD.Actor:findChar(cell)
        local hero = RPD.Dungeon.hero
        if target ~= nil then
            if target == hero then
            RPD.glogn("Capsule_CantCatchHero")
            hero:collect(item)
            return true
        end
        if (not self.data.CapsuleMon.ins and self.data.CapsuleMon.class == nil) or self.data.CapsuleMon.id == target:getId() then
            if target:canBePet() or target:getEntityKind() == "CockerSpanielNPC" then
                if power*(math.random(1,10)*catchChance)>target:hp()*target:ht() or self.data.CapsuleMon.id == target:getId() then
                    if self.data.CapsuleMon.id == target:getId() then
                        RPD.glogp("Capsule_Return",target:getName())
                    else
                        RPD.glogp("Capsule_Catch",target:getName())
                    end
                    if target:getEntityKind() == "CockerSpanielNPC" then
                        self.data.CapsuleMon = {class="CockerSpaniel",id=target:getId(),ins=true,hp=20,ht=20,ai="Wandering",effects=nil}
                    else
                        self.data.CapsuleMon = {class=target:getMobClassName(),id=target:getId(),ins=true,hp=target:hp(),ht=target:ht(),ai=tostring(target:getState():getTag()),effects=nil}
                    end
                    target:destroy()
                    target:getSprite():killAndErase()
                    hero:collect(item)
                else
                    RPD.glogn("Capsule_Escape",target:getName())
                    hero:collect(item)
                end
            else
                RPD.glogn("Capsule_ToStrong",target:getName())
                hero:collect(item)
            end
        else
            if self.data.CapsuleMon.ins then
                RPD.glogn("Capsule_AlreadyIns",RPD.MobFactory:mobByName(self.data.CapsuleMon.class):getName())
            else
                RPD.glogn("Capsule_AlreadyOut",RPD.MobFactory:mobByName(self.data.CapsuleMon.class):getName())
            end
            hero:collect(item)
        end
    else
        if self.data.CapsuleMon.ins then
            mob = RPD.MobFactory:mobByName(self.data.CapsuleMon.class)
            mob:setPos(cell)
            RPD.setAi(mob, self.data.CapsuleMon.ai)
            mob:ht(self.data.CapsuleMon.ht)
            mob:hp(self.data.CapsuleMon.hp)
            level:spawnMob(RPD.Mob:makePet(mob,hero))
            hero:collect(item)
            RPD.glogp("Capsule_Out",mob:getName())
            self.data.CapsuleMon = {class=self.data.CapsuleMon.class,id=mob:getId(),ins=false,ai=nil,effect=nil}
            CapsuleMon = self.data.CapsuleMon
        else
            RPD.glogp("Capsule_Nothing")
            hero:collect(item)
        end
    end
end,

execute = function(self, item, hero, action)
        if action == "Check_Mob" then
            if self.data.CapsuleMon.ins then
                RPD.showQuestWindow(RPD.MobFactory:mobByName(self.data.CapsuleMon.class),RPD.textById("Capsule_GoodInfo"):format(self.data.CapsuleMon.hp,self.data.CapsuleMon.ht,self.data.CapsuleMon.class,RPD.MobFactory:mobByName(self.data.CapsuleMon.class):description(),self.data.CapsuleMon.ai))
            else
                if self.data.CapsuleMon.class == nil then
                    RPD.glogp("Capsule_NothingInfo")
                else
                    RPD.glogp("Capsule_OutInfo",RPD.MobFactory:mobByName(self.data.CapsuleMon.class):getName())
                end
            end
        end

        if action == "Release_Mob" then
            if self.data.CapsuleMon.class then
                if self.data.CapsuleMon.ins then
                    RPD.glogp("Capsule_ReleaseGood",RPD.MobFactory:mobByName(self.data.CapsuleMon.class):getName())
                    if self.data.CapsuleMon.class == "BlackCat" or self.data.CapsuleMon.class == "CockerSpaniel" or self.data.CapsuleMon.class == "CockerSpanielNPC" then
                        hero:STR(math.max(hero:STR()-1,1))
                        hero:getSprite():emitter():burst(RPD.Sfx.ShadowParticle.CURSE, 6)
                        hero:getSprite():showStatus(0xFF0000, RPD.textById("Str_lose"))
                        RPD.playSound("snd_cursed.mp3")
                    end
                    if self.data.CapsuleMon.class == "BishopNPC" then
                        hero:ht(math.max(hero:ht()/2,1))
                        hero:damage(hero:ht(), self)
                        hero:getSprite():emitter():burst(RPD.Sfx.ShadowParticle.CURSE, 6)
                        RPD.playSound( "snd_cursed.mp3")
                    end
                    if self.data.CapsuleMon.class == "ShadyNPC" then
                        hero:damage(hero:hp()-1, hero)
                        hero:getSprite():emitter():burst(RPD.Sfx.ShadowParticle.CURSE, 6)
                        RPD.playSound("snd_cursed.mp3")
                    end
                    self.data.CapsuleMon = {class=nil,ins=false}
                else
                    RPD.glogn("Capsule_ReleaseOut",RPD.MobFactory:mobByName(self.data.CapsuleMon.class):getName())
                end
            else
                RPD.glogn("Capsule_Empty")
            end
        end
    end,

    bag = function(self, item)
        return "Quiver"
    end
}