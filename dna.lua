-- Requires
require "vec2"

--DNA constructor
--Accepts optional parameters: DNA to clone or int geneCount
DNA = {}
function DNA:new(clone, geneCount)
  local dna = {}
  setmetatable(dna, DNA)
  self.__index = self

  local maxForce = 0.1 -- Use to scale force (vector magnitude) of a gene 
  dna.geneCount = geneCount or 180 -- Enough to drive for 2 seconds at 60 fps
  dna.genes = {}
  if (clone) then
    for i, gene in ipairs(clone.genes) do
      dna.genes[i] = Vec2:new(gene.x, gene.y)
    end
  else
    for i=1, dna.geneCount do
      dna.genes[i] = getRandomGene(maxForce)
    end    
  end
  return dna
end

--Cross DNA of self & partner
--Expects a DNA input
function DNA:crossover(partner)
  local geneCount = self.geneCount
  local child = DNA:new(nil, geneCount)
  local midpoint = love.math.random(geneCount)
  for i=1, geneCount do
    if (i > midpoint) then
      child.genes[i] = self.genes[i]
    else
      child.genes[i] = partner.genes[i]
    end
  end
  return child
end

--Expects a float, e.g., for 1% input 0.01
function DNA:mutate(mutationRate)
  for i=1, self.geneCount do
    if (love.math.random() < mutationRate) then
      self.genes[i] = getRandomGene()
    end
  end
end

--Get a uniform random 2d unit vector "gene" for a DNA instance
--Unit formula via: http://nbeloglazov.com/2017/04/09/random-vector-generation.html
function getRandomGene(scale)
  local phi = love.math.random(0, 6.2831853) --Get random angle around a unit circle
  local x = math.cos(phi) 
  local y = math.sin(phi)
  local magnitude = love.math.random(0, scale)
  x = x * magnitude
  y = y * magnitude
  return Vec2:new(x,y)
end

