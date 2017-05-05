function onload()
    --[[ print('Onload!') --]]
    imports_PlayerBoard = Global.call('importPlayerBoard')
    imports_CardPlayZone = Global.call('importCardPlayZone')
    imports_GameEngine = Global.call('importGameEngine')
end

-- Imported modules
imports_PlayerBoard = {}
imports_CardPlayZone = {}
imports_GameEngine = {}

function setupPlayerMat(params)
  local hero = params.hero
  local zone = params.zone
  local characterCards = params.characterCards
  local player = params.player

  if hero ~= nil then
    cloneHero(zone, characterCards, hero)

    imports_GameEngine.call('addHero', {
      name = hero.name,
      characterCards = characterCards
    })
  end
end

function getPlayerBoard(hero)
  return imports_PlayerBoard.call('getPlayerBoard', {player = hero.playerMat})
end

function getPlayerMatPosition(hero)
  local playerBoard = getPlayerBoard(hero)
  local playerMatPosition = nil

  if playerBoard ~= nil then
    playerMatPosition = playerBoard.getPosition()
  end

  return playerMatPosition
end

function getPlayerMatRotation(hero)
  local playerBoard = getPlayerBoard(hero)
  local playerMatRotation = nil

  if playerBoard ~= nil then
    playerMatRotation = playerBoard.getRotation()
  end

  return playerMatRotation
end

function cloneHero(zone, characterCards, hero)
  local heroZone = nil

  heroZone = getObjectFromGUID(zone.guid)
  for _, v in ipairs(heroZone.getObjects()) do
    if v.tag == 'Deck' then
        cloneHeroCharacterCards(v, characterCards, hero)
    else
      if v.tag == 'Bag' then
          cloneHeroBag(v, hero)
      end
    end
  end
end

function cloneHeroCharacterCards(deck, characterCards, hero)
    local playerMatSettings = getPlayerBoard(hero).call('getPlayerMatSettings')
    local playerMatPosition = getPlayerMatPosition(hero)
    local newDeck = nil

    if playerMatPosition ~= nil then
      newDeck = cloneHeroObject(deck, playerMatPosition, hero)

      if characterCards.type == 'Individual' then
        cloneIndividualHeroCharacterCards(hero, playerMatSettings, playerMatPosition, characterCards, newDeck)
      else
        if characterCards.type == 'Group' then
          cloneGroupHeroCharacterCards(hero, playerMatSettings, playerMatPosition, characterCards, newDeck)
        end
      end

      newDeck.destruct()
    end
end

function cloneIndividualHeroCharacterCards(hero, playerMatSettings, playerMatPosition, characterCards, newDeck )
    local counter = getCounterForPlayerBoard(hero)
    local characterCardPosition = {
      x = playerMatPosition.x + playerMatSettings.characterCardOffset.x,
      y = playerMatPosition.y + 0.2,
      z = playerMatPosition.z + playerMatSettings.characterCardOffset.z
    }

    newDeck.takeObject({
      guid=characterCards.guid,
      position = characterCardPosition,
      callback = 'heroCharacterCardsLoadComplete',
      callback_owner = self,
      params = {characterCards = characterCards, counter = counter}
    })
end

function cloneGroupHeroCharacterCards(hero, playerMatSettings, playerMatPosition, characterCards, newDeck)
  local playBoard -- = getPlayerBoard(hero)
  local characterCardPosition = {
    x = playerMatPosition.x,
    y = playerMatPosition.y,
    z = playerMatPosition.z
  }

  playBoard = getPlayerBoard(hero)
  -- clone setup card to character card location
  cloneIndividualHeroCharacterCards(hero, playerMatSettings, playerMatPosition, characterCards, newDeck)

  -- now cycle through the group cards and put them into the play slots
  for i, v in ipairs(characterCards.characterCards) do
    characterCardPosition.x = characterCardPosition.x + i
    newDeck.takeObject({
      guid=v.guid,
      position = characterCardPosition,
      callback = 'groupHeroCharacterCardsLoadComplete',
      callback_owner = self,
      params = {playBoard = playBoard, characterCards = v}
    })
  end
end

function heroCharacterCardsLoadComplete(card, params)
  if params.counter ~= nil then
    params.counter.setValue(params.characterCards.health)
  end
end

function groupHeroCharacterCardsLoadComplete(card, params)
  card.setTable('cardDetails', params.characterCards)
  imports_CardPlayZone.call('addCardToZone', {
    playBoard = params.playBoard,
    card = card
  })
end

function getCounterForPlayerBoard(hero)
  return getPlayerBoard(hero).call('getCounter')
end

function cloneHeroBag(bag, hero)
    local playerMatSettings = getPlayerBoard(hero).call('getPlayerMatSettings')
    local playerMatPosition = getPlayerMatPosition(hero)
    local deckPosition = playerMatPosition
    local newBag = nil

    if playerMatPosition ~= nil then
      playerMatPosition.z = playerMatPosition.z + 2.5
      newBag = cloneHeroObject(bag, playerMatPosition, hero)

      deckPosition.x = deckPosition.x + playerMatSettings.deckOffset.x
      deckPosition.z = deckPosition.z + playerMatSettings.deckOffset.z
      newBag.takeObject({
        guid=newBag.getObjects()[1].guid,
        position = deckPosition,
        callback = 'heroDeckLoadComplete',
        callback_owner = self,
        params = {handColor = playerMatSettings.handColor}
      })
      newBag.destruct()
    end
end

function cloneHeroObject(object, playerMatPosition, hero)
  local playerMatRotation = getPlayerMatRotation(hero)
  local newObject = nil

  if playerMatRotation ~= nil then
    newObject = object.clone({position = playerMatPosition})
    newObject.setRotation(playerMatRotation)
  end

  return newObject
end

function heroDeckLoadComplete(deck, params)
  deck.flip()
  deck.shuffle()

  deck.dealToColor(4, params.handColor)
end