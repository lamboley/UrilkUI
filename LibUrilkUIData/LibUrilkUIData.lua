LibUrilkUIData = {}

-- itemname('Damage Health Poison IX', 'Damage Magicka Poison IX', 'Damage Stamina Poison IX', 'Drain Health Poison IX', 'Essence of Health', 'Essence of Magicka', 'Essence of Stamina', 'Essence of Ravage Health', 'Firsthold Fruit and Cheese Plate', "Hagraven's Tonic", 'Hearty Garlic Corn Chowder', "Muthsera's Remorse", 'Lilmoth Garlic Hagfish', 'Markarth Mead')
-- isitemid(76827, 76829, 76831, 76826, 54339, 54340, 54341, 44812, 68236, 68263, 68239, 68235, 68257, 68260)
LibUrilkUIData.buffInfo = {
    ['Dubious Camoran Throne'] = 89957,
    ['Braised Rabbit with Spring Vegetables'] = 61255,
}

--------------------------------------------------------------------------------
-- Items Modules
LibUrilkUIData.customJunkId = {
    [27037] = true, -- Essence of Magicka
    [27038] = true, -- Essence of Stamina
    [27036] = true, -- Essence of Health
    [68217] = true,
}

LibUrilkUIData.customJunk = {
    -- Useless Focus Script
    ['Bound Focus Script: Bleed Damage'] = true,
    -- ['Bound Focus Script: Damage Shield'] = true,
    ['Bound Focus Script: Disease Damage'] = true,
    ['Bound Focus Script: Dispel'] = true,
    ['Bound Focus Script: Flame Damage'] = true,
    ['Bound Focus Script: Frost Damage'] = true,
    ['Bound Focus Script: Generate Ultimate'] = true,
    ['Bound Focus Script: Healing'] = true,
    ['Bound Focus Script: Immobilize'] = true,
    ['Bound Focus Script: Knockback'] = true,
    ['Bound Focus Script: Magic Damage'] = true,
    ['Bound Focus Script: Mitigation'] = true,
    ['Bound Focus Script: Multi-Target'] = true,
    -- ['Bound Focus Script: Physical Damage'] = true,
    ['Bound Focus Script: Poison Damage'] = true,
    ['Bound Focus Script: Pull'] = true,
    ['Bound Focus Script: Restore Resources'] = true,
    ['Bound Focus Script: Shock Damage'] = true,
    -- ['Bound Focus Script: Stun'] = true,
    ['Bound Focus Script: Taunt'] = true,
    ['Bound Focus Script: Trauma'] = true,

    -- Useless Signature Script
    ["Bound Signature Script: Anchorite's Cruelty"] = true,
    ["Bound Signature Script: Anchorite's Potency"] = true,
    ['Bound Signature Script: Assassins Misery'] = true,
    ['Bound Signature Script: Cavalier Charge'] = true,
    ['Bound Signature Script: Class Mastery'] = true,
    ["Bound Signature Script: Crusader's Defiance"] = true,
    -- ["Bound Signature Script: Druid's Resurgence"] = true,
    ["Bound Signature Script: Fencer's Parry"] = true,
    ["Bound Signature Script: Gladiator's Tenacity"] = true,
    ['Bound Signature Script: Growing Impact'] = true,
    -- ["Bound Signature Script: Hunter's Snare"] = true,
    ['Bound Signature Script: Immobilizing Strike'] = true,
    ["Bound Signature Script: Knight's Valor"] = true,
    ['Bound Signature Script: Leeching Thirst'] = true,
    ['Bound Signature Script: lingerin Torment'] = true,
    ["Bound Signature Script: Sage's Remedy"] = true,
    ["Bound Signature Script: Thief's Swiftness"] = true,
    ["Bound Signature Script: Warmage's Defense"] = true,
    -- ["Bound Signature Script: Warrior's Opportunity"] = true,
    ["Bound Signature Script: Wayfarer's Mastery"] = true,

    -- Useless Affix Script
    ['Bound Affix Script: Berserk'] = true,
    ['Bound Affix Script: Breach'] = true,
    ['Bound Affix Script: Brittle'] = true,
    ['Bound Affix Script: Brutality and Sorcery'] = true,
    ['Bound Affix Script: Courage'] = true,
    ['Bound Affix Script: Cowardice'] = true,
    ['Bound Affix Script: Defile'] = true,
    ['Bound Affix Script: Empower'] = true,
    ['Bound Affix Script: Enervation'] = true,
    ['Bound Affix Script: Evasion'] = true,
    ['Bound Affix Script: Expedition'] = true,
    ['Bound Affix Script: Force'] = true,
    ['Bound Affix Script: Heroism'] = true,
    ['Bound Affix Script: Intellect and Endurance'] = true,
    ['Bound Affix Script: Interrupt'] = true,
    ['Bound Affix Script: Lifesteal'] = true,
    ['Bound Affix Script: Magickasteal'] = true,
    -- ['Bound Affix Script: Maim'] = true,
    ['Bound Affix Script: Mangle'] = true,
    ['Bound Affix Script: Off Balance'] = true,
    ['Bound Affix Script: Protection'] = true,
    ['Bound Affix Script: Resolve'] = true,
    ['Bound Affix Script: Savagery and Prophecy'] = true,
    ['Bound Affix Script: Uncertainty'] = true,
    -- ['Bound Affix Script: Vitality'] = true,
    -- ['Bound Affix Script: Vulnerability'] = true,

    -- Monster Trophy
    ['Whirring Dynamo'] = true,
    ['Lashing Tentacle'] = true,
    ['Fleshy Symbiont'] = true,
    ['Polished Shell Shard'] = true,
    ['Chattering Skull'] = true,

    -- Misc
    ['Soul Gem (Empty)'] = true,

    -- Useless Poison
    ['Cloudy Damage Health Poison IV'] = true,
    ['Cloudy Damage Health Poison V'] = true,
    ['Cloudy Damage Health Poison I'] = true,
    ['Cloudy Damage Health Poison II'] = true,
    ['Cloudy Damage Health Poison III'] = true,
    ['Cloudy Gradual Ravage Health Poison IX'] = true,
    ['Cloudy Gradual Ravage Health Poison II'] = true,
    ['Cloudy Gradual Ravage Health Poison III'] = true,
    ['Cloudy Gradual Ravage Health Poison IV'] = true,
    ['Cloudy Gradual Ravage Health Poison V'] = true,
    ['Cloudy Damage Health Poison IX'] = true,
    ['Cloudy Hindering Poison IX'] = true,
    ['Cloudy Hindering Poison V'] = true,
    ['Cloudy Hindering Poison IV'] = true,
    ['Cloudy Hindering Poison III'] = true,
    ['Cloudy Hindering Poison II'] = true,

    -- Useless Potion
    ['Draught of Health'] = true,
    ['Draught of Stamina'] = true,
    ['Draught of Magicka'] = true,
    ['Solution of Stamina'] = true,
    ['Solution of Health'] = true,
    ['Solution of Magicka'] = true,
    ['Essence of Potent Health'] = true,
    ['Essence of Potent Magicka'] = true,
    ['Essence of Potent Stamina'] = true,
    ['Sip of Stamina'] = true,
    ['Sip of Health'] = true,
    ['Sip of Magicka'] = true,
    ['Tincture of Magicka'] = true,
    ['Tincture of Health'] = true,
    ['Tincture of Stamina'] = true,
    ['Serum of Magicka'] = true,
    ['Serum of Stamina'] = true,
    ['Serum of Health'] = true,
    ['Dram of Magicka'] = true,
    ['Dram of Stamina'] = true,
    ['Dram of Health'] = true,
    ['Philter of Magicka'] = true,
    ['Philter of Stamina'] = true,
    ['Philter of Health'] = true,
    ['Effusion of Magicka'] = true,
    ['Effusion of Stamina'] = true,
    ['Effusion of Health'] = true,

    -- Useless Recipe
    ['Diagram: Nord Pot, Covered'] = true,
    ["Recipe: Bravil's Best Beet Risotto"] = true,
    ["Recipe: Bravil Bitter Barley Beer"] = true,
    ["Recipe: Colovian Ginger Beer"] = true,
    ["Recipe: Dragontail Blended Whisky"] = true,
    ["Recipe: Firsthold Fruit and Cheese Plate"] = true,
    ["Recipe: Fredas Night Infusion"] = true,
    ["Recipe: Garlic-and-Pepper Venison Steak"] = true,
    ["Recipe: Markarth Mead"] = true,
    ["Recipe: Hagraven's Tonic"] = true,
    ["Recipe: Hearty Garlic Corn Chowder"] = true,
    ["Recipe: Lilmoth Garlic Hagfish"] = true,
    ["Recipe: Melon-Baked Parmesan Pork"] = true,
    ["Recipe: Millet and Beef Stuffed Peppers"] = true,
    ["Recipe: Muthsera's Remorse"] = true,
    ["Recipe: Rose Herbal Tea"] = true,
    ["Recipe: Soothing Bard's-Throat Tea"] = true,
    ["Recipe: Tenmar Millet-Carrot Couscous"] = true,
    ["Recipe: Thrice-Baked Gorapple Pie"] = true,
    ["Recipe: Tomato Garlic Chutney"] = true,
    ["Recipe: Psijic Ambrosia, Fragment VI"] = true,
    ["Recipe: Psijic Ambrosia, Fragment V"] = true,
    ["Recipe: Psijic Ambrosia, Fragment I"] = true,
    ["Recipe: Psijic Ambrosia, Fragment II"] = true,
    ["Recipe: Psijic Ambrosia, Fragment III"] = true,
    ["Recipe: Psijic Ambrosia, Fragment IV"] = true,
}

