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
            self._rounded[1],
            self._rounded[2]
        )
    end
    self._rounded = obj.rounded or { 0, 0 }
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
        --  love.mouse.setCursor(love.mouse.getSystemCursor("hand"))
        self.hovered = true
        self:hoverFunc()
    else
        --   love.mouse.setCursor()
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
    local autoLayoutChildren, availableSpace = calculateLayout(self)
    for _, c in ipairs(self.children) do
        c.x = offset;

        if c.autoLayout.x then
            c.width = availableSpace.width / autoLayoutChildren
        end
        if c.autoLayout.y then
            -- child expand to fill parent height
            c.height = self.height - self._padding[1] - self._padding[3]
        end
        offset = offset + c.width + self.gap
    end
    self:align(self.alignment)
    return self;
end

function badar:column(gap)
    self.gap = gap or 0
    self._column = true

    local offset = 0
    local autoLayoutChildren, availableSpace = calculateLayout(self)
    for _, c in ipairs(self.children) do
        c.y = offset;

        if c.autoLayout.y then
            c.height = availableSpace.height / autoLayoutChildren
        end
        if c.autoLayout.x then
            -- Child takes parent full width
            c.width = self.width - self._padding[4] - self._padding[2]
        end
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

function badar:fitContent()
    local width, height = 0, 0
    for _, child in ipairs(self.children) do
        width = width + child.width;
        height = height + child.height
    end
    self.width = width;
    self.height = height;
    self.autoLayout = { x = false, y = false }
    return self
end

return badar
