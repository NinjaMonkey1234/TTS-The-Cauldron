function onLoad()
  imports_playerBoard = Global.call('importPlayerBoard')
  imports_playerBoard.call('createNavigationButtons', {mat = self})
end

imports_playerBoard = nil

playerMatSettings = {
  counterGuid = '576a0a',
  characterCardOffset = {x=-6.63, z=1.4},
  deckOffset = {x=-6.63, z=-4.9},
  handColor = 'White',
  cardPlayZones = {
    settings = {
      rows = 2,
      columns = 6,
      firstCardOffset = {x=-3.54,y=0,z=1.40},
      rowNIncrement = -3.9,
      columnNIncrement = 2.52,
      firstCounterOffset = {x=-3.6,y=0,z=3.75},
      counterRowNIncrement = -8.6,
      counterColumnNIncrement = 2.55,
      healthCounterScale = {x=0.75,y=0.75,z=0.75}
    },
    cardsInZone = nil
  }
}

function getPlayerMatSettings()
  return playerMatSettings
end

function getCounter()
  return getObjectFromGUID(playerMatSettings.counterGuid)
end