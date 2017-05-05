function onLoad()
  imports_playerBoard = Global.call('importPlayerBoard')
  imports_playerBoard.call('createNavigationButtons', {mat = self})
end

imports_playerBoard = nil

matSettings = {
  scriptZoneGuid = 'ad0dc5',
  deckOffset = {x=-7.68, z=-0.65}
}

function getMatSettings()
  return matSettings
end