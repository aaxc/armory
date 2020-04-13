-- @TODO: Add settings with option to disable specific character saves

Armory = {
    name = "Armory",
    version = "1.3.0",
    variableVersion = 11,
    author = "@Aaxc",
    account = GetDisplayName(),
    character = GetUnitName("player"),
    total = GetEarnedAchievementPoints(),
    Default = {
    },
    raidCategories = {
        [1] = 'Hel Ra Citadel',
        [2] = 'Aetherian Archive',
        [3] = 'Sanctum Ophidia',
        [4] = 'Dragonstar Arena',
        [5] = 'Maw of Lorkhaj',
        [6] = 'Halls of Fabrication',
        [7] = 'Asylum Sanctorium',
        [8] = 'Cloudrest',
        [9] = 'Blackrose Prison',
        [10] = 'Sunspire',
    },
    raidIds = {
        [1] = '636',
        [2] = '638',
        [3] = '639',
        [4] = '635',
        [5] = '725',
        [6] = '975',
        [7] = '1000',
        [8] = '1051',
        [9] = '1082',
        [10] = '1121',
    },
}

Export = {
    name = "Export"
}

-- Export function
function Export:Init()
    Armory.savedVariables = ZO_SavedVars:NewCharacterIdSettings("ArmoryExport", Armory.variableVersion, nil, Armory.Default)

    -- Create main user data array
    local characterCount = GetNumCharacters()
    local mainData = {}
    local mainCharacter = {}
    local MxName = Armory.character .. "^Mx"
    local FxName = Armory.character .. "^Fx"

    for c = 1, characterCount do
        local characterInfo = {
            GetCharacterInfo(c)
        }
        if characterInfo[1] == MxName or characterInfo[1] == FxName then
            mainCharacter = {
                GetCharacterInfo(c)
            }
        end
    end

    -- Get raid scores
    mainData.Trials = {}
    for raidIndex, raidName in ipairs(Armory.raidCategories) do
        local currentScore, maxScore = GetRaidLeaderboardLocalPlayerInfo(RAID_CATEGORY_TRIAL, raidIndex)
        mainData.Trials[Armory.raidIds[raidIndex]] = maxScore
    end

    -- Get total achievements categories count
    categoryCount = GetNumAchievementCategories()
    categories = {}
    for i = 1, categoryCount do
        achievementInfo = GetAchievementCategoryInfo(i)

        categories[i] = {
            GetAchievementCategoryInfo(i)
        }

        -- Get Sub category count
        subCategoryCount = categories[i][2]
        subCategories = {}
        for k = 0, subCategoryCount do
            subCategories[k] = {
                GetAchievementSubCategoryInfo(i, k)
            }

            -- Get achievements from sub category
            achievementCount = subCategories[k][2]
            achievements = {}
            achievementCriteria = {}
            achievementsRewards = {}
            relatedAchievements = {}
            for j = 0, achievementCount do
                -- achievement Id
                achievementId = GetAchievementId(i, k, j)

                -- achievement achievement info
                achievements[achievementId] = {
                    GetAchievementInfo(achievementId)
                }

                -- achievement criteria count
                critCount = GetAchievementNumCriteria(achievementId)
                if critCount > 0 then
                    achievementCriteria[achievementId] = {}
                    for k = 1, critCount do
                        achievementCriteria[achievementId][k] = {
                            GetAchievementCriterion(achievementId, k)
                        }
                    end
                end

                -- add achievement rewards
                rewards = GetAchievementNumRewards(achievementId)
                if rewards > 1 then -- I am assuming 1 rewards is always the points
                    achievementsRewards[achievementId] = {}

                    -- check collectible rewards
                    r1 = {
                        GetAchievementRewardCollectible(achievementId)
                    }
                    if r1[1] == true then
                        achievementsRewards[achievementId]['collectible'] = {
                            GetCollectibleInfo(r1[2])
                        }
                        achievementsRewards[achievementId]['collectible']['tid'] = r1[2]
                    end

                    -- check collectible rewards
                    r2 = {
                        GetAchievementRewardDye(achievementId)
                    }
                    if r2[1] == true then
                        achievementsRewards[achievementId]['style'] = {
                            GetCollectibleInfo(r2[2])
                        }
                        achievementsRewards[achievementId]['style']['tid'] = r2[2]
                    end

                    -- check collectible rewards
                    r3 = {
                        GetAchievementRewardItem(achievementId)
                    }
                    if r3[1] == true then
                        achievementsRewards[achievementId]['item'] = {}
                        achievementsRewards[achievementId]['item']['1'] = r3[2]
                    end

                    -- check collectible rewards
                    r4 = {
                        GetAchievementRewardTitle(achievementId)
                    }
                    if r4[1] == true then
                        achievementsRewards[achievementId]['title'] = {}
                        achievementsRewards[achievementId]['title']['1'] = r4[2]
                    end
                end

                -- check if related achievements
                firstInLine = GetFirstAchievementInLine(achievementId)
                relatedAchievements[firstInLine] = {}
                line = firstInLine
                order = 0
                while line > 0 do
                    order = order + 1
                    -- save as related achievement
                    relatedAchievements[firstInLine][line] = {
                        GetAchievementInfo(line)
                    }
                    relatedAchievements[firstInLine][line]['priority'] = order

                    -- get next in line
                    line = GetNextAchievementInLine(line)
                end
            end
            for j = 0, achievementCount do
                -- achievement Id
                achievementId = GetAchievementId(i, nil, j)

                -- achievement achievement info
                achievements[achievementId] = {
                    GetAchievementInfo(achievementId)
                }

                -- achievement criteria count
                critCount = GetAchievementNumCriteria(achievementId)
                if critCount > 0 then
                    achievementCriteria[achievementId] = {}
                    for k = 1, critCount do
                        achievementCriteria[achievementId][k] = {
                            GetAchievementCriterion(achievementId, k)
                        }
                    end
                end

                -- add achievement rewards
                rewards = GetAchievementNumRewards(achievementId)
                if rewards > 1 then -- I am assuming 1 rewards is always the points
                    achievementsRewards[achievementId] = {}

                    -- check collectible rewards
                    r1 = {
                        GetAchievementRewardCollectible(achievementId)
                    }
                    if r1[1] == true then
                        achievementsRewards[achievementId]['collectible'] = {
                            GetCollectibleInfo(r1[2])
                        }
                        achievementsRewards[achievementId]['collectible']['tid'] = r1[2]
                    end

                    -- check collectible rewards
                    r2 = {
                        GetAchievementRewardDye(achievementId)
                    }
                    if r2[1] == true then
                        achievementsRewards[achievementId]['style'] = {
                            GetCollectibleInfo(r2[2])
                        }
                        achievementsRewards[achievementId]['style']['tid'] = r2[2]
                    end

                    -- check collectible rewards
                    r3 = {
                        GetAchievementRewardItem(achievementId)
                    }
                    if r3[1] == true then
                        achievementsRewards[achievementId]['item'] = {}
                        achievementsRewards[achievementId]['item']['1'] = r3[2]
                    end

                    -- check collectible rewards
                    r4 = {
                        GetAchievementRewardTitle(achievementId)
                    }
                    if r4[1] == true then
                        achievementsRewards[achievementId]['title'] = {}
                        achievementsRewards[achievementId]['title']['1'] = r4[2]
                    end
                end

                -- check if related achievements
                firstInLine = GetFirstAchievementInLine(achievementId)
                relatedAchievements[firstInLine] = {}
                line = firstInLine
                order = 0
                while line > 0 do
                    order = order + 1
                    -- save as related achievement
                    relatedAchievements[firstInLine][line] = {
                        GetAchievementInfo(line)
                    }
                    relatedAchievements[firstInLine][line]['priority'] = order

                    -- get next in line
                    line = GetNextAchievementInLine(line)
                end
            end

            subCategories[k].achievements = achievements
            subCategories[k].achievementCriteria = achievementCriteria
            subCategories[k].achievementsRewards = achievementsRewards
            subCategories[k].relatedAchievements = relatedAchievements
        end

        categories[i].subCategories = subCategories
    end

    -- Add total achievement points for current character
    mainData.EarnedAchievementPoints = GetEarnedAchievementPoints()
    mainData.content = {
        AchievementCategoryCount = categoryCount,
        AchievementCategories = categories
    }

    Armory.savedVariables.ServerName = GetWorldName()
    Armory.savedVariables.CharacterInfo = mainCharacter
    Armory.savedVariables.ChampionPoints = GetPlayerChampionPointsEarned()
    Armory.savedVariables.TotalAchievementPoints = GetTotalAchievementPoints()
    Armory.savedVariables.MainData = mainData
end

-- Main armory data
function Armory:Initialize()
    Export:Init()
    Armory.inCombat = IsUnitInCombat("player")
end

-- Update on new achievement
function Armory.AchievementChanged(eventCode, name, points, id, link)
    d('Armory: ' .. name)
    Export:Init()
    Armory.total = GetEarnedAchievementPoints()
end

-- Then we create an event handler function which will be called when the "addon loaded" event
-- occurs. We'll use this to initialize our addon after all of its resources are fully loaded.
function Armory.OnAddOnLoaded(event, addonName)
    -- The event fires each time *any* addon loads - but we only care about when our own addon loads.
    if addonName == Armory.name then
        Armory:Initialize()
    end
end

-- Initialize command request
function commands(extra)
    Export:Init()
end

SLASH_COMMANDS["/armoryupdate"] = commands

-- Finally, we'll register our event handler function to be called when the proper event occurs.
EVENT_MANAGER:RegisterForEvent("ArmoryLoaded", EVENT_ADD_ON_LOADED, Armory.OnAddOnLoaded)
EVENT_MANAGER:RegisterForEvent("ArmoryAchievementChanged", EVENT_ACHIEVEMENT_AWARDED, Armory.AchievementChanged)
