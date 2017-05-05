function onload()
    --[[ print('Onload!') --]]
    -- Import script blocks from Global
    imports_ScriptingZonesForSetup = Global.call('importScriptingZonesForSetup')
    imports_SetupPlayerBoard = Global.call('importSetupPlayerBoard')

    setupScriptingZones()
end

-- Imported modules
imports_ScriptingZonesForSetup = {}
imports_SetupPlayerBoard = {}

-- Properties
heroes = {
}

-- Methods
function setupScriptingZones()
  local scriptingZones = imports_ScriptingZonesForSetup.call('getHeroScriptingZones', {})

  for _, zone in pairs(scriptingZones) do
    zoneObjects = getObjectFromGUID(zone.guid).getObjects()
    for _, object in ipairs(zoneObjects) do
      if object.tag == 'Deck' then
        object.setTable('zone', zone)
        createChooseButton(zone, object)
      end
    end
  end
end

function createChooseButton(zone, object)
  local position = {0,0.8,-0.3}
  for i, v in pairs(zone.characterCards) do
    object.createButton({
      click_function = 'heroCharacterCard' .. i .. 'Chosen',
      function_owner = self,
      label = v.name,
      position = position,
      rotation = {0,0,0},
      width = 850,
      height = 100,
      font_size = 100,
      index = i
    })
    position[3] = position[3] + 0.3
  end
end

-- Until we can pass in custom paramters to the click function
-- I have to do it this way
function heroCharacterCard1Chosen(sender, player)
  heroCharacterCardChosen(sender, player, 1)
end
function heroCharacterCard2Chosen(sender, player)
  heroCharacterCardChosen(sender, player, 2)
end
function heroCharacterCard3Chosen(sender, player)
  heroCharacterCardChosen(sender, player, 3)
end
function heroCharacterCard4Chosen(sender, player)
  heroCharacterCardChosen(sender, player, 4)
end
function heroCharacterCard5Chosen(sender, player)
  heroCharacterCardChosen(sender, player, 5)
end
function heroCharacterCardChosen(sender, player, index)
  local zone = sender.getTable('zone')
  local hero = addHero(zone)

  if hero~= nil then
    imports_SetupPlayerBoard.call('setupPlayerMat', {
      hero = hero,
      zone = zone,
      characterCards = zone.characterCards[index],
      player = player
    })
  end
end

function addHero(zone)
  local index = getNextHeroIndex(zone)
  local hero = nil

  if index > 0 and index <= 5 then
    hero = {
      name = zone.deckName,
      playerMat = index
    }
    heroes['hero' .. index] = hero
   end

  return hero
end

function getNextHeroIndex(zone)
  local index = 1
  local hero = nil

  for i, v in pairs(heroes) do
    if v.name == zone.deckName then
      -- Hero already added.
      index = -1
      break
    else
      index = index + 1
    end
  end

  return index
end