LibUrilkUIData.wristItemsId = {
    [76827] = true, -- Damage Health Poison IX
    [76829] = true, -- Damage Magicka Poison IX
    [76831] = true, -- Damage Stamina Poison IX
    [76826] = true, -- Drain Health Poison IX
    [54339] = true, -- Essence of Health -- Blue Entoloma, Luminous Russula
    [54340] = true, -- Essence of Magicka - Corn Flower, Bugloss
    [54341] = true, -- Essence of Stamina
    [44812] = true, -- Essence of Ravage Health
    [68236] = true, -- Firsthold Fruit and Cheese Plate
    [68263] = true, -- Hagraven's Tonic
    [68239] = true, -- Hearty Garlic Corn Chowder
    [68235] = true, -- Lilmoth Garlic Hagfish
    [68257] = true, -- Markarth Mead
    [68260] = true, -- Muthsera's Remorse
}

LibUrilkUIData.keepItemsId = {
    [33271] = true, -- Soul Gem
    [30357] = true, -- Lockpick
    [44879] = true, -- Equipment Repair Kit
    [120763] = true, -- Dubious Camoran Throne
    -- [27038] = true, -- Essence of Stamina
}

LibUrilkUIData.autoOpenContainersName = {
    -- Wrist
    ["Enchanter's Coffer I"] = true,
    ["Provisioner's Pack I"] = true,
    ["Alchemist's Vessel I"] = true,
    ["Jewelry Crafter's Coffer I"] = true,
    ["Woodworker's Case I"] = true,
    ["Clothier's Satchel (Cloth) I"] = true,
    ["Clothier's Satchel (Leather) I"] = true,
    ["Blacksmith's Crate I"] = true,
    ['Shipment of Leather I'] = true,
    ['Shipment of Ounces I'] = true,
    ['Shipment of Cloth I'] = true,
    ['Shipment of Ingots I'] = true,
    ['Shipment of Planks I'] = true,
    ['Shipment of Planks 1'] = true,
    ["Enchanter's Coffer II"] = true,
    ["Provisioner's Pack II"] = true,
    ["Alchemist's Vessel II"] = true,
    ["Jewelry Crafter's Coffer II"] = true,
    ["Woodworker's Case II"] = true,
    ["Clothier's Satchel (Cloth) II"] = true,
    ["Clothier's Satchel (Leather) II"] = true,
    ["Blacksmith's Crate II"] = true,
    ['Shipment of Leather II'] = true,
    ['Shipment of Ounces II'] = true,
    ['Shipment of Cloth II'] = true,
    ['Shipment of Ingots II'] = true,
    ['Shipment of Planks II'] = true,
    ["Enchanter's Coffer III"] = true,
    ["Provisioner's Pack III"] = true,
    ["Alchemist's Vessel III"] = true,
    ["Jewelry Crafter's Coffer III"] = true,
    ["Woodworker's Case III"] = true,
    ["Clothier's Satchel (Cloth) III"] = true,
    ["Clothier's Satchel (Leather) III"] = true,
    ["Blacksmith's Crate III"] = true,
    ['Shipment of Leather III'] = true,
    ['Shipment of Ounces III'] = true,
    ['Shipment of Cloth III'] = true,
    ['Shipment of Ingots III'] = true,
    ['Shipment of Planks III'] = true,
    ["Enchanter's Coffer IV"] = true,
    ["Provisioner's Pack IV"] = true,
    ["Alchemist's Vessel IV"] = true,
    ["Jewelry Crafter's Coffer IV"] = true,
    ["Woodworker's Case IV"] = true,
    ["Clothier's Satchel (Cloth) IV"] = true,
    ["Clothier's Satchel (Leather) IV"] = true,
    ["Blacksmith's Crate IV"] = true,
    ['Shipment of Leather IV'] = true,
    ['Shipment of Ounces IV'] = true,
    ['Shipment of Cloth IV'] = true,
    ['Shipment of Ingots IV'] = true,
    ['Shipment of Planks IV'] = true,
    ["Enchanter's Coffer V"] = true,
    ["Provisioner's Pack V"] = true,
    ["Alchemist's Vessel V"] = true,
    ["Jewelry Crafter's Coffer V"] = true,
    ["Woodworker's Case V"] = true,
    ["Clothier's Satchel (Cloth) V"] = true,
    ["Clothier's Satchel (Leather) V"] = true,
    ["Blacksmith's Crate V"] = true,
    ['Shipment of Leather V'] = true,
    ['Shipment of Ounces V'] = true,
    ['Shipment of Cloth V'] = true,
    ['Shipment of Ingots V'] = true,
    ['Shipment of Planks V'] = true,
    ["Enchanter's Coffer VI"] = true,
    ["Provisioner's Pack VI"] = true,
    ["Alchemist's Vessel VI"] = true,
    ["Jewelry Crafter's Coffer VI"] = true,
    ["Woodworker's Case VI"] = true,
    ["Clothier's Satchel (Cloth) VI"] = true,
    ["Clothier's Satchel (Leather) VI"] = true,
    ["Blacksmith's Crate VI"] = true,
    ['Shipment of Ounces VI'] = true,
    ['Shipment of Cloth VI'] = true,
    ['Shipment of Ingots VI'] = true,
    ['Shipment of Planks VI'] = true,
    ["Enchanter's Coffer VII"] = true,
    ["Provisioner's Pack VII"] = true,
    ["Alchemist's Vessel VII"] = true,
    ["Jewelry Crafter's Coffer VII"] = true,
    ["Woodworker's Case VII"] = true,
    ["Clothier's Satchel (Cloth) VII"] = true,
    ["Clothier's Satchel (Leather) VII"] = true,
    ["Blacksmith's Crate VII"] = true,
    ['Shipment of Leather VII'] = true,
    ['Shipment of Ounces VII'] = true,
    ['Shipment of Cloth VII'] = true,
    ['Shipment of Ingots VII'] = true,
    ['Shipment of Planks VII'] = true,
    ["Enchanter's Coffer VIII"] = true,
    ["Provisioner's Pack VIII"] = true,
    ["Alchemist's Vessel VIII"] = true,
    ["Jewelry Crafter's Coffer VIII"] = true,
    ["Woodworker's Case VIII"] = true,
    ["Clothier's Satchel (Cloth) VIII"] = true,
    ["Clothier's Satchel (Leather) VIII"] = true,
    ["Blacksmith's Crate VIII"] = true,
    ['Shipment of Leather VIII'] = true,
    ['Shipment of Ounces VIII'] = true,
    ['Shipment of Cloth VIII'] = true,
    ['Shipment of Ingots VIII'] = true,
    ['Shipment of Planks VIII'] = true,
    ["Enchanter's Coffer IX"] = true,
    ["Provisioner's Pack IX"] = true,
    ["Alchemist's Vessel IX"] = true,
    ["Jewelry Crafter's Coffer IX"] = true,
    ["Woodworker's Case IX"] = true,
    ["Clothier's Satchel (Cloth) IX"] = true,
    ["Clothier's Satchel (Leather) IX"] = true,
    ["Blacksmith's Crate IX"] = true,
    ['Shipment of Leather IX'] = true,
    ['Shipment of Ounces IX'] = true,
    ['Shipment of Cloth IX'] = true,
    ['Shipment of Ingots IX'] = true,
    ['Shipment of Planks IX'] = true,
    ["Enchanter's Coffer X"] = true,
    ["Provisioner's Pack X"] = true,
    ["Alchemist's Vessel X"] = true,
    ["Jewelry Crafter's Coffer X"] = true,
    ["Woodworker's Case X"] = true,
    ["Clothier's Satchel (Cloth) X"] = true,
    ["Clothier's Satchel (Leather) X"] = true,
    ["Blacksmith's Crate X"] = true,
    ['Shipment of Leather X'] = true,
    ['Shipment of Ounces X'] = true,
    ['Shipment of Cloth X'] = true,
    ['Shipment of Ingots X'] = true,
    ['Shipment of Planks X'] = true,

    -- Clockwork Daily
    ['Wrothgar Daily Contract Recompense'] = true,

    -- Gold Coast Daily
    ['Gold Coast Daily Contract Recompense'] = true,

    -- Vvardenfell Daily
    ['Hall of Justice Bounty Dispensation'] = true,
    ["Hall of Justice Explorer's Dispensation"] = true,

    -- Clockwork Daily
    ['Slag Town Coffer'] = true,
    ['Crow-Touched Clockwork Coffer'] = true,

    -- Summerset Daily
    ['Summerset Daily Recompense'] = true,

    -- Murkmire Daily
    ['Grand Tribal Armor Crate'] = true,
    ['Tribal Armor Crate'] = true,
    ['Tribal Boot Crate'] = true,

    -- Elsweyr Daily
    ['Elsweyr Daily Merit Coffer'] = true,
    ["Elsweyr Dragon Hunter's Coffer"] = true,
    ["Half-Digested Adventurer's Backpack"] = true,
    ['Wax-Sealed Heavy Sack'] = true,
    ['Dragonguard Supply Cache'] = true,

    -- Solstice Daily
    ['Solstice Reward Coffer'] = true,

    -- Guild Daily
    ['Stormhaven Mages Guild Merits'] = true,
    ['Greenshade Fighters Guild Merits'] = true,
    ['The Rift Undaunted Merits'] = true,

    -- PvP Rewards
    ["Battlemaster Rivyn's Competitive Reward Box"] = true,
    ['Rewards for the Worthy'] = true,

    -- Transmutation Geode
    ['Transmutation Geode (1)'] = true,
    ['Transmutation Geode (10)'] = true,
    ['Transmutation Geode (25)'] = true,
    ['Transmutation Geode (50)'] = true,

    -- misc
    ['Hidden Treasure Bag'] = true,
}