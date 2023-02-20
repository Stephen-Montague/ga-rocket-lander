require "util"
require "rocket"

Population = {}
function Population:new(rocketCount, mutationRate, maxAge, maxGen)
  local population = {}
  setmetatable(population, Population)
  self.__index = self

  population.rocketCount = rocketCount or 100
  population.mutationRate = mutationRate or 0.007
  population.maxAge = maxAge or 180 -- 3 second lifetime at 60 fps 
  population.maxGen = maxGen or 10
  population.age = 1
  population.generation = 1
  population.hasSolution = false

  population.best = {}
  population.best.dna = {}
  population.best.fitness = 0

  population.rockets = {}
  for i=1, population.rocketCount do
    population.rockets[i] = Rocket:new()
  end
  population.matingPool = {}

  return population
end

function Population:live()
  for i=1, self.rocketCount do
    self.rockets[i]:run()
  end
end

function Population:fitness()
  for i=1, self.rocketCount do
    local fitness = self.rockets[i]:calcFitness()
    if (fitness > self.best.fitness) then
      self.best.fitness = fitness
      self.best.dna = DNA:new(self.rockets[i].dna)
      if (fitness > 250) then -- Distance of 4 pixels or less 
        self.hasSolution = true
      end
    end
  end
end

function Population:selection()
  for i=1, self.rocketCount do
    local poolContribution = self.rockets[i].fitness
    for j=1, poolContribution do
      table.insert(self.matingPool, self.rockets[i].dna)
    end 
  end
end

function Population:reproduction()
  for i=self.rocketCount, 1, -1  do
    local index1 = love.math.random(1, #self.matingPool) 
    local index2 = love.math.random(1, #self.matingPool)
    local parent1 = self.matingPool[index1] --Parent1 DNA
    local parent2 = self.matingPool[index2] --Parent2 DNA
    local child = parent1:crossover(parent2) -- Child DNA
    child:mutate(self.mutationRate)
    self.rockets[i] = Rocket:new()
    self.rockets[i].dna = child
  end
  self.matingPool = {}
end

-- For text display: scale acceptable fitness to 100.
function Population:getTextFitness()
  return tostring(Util:round(population.best.fitness*0.4, 6)) 
end