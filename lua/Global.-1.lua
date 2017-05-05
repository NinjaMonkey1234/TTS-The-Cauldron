--[[ Lua code. See documentation: http://berserk-games.com/knowledgebase/scripting/ --]]

--[[ The OnLoad function. This is called after everything in the game save finishes loading.
Most of your script code goes here. --]]
function onload()
    --[[ print('Onload!') --]]
    --setupScriptingZones()
end

--[[ Import methods. These methods are called by other modules to gain a reference to the
requested module--]]
function importScriptingZonesForSetup()
  return getObjectFromGUID('0ae4ef')
end

function importPlayerBoard()
  return getObjectFromGUID('0d0267')
end

function importSetupPlayerBoard()
  return getObjectFromGUID('c74676')
end

function importSetupEnvironmentBoard()
  return getObjectFromGUID('ef0f1d')
end

function importCardPlayZone()
  return getObjectFromGUID('38a2f8')
end

function importGameEngine()
  return getObjectFromGUID('65b539')
end