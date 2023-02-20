  -- Declare & define Vector 2d
  -- with simple __add , __tostring , and distance functions.

  Vec2 = {} 
  
  -- Allow construction via direct call 
  function Vec2:__call(x, y)
    return self:new(x, y)
  end
  setmetatable(Vec2, Vec2)
  
  -- Constructor with x,y parameters
  -- No argument defaults to 0; one arg inits both to arg   
  function Vec2:new(x, y)
    local vec = {}
    setmetatable(vec, Vec2)
    self.__index = self
    vec.x = x or 0
    vec.y = y or x or 0
    return vec
  end
  
  function Vec2:__add(other)
    self.x, self.y = (self.x + other.x), (self.y + other.y) 
    return self
  end
  
  function Vec2:__tostring()
    return (self.x .. ":" .. self.y)
  end
  
  -- Expects two Vec2
  function Vec2:manhattanDistance(location, target)
    return math.abs(location.x - target.x) + math.abs(location.y - target.y)
  end
  
  --Test Script

  -- local a = Vec2:new()
  -- local b = Vec2:new(2)
  -- local c = Vec2:new(20,40)
  -- local output = a+b+c
  -- print(output)