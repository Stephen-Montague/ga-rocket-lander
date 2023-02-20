function love.load()
  scoreFont = love.graphics.newFont(40)
  labelFont = love.graphics.newFont(24)
  
  sprites = {}
  sprites.sky = love.graphics.newImage('sprites/sky.png')
  sprites.target = love.graphics.newImage('sprites/target.png')
  sprites.rocket = love.graphics.newImage('sprites/rocket.png')
  
  require "Population"
  population = Population:new()
  finalRocket = Rocket:new()
  fireRocket = false
end

function love.update()
  if population.generation <= population.maxGen then
    if (population.age <= population.maxAge) then
      population:live()  -- Simulate all rocket paths for 1 frame
      population.age = population.age + 1
    else
      population:fitness()
      if (population.hasSolution or population.generation == population.maxGen) then
        fireRocket = true
        finalRocket.dna = population.best.dna
        if(finalRocket.geneIndex <= #finalRocket.dna.genes) then
          finalRocket:run()
        end
      else
        population:selection()
        population:reproduction()
        population.generation = population.generation + 1
        population.age = 1
      end
    end
  end
end

function love.draw()
  drawSprites()
  drawHud()
end

function drawSprites()
  love.graphics.setColor(0.74,0.52,0.64)
  love.graphics.draw(sprites.sky, 0, 0)

  local target = finalRocket.target
  love.graphics.setColor(0,0.92,0.01)
  love.graphics.draw(sprites.target, target.x, target.y, nil, nil, nil, 20, 20)
 
  if (fireRocket) then
    local rocket = finalRocket
    love.graphics.setColor(1,0.9,1)
    love.graphics.draw(
      sprites.rocket, 
      rocket.location.x, 
      rocket.location.y, nil, nil, nil,
      16, 64) --Offset to center sprite by width (half of 32) & set rocket location to its base
  else
    love.graphics.setColor(0,0,1)
    for i=1, population.rocketCount do 
      local rocket = population.rockets[i]
      love.graphics.draw(
        sprites.rocket, 
        rocket.location.x, 
        rocket.location.y, nil, nil, nil,
        16, 64) 
    end
  end
end

function drawHud()
  love.graphics.setFont(scoreFont)
  love.graphics.printf(
    population:getTextFitness(), 0, 192, love.graphics.getWidth(), "center")

  love.graphics.setFont(labelFont)
  love.graphics.printf(
    "% Acceptable", 0, 228, love.graphics.getWidth(), "center")

  love.graphics.setFont(scoreFont)
  love.graphics.printf(
    population.generation .. " / " ..population.maxGen, 
    0, 256, love.graphics.getWidth(), "center")

  love.graphics.setFont(labelFont)
  love.graphics.printf(
    "Generation", 0, 292, love.graphics.getWidth(), "center")
end
