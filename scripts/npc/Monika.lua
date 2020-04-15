--[[
    Created by mike.
    DateTime: 19.01.19 21:24
    This file is part of pixel-dungeon-remix
]]

local RPD = require "scripts/lib/revampedCommonClasses"
local mob = require"scripts/lib/mob"

local npc

local dialog = function(index)
    if index == 0 then
        RPD.showQuestWindow(npc, "_What's New in v3_.\n\n_New Areas_:\n  Dream Dungeon,\n  Nightmare Dungeon.\n_New Entities_:\n  Angry Nimbus,\n  Ceaseless Void,\n  Conjoined Corpse,\n  Corpse Larva,\n  Dark Elemental,\n  Dark Mage,\n  Earth Mage,\n  European Shorthair,\n  Fairy,\n  Fairy Overlord,\n  Fire Mage,\n  Ice Mage,\n  Light Elemental,\n  Light Mage,\n  Voidlinks,\n  Omnipotent Eye,\n  Dejected Twin,\n  ZX #13 - The Rejected,\n  Water Mage.\n_New Items_:\n  Crystallized Flower,\n  Flame of Frozen Explosions,\n  Necrotic Shield,\n  Nightmare's Eye,\n  Scroll of Returning.\n_New Spells_:\n  Elemental Summon,\n  Blessing (Spellbook only).\n_New De/buffs_:\n  Fairy's Blessing/Curse (1 de/buff different names so just call it \"Fairy's Spell\"),\n  Necrotic Exchange,\n  Your Nightmare,\n  Subzero Frost.")
    end

    if index == 1 then
        RPD.showQuestWindow(npc, "_What's Changed in v3_.\n\n_Items_:\n  Every shield (in remixed and in this mod) will now use the latest shield lib and every new change that happens to it,\n  Tome of Special Summon now has to be identified to know it's stength and is upgradable.\n_Entities_:\n  Bg changes to Bone Dragon,\n  Tomb Raider is now a picky thief.\n_Actors_:\n  Bg changes to every actor.\n_Buffs_:\n  Buffed the Charmful buff so now the ring can be upgraded and effects this buff.")
    end

    if index == 2 then
        RPD.showQuestWindow(npc, "_Bugs fixed in v3.1_.\n\nMissing Adventurer's Friend.")
    end

    if index == 3 then
        RPD.showQuestWindow(npc, "Credits go to _Marshall_ for the sprites of Shady Man, Old Knight Shield, Board, Light Elemental, Dark Elemental, and Lost Soul.\n\n_Krauzxe_ for the sprites of Ghost Bosses, Bone Dragon, Cocker Spaniel, Mummy, Cactus, Cactus Mimic, Sand Worm, Tomb Worm, Husk, Mutated Spider, Catching Capsule, Ultimate Catching Capsule, Monika, Old Bandage, Cactus Fruit, Nightmare Dungeon Tiles, Angry nNimbus, Ceaseless Void/Voidlinks, Conjoined Corpse, Omnipotent Eye, Dejected Twin, Eruopean Shorthair, Fairy, Fairy Overlord, ZX #13 - The Rejected, Crystallized Flower, Flame of Frozen Explosions, Necrotic Shield, Nightmare's Eye, Scroll of Returning and helped me with the desert and desert tombs tiles.\n\n_Gabidal.G_ for the music of Desert and Desert Tombs.\n\n_Sprites by me_: Magic Gun, Blazing Ring, Charmful Ring, Blazing Fiery Icon, Charmful Icon, Chef, Elemental Mages, Undead Summon Icon, Elemental Summon Icon, Desert Tiles, Desert Tomb Dungeon Tiles, Your Nightmare Icon, Subzero Frost icon, Fairy's Blessing Icon, Fairy's Curse Icon, Necrotic Exchange Icons, Dream Dungeon Tiles.")
    end

    if index == 4 then
        RPD.showQuestWindow(npc, "_Music Links_:\n  Desert Theme: _https://www.youtube.com/watch?v=Ae6yeNBgjOg_,\n  Tomb Theme: _https://www.youtube.com/watch?v=HNyPo2WY2nE_.")
    end
end


return mob.init({
    interact = function(self, chr)
        npc = self

        RPD.chooseOption( dialog,
            "Monika",
            "Hi I'm _Monika_, The dev of this mod.\nCurrent version of this mod: _v3_ (aka the _Todo List Update_)",
            "What's New",
            "Changes",
            "Bug Fixes",
            "Credits",
            "Links",
            "Bye"
        )
    end,

    spawn = function(self, level)
        RPD.setAi(self, "Monika")
        RPD.permanentBuff(self, "DmgImmune")
    end,
})
