function love.load()
    love.graphics.setDefaultFilter("nearest","nearest")
    love.window.setFullscreen(true)
    timer = 0



    player = {}
    player.x = 0
    player.y = 0
    player.speed = 200
    player.height = 100
    player.width = 100
    dirbox = {}
    dirbox.x = 0
    dirbox.y = 0
    dirbox.width = 0
    dirbox.height = 0
    bullets = {}
	bullets.speed = 7
    showdir = 0


    enemies = {}

   for i=0,7 do
      enemy = {}
      enemy.width = 80
      enemy.height = 70
      enemy.speed = 20
      enemy.x = i * (enemy.width+60) + 100
      enemy.y = enemy.height + 100
      table.insert(enemies, enemy)
   end
end
function love.draw()
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("fill",player.x,player.y,player.width,player.height)
    love.graphics.setColor(0,1,0)
    love.graphics.rectangle("fill",dirbox.x,dirbox.y,dirbox.width,dirbox.height)

	love.graphics.setColor(0.5, 0.5, 0.5)
	for i,v in ipairs(bullets) do
		love.graphics.circle("fill", v.x, v.y, 3)
	end
    for i,e in ipairs(enemies) do
        love.graphics.setColor(1,0,0)

        love.graphics.rectangle("fill",e.x,e.y,e.width,e.height)
    end
end

function love.update(dt)
    timer = timer + dt
        if timer >= 1 then

            timer = 0  
        end  
    local dir = { x = 0, y = 0 }

	bulletSpeed = 250

	for i,v in ipairs(bullets) do
		v.x = v.x + (v.dx * dt)
		v.y = v.y + (v.dy * dt)
        if v.y < 0 or v.x < 0 then
            table.remove(bullets, 1)
         end  
    end
--Quit on escape
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end
--MovementButtons
    if love.keyboard.isDown("d") then
        player.x = player.x + (player.speed * dt)
      end
      if love.keyboard.isDown("a") then
        player.x = player.x - (player.speed * dt)
      end
      if love.keyboard.isDown("s") then
        player.y = player.y + (player.speed * dt)
      end
      if love.keyboard.isDown("w") then
        player.y = player.y - (player.speed * dt)
    end
--ShootingButtons
    
    if love.keyboard.isDown('up') then 
       dir.y = -1
       showdir = 1
    elseif love.keyboard.isDown('down') then 
       dir.y = 1
       showdir = 3
    end
    if love.keyboard.isDown('left') then 
       dir.x = -1
       showdir = 4
    elseif love.keyboard.isDown('right') then
       dir.x =  1
       showdir = 2

    end
    if love.keyboard.isDown("left") or love.keyboard.isDown("right") or love.keyboard.isDown("up") or love.keyboard.isDown("down") then
        makeNewBullet(100 * dir.x, 100 * dir.y)
    end
    if showdir == 1 then
        dirbox.width = player.width
        dirbox.height = player.height / 10
        dirbox.x = player.x
        dirbox.y = player.y
    end
    if showdir == 2 then
        dirbox.width = player.width / 10
        dirbox.height = player.height
        dirbox.x = player.x + player.width - dirbox.width
        dirbox.y = player.y
    end
    if showdir == 3 then
        dirbox.width = player.width
        dirbox.height = player.height / 10
        dirbox.x = player.x
        dirbox.y = player.y + player.height - dirbox.height
    end
    if showdir == 4 then
        dirbox.width = player.width / 10
        dirbox.height = player.height
        dirbox.x = player.x
        dirbox.y = player.y
    end
    
    bullethitcheck(bullets,enemies)
end
function makeNewBullet(xvec,yvec)
    table.insert(bullets, {x = player.x + player.width / 2, y = player.y + player.height / 2, dx = xvec * bullets.speed, dy = yvec * bullets.speed})
end
function makeNewEnemy(xvec,yvec)
    table.insert(enemies, {x = math.random(0,1000), y = math.random(0,1000), dx = xvec * bullets.speed, dy = yvec * bullets.speed})
end
function bullethitcheck(bullets,enemies)
    for i, v in ipairs(bullets) do
        for z, e in ipairs(enemies) do
            if CheckCollision(v.x,v.y,6,6,e.x,e.y,e.width,e.height) then
                table.remove(bullets, i)
            end
        end
    end
end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
    return x1 < x2+w2 and
           x2 < x1+w1 and
           y1 < y2+h2 and
           y2 < y1+h1
  end