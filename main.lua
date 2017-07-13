w = 800
h = 600
GRAVITY=10000
math.randomseed(os.time())

function getDist(src, tgt) 
    dx = tgt.body:getX() - src.body:getX()
    dy = tgt.body:getY() - src.body:getY()
    return math.sqrt(dx*dx + dy*dy), dx, dy
end

function love.load()
    love.physics.setMeter(4)
    world = love.physics.newWorld(0, 0, false)
    objects = {}
    for i = 1, 40 do
        obj = {}
        obj.body = love.physics.newBody(world, math.random(w), math.random(h), "dynamic")
        obj.shape = love.physics.newCircleShape(10)
        obj.fixture = love.physics.newFixture(obj.body, obj.shape, 1)
        obj.fixture:setRestitution(0.9)
        obj.body:setLinearVelocity(25 - math.random(50), 25 - math.random(50))
        objects[i] = obj
    end
end
 
-- Increase the size of the rectangle every frame.
function love.update(dt)
    world:update(dt)
    for i = 1, #objects do
        fx = 0
        fy = 0
        for j = 1, #objects do
            if i == j then goto next end
            src = objects[i]
            tgt = objects[j]
            dist, dx, dy = getDist(src, tgt)
            f = GRAVITY*tgt.body:getMass()/(dist*dist)
            src.f = f
            a = math.atan2(dy, dx)
            fx = fx + f*math.cos(a)
            fy = fy + f*math.sin(a)
            ::next::
        end
        src.body:applyForce(fx, fy)
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
end