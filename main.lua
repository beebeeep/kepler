w = 800
h = 600
GRAVITY=10000
math.randomseed(os.time())

function getDist(src, tgt) 
    dx = tgt.body:getX() - src.body:getX()
    dy = tgt.body:getY() - src.body:getY()
    return math.sqrt(dx*dx + dy*dy), dx, dy
end

function applyGravity(me, bodies)
    fx = 0
    fy = 0
    for i = 1, #bodies do
        obj = bodies[i]
        if me.id == obj.id then goto next end
        dist, dx, dy = getDist(me, obj)
        f = GRAVITY*obj.body:getMass()/(dist*dist)
        a = math.atan2(dy, dx)
        fx = fx + f*math.cos(a)
        fy = fy + f*math.sin(a)
        ::next::
    end
    me.body:applyForce(fx, fy)
end

function love.load()
    love.physics.setMeter(4)
    world = love.physics.newWorld(0, 0, false)
    objects = {}
    for i = 1, 40 do
        obj = {}
        obj.id = i
        obj.body = love.physics.newBody(world, math.random(w), math.random(h), "dynamic")
        obj.shape = love.physics.newCircleShape(10)
        obj.fixture = love.physics.newFixture(obj.body, obj.shape, 1)
        obj.fixture:setRestitution(0.9)
        obj.body:setLinearVelocity(25 - math.random(50), 25 - math.random(50))
        objects[i] = obj
    end
    ship = {}
    x = w/2
    y = h/2
    ship.id = 999
    ship.body = love.physics.newBody(world, x, y, "dynamic")
    ship.shape = love.physics.newPolygonShape(10,0, 0,30, 20,30)
    ship.fixture = love.physics.newFixture(ship.body, ship.shape, 1)
    ship.fixture:setRestitution(0.5)
    ship.body:setLinearVelocity(10,10)
end
 
-- Increase the size of the rectangle every frame.
function love.update(dt)
    world:update(dt)
  
    for i = 1, #objects do
       applyGravity(objects[i], objects)
    end

    applyGravity(ship, objects)

    if love.keyboard.isDown("right") then
        ship.body:applyAngularImpulse(100)
    elseif love.keyboard.isDown("left") then
        ship.body:applyAngularImpulse(-100)
    elseif love.keyboard.isDown("up") then
        a = ship.body:getAngle()
        f = 100
        ship.body:applyLinearImpulse(f*math.sin(a), -f*math.cos(a))
        ship.fire = true
    else 
    end
end
 
-- Draw a coloured rectangle.
function love.draw()
    for i = 1, #objects do 
        obj = objects[i]
        x, y = obj.body:getPosition()
        vx, vy = obj.body:getLinearVelocity()
        love.graphics.setColor(193,50,50)
        love.graphics.circle("fill", x, y, obj.shape:getRadius())
        love.graphics.setColor(255,255,255)
        love.graphics.line(x,y, x+vx*1, y+vy*1)
        --love.graphics.print(obj.f, x,y)
    end
    love.graphics.setColor(50, 200, 50)
    love.graphics.polygon('line', ship.body:getWorldPoints(ship.shape:getPoints()))
    love.graphics.print("X:" .. ship.body:getX() .. " Y: " .. ship.body:getY(), 0,0)
    if ship.fire then
        love.graphics.setColor(255, 160, 30)
        love.graphics.polygon('fill', ship.body:getWorldPoints(7,30, 10,40, 13,30 ))
        ship.fire = false
    end
end
