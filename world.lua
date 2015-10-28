-- World module

world = { }

path_maps = "maps/lua/"


-- Initializes the physics world and its settings
function world.init(stimap)
  -- Declare map or default to map 'init' if one is not provided as an argument
  if stimap == nil then
    map = sti.new(path_maps.."init.lua", { "box2d" })
  else
    print(Tserial.pack(stimap))
    map = sti.new(path_maps..stimap[1]..".lua", { "box2d" })
  end
  
  -- Creates a physics world for it
  world.world = lp.newWorld(0, 0)
  
  -- Sets up collisions
  map:box2d_init(world.world)
  world.world:setCallbacks(beginContact, endContact, preSolve, postSolve)
  
  world.initializeObjects() -- Separated for organization's sake
  sprites.init()
  print("Create")
  if stimap ~= nil and stimap[2] ~= nil and stimap[3] ~= nil then
    sprites.createPlayer(stimap[2] * 64 + 32, stimap[3] * 64 + 36)
  else
    sprites.createPlayer(6 * 64, 6 * 64)
  end
end



-- Initializes objects in the physics world
function world.initializeObjects()
  -- Checks if there is an 'Objects' layer, if not, it returns
  if map.layers["Objects"] == nil then
    function createObjects()
      print("ERROR!: No object layer found. Unable to create objects.")
    end
    return
  end
  
  -- If there is an object layer, it adds the objects there to the physics world
  objLayer = map.layers["Objects"]
  objs = {}
  for _, obj in pairs(objLayer.objects) do
    table.insert(objs, obj)
  end
  
  map:convertToCustomLayer("Objects")
  
  -- Creates special processing for the objLayer in updating
  function objLayer:update(dt)
    
  end
  
  -- Creates special processing for the objLayer in drawing
  function objLayer:draw(dt)
    
  end
  
  -- Creates the objects
  function world.createObjects()
    for _, obj in ipairs(objs) do
      local newObject = obj
      
    end
  end
end

--Collision callbacks
function beginContact(a, b, coll)
  aData = a:getUserData() -- usually a tile/object
  bData = b:getUserData() -- usually the player
  
  if a:isSensor() then
    world.init(Tserial.unpack(aData.properties.go_to))
  end
end

function endContact(a, b, coll)
  
end

function preSolve(a, b, coll)
  
end

function postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
  
end
