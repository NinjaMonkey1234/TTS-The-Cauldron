function onload()
    --[[ print('Onload!') --]]
    -- Import script blocks from Global
    imports_ScriptingZonesForSetup = Global.call('importScriptingZonesForSetup')
    imports_SetupEnvironmentBoard = Global.call('importSetupEnvironmentBoard')

    setupScriptingZones()
end

-- Imported modules
imports_ScriptingZonesForSetup = {}
imports_SetupEnvironmentBoard = {}

-- Properties
environment = {
}

-- Methods
function setupScriptingZones()
  local scriptingZones = imports_ScriptingZonesForSetup.call('getEnvironmentScriptingZones', {})

  for _, zone in pairs(scriptingZones) do
    zoneObjects = getObjectFromGUID(zone.guid).getObjects()
    for _, object in ipairs(zoneObjects) do
      if object.tag == 'Card' then
        object.setTable('zone', zone)
        createChooseButton(zone, object)
      end
    end
  end
end

function createChooseButton(zone, object)
  local position = {0,0.8,-0.3}

  object.createButton({
    click_function = 'environmentChosen',
    function_owner = self,
    label = 'Choose',
    position = position,
    rotation = {0,0,0},
    width = 850,
    height = 100,
    font_size = 100
  })
end

function environmentChosen(sender, player)
  local zone = sender.getTable('zone')

  addEnvironment(zone)

  if environment~= nil then
    imports_SetupEnvironmentBoard.call('setupEnvironmentMat', {
      environment = environment,
      zone = zone,
      player = player
    })
  end
end

function addEnvironment(zone)
  if environment == nil then
    environment = {
      name = zone.deckName
    }
  end

  return environment
end