--
-- badar
--
-- Copyright (c) 2024 Nabeel
--
-- This library is free software; you can redistribute it and/or modify it
-- under the terms of the MIT license. See LICENSE for details.
--


badar = Object:extend()

local function isPointInside(px, py, rect)
    px, py = px or 0, py or 0
    rect = rect or { 0, 0, 0, 0 }

    local rx1, ry1, rx2, ry2 = rect[1], rect[2], rect[3], rect[4]
    return px >= rx1 and px <= rx2 and py >= ry1 and py <= ry2
end

local function handleLayout(self)
    local results = 0;
    local total_width = self.width - self._padding[4] - self._padding[2] - (self.gap * (#self.children - 1))
    local total_height = self.height - self._padding[1] - self._padding[3] - (self.gap * (#self.children - 1))
    for _, child in ipairs(self.children) do
        if child.autoLayout.x or child.autoLayout.y then
            results = results + 1
        else
            total_width = total_width - child.width
            total_height = total_height - child.height
        end
    end

    return results, { width = total_width, height = total_height }
end


function badar:new(obj)
    obj = obj or {}

    self.x = obj.x or 0
    self.y = obj.y or 0
    self.width = obj.width or 0
    self.height = obj.height or 0
    self.autoLayout = { x = self.width == 0, y = self.height == 0 } -- to calculate dimensions automatically

    self._padding = obj.padding or { 0, 0, 0, 0 }                   -- top, right. bottom, left
    self._center = false
    self._row = false;
    self._column = false;
    self.gap = 0;

    self.hovered = false
    self.canHover = obj.canHover or false
    self.globalPosition = { x = 0, y = 0 }
    self.clickLogic = obj.onClick or function() end;

    self.parent = {
        width = 0,
        height = 0,
        padding = 0,
    }
    self.children = obj.children or {}
    self._color = obj.color or { 1, 1, 1, 0 }
    self.background = obj.background or false;

    Signal.register('mouseEvent', function(mx, my)
        self:onHover(mx, my)
    end)
    Signal.register('mousePressed', function(mx, my)
        self:handleClick(mx, my)
    end)
    return self
end

function badar:draw()
    love.graphics.setColor(self._color)
    love.graphics.rectangle(
        self:isHover(),
        self.x,
        self.y,
        self.width,
        self.height)

    return function()
        love.graphics.push()
        love.graphics.translate(math.floor(self.x + self._padding[4]), math.floor(self.y + self._padding[1]))
        self.globalPosition.x, self.globalPosition.y = love.graphics.inverseTransformPoint(screenWidth, screenHeight)
        self.globalPosition.x = screenWidth - self.globalPosition.x
        self.globalPosition.y = screenHeight - self.globalPosition.y

        local childrenNumber, available_space = handleLayout(self)
        local offset = 0;

        for _, child in ipairs(self.children) do
            if self._row then
                child.x = math.floor(offset);
                offset = offset + child.width + self.gap

                if child.autoLayout.x then
                    child.width = math.floor((1 / childrenNumber) * available_space.width)
                end
                if child.autoLayout.y then
                    child.height = self.height - self._padding[1] - self._padding[3]
                end
            end

            if self._column then
                child.y = math.floor(offset);
                offset = offset + child.height + self.gap

                if child.autoLayout.x then
                    child.width = self.width - self._padding[4] - self._padding[2]
                end
                if child.autoLayout.y then
                    child.height = (1 / childrenNumber) * available_space.height
                end
            end
            child:draw()()
        end
        love.graphics.pop()
        return self
    end
end

function badar:center()
    self._center = true
    for _, c in ipairs(self.children) do
        c.x = (c.parent.width - c.width) / 2 - c.parent.padding[4] - c.parent.padding[2]
        c.y = (c.parent.height - c.height) / 2 - c.parent.padding[1] - c.parent.padding[3]
    end
    return self;
end

function badar:row(gap)
    gap = gap or 0
    self.gap = gap
    self._row = true
    return self;
end

function badar:column(gap)
    gap = gap or 0;
    self.gap = gap
    self._column = true
    return self;
end

function badar:content(content)
    self.children = content;
    return self;
end

function badar:onHover(mx, my)
    if isPointInside(mx, my, self:getRect()) then
        self.hovered = true
    else
        self.hovered = false
    end
end

function badar:isHover()
    if self.hovered and self.canHover then
        return 'fill'
    end
    if self.background then
        return 'fill'
    end
    return 'line'
end

function badar:handleClick(mx, my)
    if isPointInside(mx, my, self:getRect()) then
        self.clickLogic()
        self.hovered = true
    else
        self.hovered = false
    end
end

function badar:onClick(command)
    self.clickLogic = command
    self.canHover = true
    return self
end

function badar:getRect()
    return { self.globalPosition.x, self.globalPosition.y, self.globalPosition.x + self.width, self.globalPosition.y +
    self.height }
end

function badar:render()
    return self:draw()()
end

function badar:color(color, isFilled)
    isFilled = isFilled or false
    self._color = color
    self.background = isFilled
    return self
end

function badar:padding(padding)
    self._padding = padding
    return self
end

function badar:update(func)
    self = func(self)
    return self
end

return badar
