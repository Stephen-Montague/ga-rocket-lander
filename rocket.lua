require "dna"
require "vec2"

-- Rocket constructor
-- Expects vector2d for each parameter
Rocket = {}
function Rocket:new(location, target, velocity)
  local _rocket = {}
  setmetatable(_rocket, Rocket)
  self.__index = self
  
  _rocket.location = location or getDefaultLocation()
  _rocket.target = target or getDefaultTarget()
  _rocket.velocity = velocity or Vec2(0)
  _rocket.acceleration = Vec2(0)
  _rocket.dna = DNA:new()
  _rocket.geneIndex = 1 --Begin on first gene of DNA

  return _rocket
end

--Expects a Vec2 force, adds this force to current acceleration.
function Rocket:applyForce(force)
-- Formula: Force == Mass * Accel
-- For simple physics: ignore mass (mass == 1)
-- All applied forces accumulate into acceleration
  self.acceleration = self.acceleration + force 
end

function Rocket:run()
  self:applyForce(self.dna.genes[self.geneIndex])
  self.geneIndex = self.geneIndex + 1
  self:update()
end

function Rocket:update()
  self.velocity = self.velocity + self.acceleration
  self.location = self.location + self.velocity
  self.acceleration = Vec2(0)
end

-- Fitness is the inverse of distance: low distance has high fitness
-- Scaled by 1000, so most values are between 1-1000. 
-- Examples:
-- Distance < 0.8 pixel has clamp: 1250
--   1 pixel distance has fitness: 1000
--  10 pixel distance has fitness:  100
-- 100 pixel distance has fitness:   10
-- 800 pixel distance has fitness:    1.25
-- Distance >1000 pixel has clamp:    1 
-- Keeps a chance of reproduction for all
-- (May rewrite this function to be exponential, not linear: f(x) = x^2)
function Rocket:calcFitness()
  local distance = Vec2:manhattanDistance(self.location, self.target)
  if distance < 0.8 then
    distance = 0.8
  elseif distance > 1000 then
    distance = 1000
  end
  self.fitness = (1 / distance) * 1000 
  return self.fitness
end

function getDefaultLocation()
  local x = math.floor(love.graphics.getWidth()*0.5)
  local y = math.floor(love.graphics.getHeight()*0.98)
  return Vec2:new(x, y)
end

function getDefaultTarget()
  local x = math.floor(love.graphics.getWidth()*0.2)
  local y = math.floor(love.graphics.getHeight()*0.2)
  return Vec2:new(x, y)
end


