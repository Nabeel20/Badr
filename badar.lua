--
-- badar
--
-- Copyright (c) 2024 Nabeel
--
-- This library is free software; you can redistribute it and/or modify it
-- under the terms of the MIT license. See LICENSE for details.
--


badar = Object:extend()



local function calculateLayout(self)
    local autoLayout_children = 0;
    local horizontal_padding = self._padding[4] + self._padding[2]
    local vertical_padding = self._padding[1] + self._padding[3]
    local gaps = (self.gap * (#self.children - 1))

    local available_width = self.width - horizontal_padding - gaps
    local available_height = self.height - vertical_padding - gaps

    for _, child in ipairs(self.children) do
        if child.autoLayout.x or child.autoLayout.y then
            autoLayout_children = autoLayout_children + 1
        else
            available_width = available_width - child.width
            available_height = available_height - child.height
        end
    end

    return autoLayout_children, { width = available_width, height = available_height }
end


function badar:new(obj)
    obj = obj or {}

    self.x = obj.x or 0
    self.y = obj.y or 0
    self.width = obj.width or 0
    self.height = obj.height or 0
    self.autoLayout = { x = self.width == 0, y = self.height == 0 } -- to calculate dimensions automatically

    self._padding = obj.padding or { 0, 0, 0, 0 }                   -- top, right, bottom, left
    self._center = false
    self._row = false;
    self._column = false;
    self.gap = 0;

    self.hovered = false
    self.canHover = obj.canHover or false
    self.globalPosition = { x = 0, y = 0 }
    self.clickLogic = obj.onClick or function() end;
    self.hoverLogic = obj.onHover or function()
        local mx, my = love.mouse.getPosition()
        if self:isPointInside(mx, my, self:getRect()) then
            self.hovered = true
        else
            self.hovered = false
        end
    end
    self._rounded = obj.rounded or { 0, 0 }
    self.parent = {
        width = 0,
        height = 0,
        padding = 0,
    }
    self.children = obj.children or {}
    self._color = obj.color or { 1, 1, 1, 0 }
    self.background = obj.background or false;

    return self
end

function badar:draw()
    self:onHover(self.hoverLogic)
    love.graphics.setColor(self._color)
    local drawMode = (self.hovered and self.canHover) and 'fill' or 'line'
    if (self.background) then drawMode = 'fill' end

    love.graphics.rectangle(
        drawMode,
        self.x,
        self.y,
        self.width,
        self.height,
        self._rounded[1],
        self.rounded[2]
    )

    return function()
        love.graphics.push()
        love.graphics.translate(math.floor(self.x + self._padding[4]), math.floor(self.y + self._padding[1]))
        self.globalPosition.x, self.globalPosition.y = love.graphics.inverseTransformPoint(screenWidth, screenHeight)
        self.globalPosition.x = screenWidth - self.globalPosition.x
        self.globalPosition.y = screenHeight - self.globalPosition.y

        for _, child in ipairs(self.children) do
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
    self.gap = gap or 0
    self._row = true
    local offset = 0
    local autoLayoutChildren, availableSpace = calculateLayout(self)
    for _, c in ipairs(self.children) do
        c.x = offset;
        offset = offset + c.width + self.gap

        if c.autoLayout.x then
            c.width = availableSpace.width / autoLayoutChildren
        end
        if c.autoLayout.y then
            -- child expand to fill parent height
            c.height = self.height - self._padding[1] - self._padding[3]
        end
    end
    return self;
end

function badar:column(gap)
    self.gap = gap or 0
    self._column = true

    local offset = 0
    local autoLayoutChildren, availableSpace = calculateLayout(self)
    for _, c in ipairs(self.children) do
        c.y = offset;
        offset = offset + c.height + self.gap

        if c.autoLayout.y then
            c.height = availableSpace.height / autoLayoutChildren
        end
        if c.autoLayout.x then
            -- Child takes parent full width
            c.width = self.width - self._padding[4] - self._padding[2]
        end
    end
    return self;
end

function badar:content(content)
    self.children = content;
    if self._row then self:row(self.gap) end
    if self._column then self:column(self.gap) end
    if self._center then self:center() end
    return self;
end

function badar:onHover(func)
    self.hoverLogic = func
    func(self)
    return self
end

function badar:handleClick(mx, my)
    if self:isPointInside(mx, my, self:getRect()) then
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
    return {
        self.globalPosition.x,
        self.globalPosition.y,
        self.globalPosition.x + self.width,
        self.globalPosition.y + self.height
    }
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
    if self._row then self:row(self.gap) end
    if self._column then self:column(self.gap) end
    if self._center then self:center() end
    return self
end

function badar:update(func)
    self = func(self)
    return self
end

function badar:isPointInside(px, py, rect)
    px, py = px or 0, py or 0
    rect = rect or { 0, 0, 0, 0 }

    local rx1, ry1, rx2, ry2 = rect[1], rect[2], rect[3], rect[4]
    return px >= rx1 and px <= rx2 and py >= ry1 and py <= ry2
end

function badar:rounded(v)
    self._rounded = v
    return self
end

function badar:mousePressed(x, y, button)
    self:handleClick(x, y)
    for _, child in ipairs(self.children) do
        child:mousePressed(x, y, button)
    end
end

return badar
