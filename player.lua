-- The Lion's Blaze (player and sprite module)

players = { }
sprites = { }

path_sprites = "assets/sprites/"

bac = { }
bac.bac = "assets/bac/"
bac.base = bac.bac.."bases/"
bac.clothes = bac.bac.."clothes/"
bac.hair = bac.bac.."hair/"
bac.clothesf = bac.bac.."clothes_f/"
bac.hairf = bac.bac.."hair_f/"

function sprites.init()
  if map.layers["Sprite Layer"] then
    map:convertToCustomLayer("Sprite Layer")
  else
    map:addCustomLayer("Sprite Layer")
  end
  spriteLayer = map.layers["Sprite Layer"]
  spriteLayer.sprites = { }
  
  function spriteLayer:update(dt)
    
    for _, sprite in pairs(self.sprites) do
      
      -- Player
      if sprite.type == "player" then
        player = spriteLayer.sprites["player"]
        -- Controls
        sprite.keypressed.down = lk.isDown(sprite.keys.down)
        sprite.keypressed.up = lk.isDown(sprite.keys.up)
        sprite.keypressed.right = lk.isDown(sprite.keys.right)
        sprite.keypressed.left = lk.isDown(sprite.keys.left)
        
        -- Update sprite animations if movement keys are pressed
        if (sprite.keypressed.right or sprite.keypressed.left or sprite.keypressed.up or sprite.keypressed.down) then
          sprite.animright:update(dt)
          sprite.animleft:update(dt)
          sprite.animup:update(dt)
          sprite.animdown:update(dt)
        end
        
        -- Right & Left
        if sprite.keypressed.right then
          sprite.facing = "right"
          sprite.xm = 1
        elseif sprite.keypressed.left then
          sprite.facing = "left"
          sprite.xm = -1
        else
          sprite.xm = 0
        end
        -- Down & Up
        if sprite.keypressed.down then
          sprite.facing = "down"
          sprite.ym = 1
        elseif sprite.keypressed.up then
          sprite.facing = "up"
          sprite.ym = -1
        else
          sprite.ym = 0
        end
        
        -- Apply motion to body
        sprite.body:setLinearVelocity(sprite.xm * sprite.speed, sprite.ym * sprite.speed)
        
        -- Retrieve body's world coordinates
        if not sprite.body:isDestroyed() then
          sprite.x, sprite.y = sprite.body:getWorldCenter()
        end
      end
    end
  end
  
  function spriteLayer:draw()
    for _, sprite in pairs(self.sprites) do
      local x = math.floor(sprite.x) - 16
      local y = math.floor(sprite.y) - 20
      
      lg.setColor(color.white)
      if sprite.facing == "down" then
        if sprite.isCustom then
          sprite.animdown:draw(sprite.spritebase, x, y)
          sprite.animdown:draw(sprite.spriteclothes, x, y)
          sprite.animdown:draw(sprite.spritehair, x, y)
        else
          sprite.animdown:draw(sprite.sprite, x, y)
        end
      elseif sprite.facing == "up" then
        if sprite.isCustom then
          sprite.animup:draw(sprite.spritebase, x, y)
          sprite.animup:draw(sprite.spriteclothes, x, y)
          sprite.animup:draw(sprite.spritehair, x, y)
        else
          sprite.animup:draw(sprite.sprite, x, y)
        end
      elseif sprite.facing == "right" then
        if sprite.isCustom then
          sprite.animright:draw(sprite.spritebase, x, y)
          sprite.animright:draw(sprite.spriteclothes, x, y)
          sprite.animright:draw(sprite.spritehair, x, y)
        else
          sprite.animright:draw(sprite.sprite, x, y)
        end
      elseif sprite.facing == "left" then
        if sprite.isCustom then
          sprite.animleft:draw(sprite.spritebase, x, y)
          sprite.animleft:draw(sprite.spriteclothes, x, y)
          sprite.animleft:draw(sprite.spritehair, x, y)
        else
          sprite.animleft:draw(sprite.sprite, x, y)
        end
      end
      
      if debugdraw then
        lg.setColor(color.red)
        lg.circle("line", sprite.x, sprite.y, 16)
      end
      lg.setColor(color.white)
    end
  end
