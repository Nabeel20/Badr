--
-- badar
--
-- Copyright (c) 2024 Nabeel
--
-- This library is free software; you can redistribute it and/or modify it
-- under the terms of the MIT license. See LICENSE for details.
--


badar = Object:extend()


function badar:calculateLayout()
    local width, height, widest, highest = 0, 0, 0, 0
    for _, child in ipairs(self.children) do
        width = width + child.width;
        height = height + child.height
        highest = math.max(child.height, highest)
        widest = math.max(child.width, widest)
    end
    local horizontalSpace = self._padding[4] + self._padding[2] + (self.gap * (#self.children - 1))
    local verticalSpace = self._padding[1] + self._padding[3] + (self.gap * (#self.children - 1))

    self.height = math.max(height + verticalSpace, self.minHeight)
    self.width = math.max(width + horizontalSpace, self.minWidth)
    self.height = math.max(math.max(height + verticalSpace, self.minHeight), self.height)
    self.width = math.max(math.max(width + horizontalSpace, self.minWidth), self.width)
    if self._row then
        self.height = highest + self._padding[1] + self._padding[3]
    end
    if self._column then
        self.width = widest + self._padding[4] + self._padding[2]
    end
    return self
end

function badar:new(obj)
    obj = obj or {}

    self.x = obj.x or 0
    self.y = obj.y or 0
    self.width = obj.width or 0
    self.height = obj.height or 0
    self.minWidth = obj.minWidth or 0
    self.minHeight = obj.minHeight or 0

    self._padding = obj.padding or { 0, 0, 0, 0 } -- top, right, bottom, left
    self._center = false
    self._row = false;
    self._column = false;
    self.gap = 0;

    self.hovered = false
    self.canHover = obj.canHover or false
    self.globalPosition = { x = 0, y = 0 }
    self.clickFunc = obj.onClick or function() end;
    self.hoverFunc = obj.onHover or function() end;
    self.drawFunc = function()
        local drawMode = (self.hovered and self.canHover) and 'fill' or 'line'
        if (self.background) then drawMode = 'fill' end
        love.graphics.rectangle(
            drawMode,
            self.x,
            self.y,
            self.width,
            self.height,
            self._rounded,
            self._rounded
        )
    end
    self._rounded = obj.rounded or 0
    self.parent = {
        width = 0,
        height = 0,
        padding = { 0, 0, 0, 0 },
    }
    self.children = obj.children or {}
    self.opacity = obj.opacity or 1 -- set to zero to hide border
    self._color = obj.color or { 1, 1, 1 }
    self.background = obj.background or false;
    return self
end

function badar:draw()
    love.graphics.setColor({ self._color[1], self._color[2], self._color[3], self.opacity })
    self.drawFunc()

    if self:isMouseInside() then
        self.hovered = true
        self:hoverFunc()
    else
        self.hovered = false
    end

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
    for _, c in ipairs(self.children) do
        c.x = offset;
        offset = offset + c.width + self.gap
    end
    self:align(self.alignment)
    return self;
end

function badar:column(gap)
    self.gap = gap or 0
    self._column = true

    local offset = 0
    for _, c in ipairs(self.children) do
        c.y = offset;
        offset = offset + c.height + self.gap
    end
    self:align(self.alignment)
    return self;
end

function badar:content(content)
    for _, c in ipairs(content) do
        c.parent = {
            width = self.width,
            height = self.height,
            padding = self._padding
        }
    end
    self.children = content;
    self:calculateLayout()

    if self._row then self:row(self.gap) end
    if self._column then self:column(self.gap) end
    if self._center then self:center() end
    self:align(self.alignment)
    return self;
end

function badar:onHover(func)
    self.hoverFunc = func
    return self
end

function badar:handleClick()
    if self:isMouseInside() then
        self:clickFunc()
        self.hovered = true
    else
        self.hovered = false
    end
end

function badar:onClick(func)
    self.clickFunc = func
    self.canHover = true
    return self
end

function badar:getRect()
    return {
        self.globalPosition.x - self._padding[4],
        self.globalPosition.y - self._padding[1],
        self.globalPosition.x + self.width - self._padding[2],
        self.globalPosition.y + self.height - self._padding[3]
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

function badar:isMouseInside()
    local px, py = love.mouse.getX(), love.mouse.getY()
    local rect = self:getRect()

    local rx1, ry1, rx2, ry2 = rect[1], rect[2], rect[3], rect[4]
    return px >= rx1 and px <= rx2 and py >= ry1 and py <= ry2
end

function badar:rounded(v)
    self._rounded = v
    return self
end

function badar:mousePressed(x, y, button)
    self:handleClick()
    for _, child in ipairs(self.children) do
        child:mousePressed(x, y, button)
    end
end

function badar:align(alignment)
    self.alignment = alignment
    local highest = 0
    local widest = 0
    for _, child in ipairs(self.children) do
        highest = math.max(child.height, highest)
        widest = math.max(child.width, widest)
    end
    if self._row then
        for _, child in ipairs(self.children) do
            if child.height ~= highest then
                if self.alignment == 'center' then
                    child.y = (highest - child.height) / 2
                end
                if self.alignment == 'end' then
                    child.y = highest - child.height
                end
            end
        end
    end
    if self._column then
        for _, child in ipairs(self.children) do
            if child.width ~= widest then
                if self.alignment == 'center' then
                    child.x = (widest - child.width) / 2
                end
                if self.alignment == 'end' then
                    child.x = widest - child.width
                end
            end
        end
    end
    return self
end

return badar
