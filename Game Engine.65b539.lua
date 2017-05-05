-- Properties
heroes = {
}
environment = {
}
villain = {
}

villainStartOfTurnCallbacks = {}
villainEndOfTurnCallbacks = {}

environmentStartOfTurnCallbacks = {}
environmentEndOfTurnCallbacks = {}

heroStartOfTurnCallbacks = {}
heroEndOfTurnCallbacks = {}

function onLoad(save_state)
  print(self.getName())
end

function addHero(param)
  for _, v in ipairs(heroes) do
    if v.characterCards.name == 'Original' then
      print(v.name)
    else
      print(v.name .. '-' .. v.characterCards.name)
    end
  end
  table.insert(heroes, param)
end
function removeHero(param)
end

function addEnvironment(param)
  environment = param
end
function removeEnvironment()
  environment = {}
end

function addVillain(param)
  villain = param
end
function removeVillain()
  villain = {}
end

-- Registration functions
function registerVillainStartOfTurnCallback(params)
end
function unregisterVillainStartOfTurnCallback(params)
end
function registerVillainEndOfTurnCallback(params)
end
function unregisterVillainEndOfTurnCallback(params)
end

function registerEnvironmentStartOfTurnCallback(params)
end
function unregisterEnvironmentStartOfTurnCallback(params)
end
function registerEnvironmentEndOfTurnCallback(params)
end
function unregisterEnvironmentEndOfTurnCallback(params)
end

function registerHeroStartOfTurnCallback(params)
end
function unregisterHeroStartOfTurnCallback(params)
end
function registerHeroEndOfTurnCallback(params)
end
function unregisterHeroEndOfTurnCallback(params)
end