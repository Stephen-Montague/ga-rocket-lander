
-- Not used yet. Could add for future.

Obstacle = {}
function Obstacle:new(location, width, height)
  local obstacle = {}
  setmetatable(obstacle, Obstacle)
  self.__index = self

  obstacle.location = location
  obstacle.width = width
  obstacle.height = height
  return obstacle
end
