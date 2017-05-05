function onload()
    --[[ print('Onload!') --]]
    imports_PlayerBoard = Global.call('importPlayerBoard')
    imports_CardPlayZone = Global.call('importCardPlayZone')
end

-- Imported modules
imports_PlayerBoard = {}
imports_CardPlayZone = {}

function setupEnvironmentMat(params)
  local environment = params.environment
  local zone = params.zone
  local player = params.player

  if environment ~= nil then
    cloneEnvironment(zone, environment)
  end
end

function getEnvironmentBoard()
  return imports_PlayerBoard.call('getEnvironmentBoard')
end

function getEnvironmentMatPosition()
  local environmentBoard = getEnvironmentBoard()
  local environmentMatPosition = nil

  if environmentBoard ~= nil then
    environmentMatPosition = environmentBoard.getPosition()
  end

  return environmentMatPosition
end

function getEnvironmentMatRotation()
  local environmentBoard = getEnvironmentBoard()
  local environmentMatPosition = nil

  if environmentBoard ~= nil then
    environmentMatPosition = environmentBoard.getRotation()
  end

  return environmentMatPosition
end

function cloneEnvironment(zone, environment)
  local environmentZone = nil

  environmentZone = getObjectFromGUID(zone.guid)
  for _, v in ipairs(environmentZone.getObjects()) do
    if v.tag == 'Bag' then
        cloneEnvironmentBag(v, environment)
    end
  end
end

function cloneEnvironmentBag(bag, environment)
    local environmentMatSettings = getEnvironmentBoard().call('getMatSettings')
    local environmentMatPosition = getEnvironmentMatPosition()
    local deckPosition = environmentMatPosition
    local newBag = nil

    if environmentMatPosition ~= nil then
      environmentMatPosition.z = environmentMatPosition.z + 2.5
      newBag = cloneEnvironmentObject(bag, environmentMatPosition, environment)

      deckPosition.x = deckPosition.x + environmentMatSettings.deckOffset.x
      deckPosition.z = deckPosition.z + environmentMatSettings.deckOffset.z
      newBag.takeObject({
        guid=newBag.getObjects()[1].guid,
        position = deckPosition,
        callback = 'environmentDeckLoadComplete',
        callback_owner = self,
        params = {}
      })
      newBag.destruct()
    end
end

function cloneEnvironmentObject(object, environmentMatPosition, hero)
  local playerMatRotation = getEnvironmentMatRotation(hero)
  local newObject = nil

  if playerMatRotation ~= nil then
    newObject = object.clone({position = environmentMatPosition})
    newObject.setRotation(playerMatRotation)
  end

  return newObject
end

function environmentDeckLoadComplete(deck, params)
  deck.flip()
  deck.shuffle()
end