end

function sprites.createPlayer(ox, oy)
  local newPlayer = { }
  newPlayer.type = "player"
  newPlayer.ox = ox
  newPlayer.oy = oy
  newPlayer.x = ox
  newPlayer.y = oy
  
  
  -- Sprite
  newPlayer.facing = "down"
  newPlayer.sex = 'm'
  newPlayer.isCustom = false
  if not newPlayer.isCustom then
    newPlayer.sprite = lg.newImage(path_sprites.."mBard01.png")
  else
    newPlayer.spritebase = lg.newImage(bac.base.."reg.png")
    newPlayer.clothes = "healer"
    newPlayer.hair = "healer"
    if newPlayer.sex == 'f' then
      newPlayer.spriteclothes = lg.newImage(bac.clothesf..newPlayer.clothes.."_f.png")
      newPlayer.spritehair = lg.newImage(bac.hairf..newPlayer.hair.."_f.png")
    else
      newPlayer.spriteclothes = lg.newImage(bac.clothes..newPlayer.clothes..".png")
      newPlayer.spritehair = lg.newImage(bac.hair..newPlayer.hair..".png")
    end
  end
  
  -- Sprite (anim8)
  if not newPlayer.isCustom then
    newPlayer.grid = anim8.newGrid(32, 36, newPlayer.sprite:getWidth(), newPlayer.sprite:getHeight())
  else
    newPlayer.grid = anim8.newGrid(32, 36, newPlayer.spritebase:getWidth(), newPlayer.spritebase:getHeight())
  end
  newPlayer.animdown = anim8.newAnimation(newPlayer.grid('1-4', 3), 0.2)
  newPlayer.animright = anim8.newAnimation(newPlayer.grid('1-4', 2), 0.2)
  newPlayer.animup = anim8.newAnimation(newPlayer.grid('1-4', 1), 0.2)
  newPlayer.animleft = anim8.newAnimation(newPlayer.grid('1-4', 4), 0.2)
  
  -- Physics
  newPlayer.body = lp.newBody(world.world, newPlayer.ox/2, newPlayer.oy/2, "dynamic")
  newPlayer.shape = lp.newCircleShape(15)
  newPlayer.fixture = lp.newFixture(newPlayer.body, newPlayer.shape)
  newPlayer.fixture:setUserData({otype = "player"})
  newPlayer.body:setLinearDamping(.1)
  newPlayer.body:setFixedRotation(true)
  newPlayer.speed = 100
  
  -- Controls
  newPlayer.keys = {down = "down", up = "up", right = "right", left = "left"}
  newPlayer.keypressed = {down = false, up = false, right = false, left = false}
  newPlayer.xm = 0
  newPlayer.ym = 0
  
  -- Add player sprite to sprite queue
  spriteLayer.sprites["player"] = newPlayer
  print("Created")
end

function sprites.updateSprites()
  for _, sprite in pairs(spriteLayer.sprites) do
    if sprite.type == "player" then
      if player.sex == 'f' then
        player.spriteclothes = lg.newImage(bac.clothesf..player.clothes.."_f.png")
        player.spritehair = lg.newImage(bac.hairf..player.hair.."_f.png")
      else
        player.spriteclothes = lg.newImage(bac.clothes..player.clothes..".png")
        player.spritehair = lg.newImage(bac.hair..player.hair..".png")
      end
    end
  end
end

function sprites.setSprite(var, val)
  if player == nil then
    return
  end
  if var == "sex" then
    player.sex = val
  elseif var == "hair" then
    if not (lfs.exists(bac.hair..val..".png") or lfs.exists(bac.hairf..val.."_f.png")) then
      print("No can do")
      return
    end
    player.hair = val
  end
  sprites.updateSprites()
end
