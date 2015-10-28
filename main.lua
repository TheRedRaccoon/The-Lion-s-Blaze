-- The Lion's Blaze (main file)
-- 
-- An interesting attempt at an interesting idea...
-- ...It all begins here...
-- 
--    ~TheRedRaccoon



-- LÖVE Shortcuts
la  = love.audio
le  = love.event
lfs = love.filesystem
lf  = love.font
lg  = love.graphics
li  = love.image
lj  = love.joystick
lk  = love.keyboard
lma = love.math
lm  = love.mouse
lp  = love.physics
ls  = love.sound
lsy = love.system
lth = love.thread
lt  = love.timer
lw  = love.window



-- Requires
--    Third-Party
GJ = require('gamejolt') -- Gamejolt Library
anim8 = require('anim8') -- Animation Library
require('lovedebug') -- Debugging Library
require('tserial') -- Table serializing Library
sti = require('STI') -- Tiled map conversion Library

--    In-house
require('color') -- Color list module
require('player') -- Player and sprite module
require('music') -- Music module
require('world') -- World module



-- On load (takes in command line arguments as a table)
function love.load(cmdargs)
  args = cmdargs
  lg.setBackgroundColor(color.bkblue)
  world.init()
end



-- On update (delta-time is represented by dt)
function love.update(dt)
  world.world:update(dt)
  map:update(dt)
end



-- On draw
function love.draw()
  local ww = lw.getWidth()
  local wh = lw.getHeight()
  
  if spriteLayer.sprites["player"] ~= nil and (map.width > (ww / 32) or map.height > (wh / 32)) then
    tx = math.floor(-spriteLayer.sprites["player"].x + ww / 2)
    ty = math.floor(-spriteLayer.sprites["player"].y + wh / 2)
  else
    tx = math.floor(((map.width * 32) / 2) + (ww/2) - 400)
    ty = math.floor(((map.height * 32) / 2) + (wh/2) - 300)
  end
  
  lg.push()
  lg.translate(tx, ty)
  map:setDrawRange(math.abs(tx), math.abs(ty), ww, wh)
  map:draw()
  
  if debugdraw then
    lg.setColor(color.yellow)
    map:box2d_draw()
  end
  lg.pop()
end



-- On window resize (width and height)
function love.resize(w, h)
  if map ~= nil then
    map:resize(w, h)
  end
end



-- On keypressed
function love.keypressed(key)
  --[[if codeline == nil then
    codeline = key
  elseif string.len(codeline) < 16 then
    codeline = codeline..key
  elseif string.len(codeline) >= 16 then
    codeline = string.sub(codeline, 2, 16)..key
  end
  
  if codeline ~= nil and string.len(codeline) >= 4 then
    if string.sub(codeline, -5) == "hello" then
      hwdraw = not hwdraw
    end
  end]]
  
  if key == 'c' then
    debugdraw = not debugdraw
  end
  
  if key == 'f12' then
    lw.setFullscreen(not lw.getFullscreen())
  end
end


  
-- On quit
function love.quit()
  if loggedin == true then
    GJ.closeSession()
  end
end



-- Checks the command-line arguments table for a specific string represented by 'key', if found, returns true
function checkArgsFor(key)
  if args == nil then
    return
  end
  for k, v in ipairs(args) do
    if key == v then
      print(v.." == "..key)
      return true
    else
      print(v.." ~= "..key)
    end
  end
  return false
end



-- Gets strings from the command-line arguments that append a command represented by 'key'
function getArgsFrom(key)
  local fin = string.len(key)
  if args == nil then
    return
  end
  for k, v in ipairs(args) do
    local word = string.sub(v, 0, fin)
    if key == word then
      print(word.." == "..key)
      return string.sub(v, fin + 1, string.len(v))
    else
      print(word.." ~= "..key)
    end
  end
  print("\""..key.."\" not found!")
  return
end

