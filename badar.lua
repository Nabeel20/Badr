--
-- badar
--
-- Copyright (c) 2024 Nabeel
--
-- This library is free software; you can redistribute it and/or modify it
-- under the terms of the MIT license. See LICENSE for details.
--
badar = Object:extend()


function badar:new(obj)
    obj = obj or {}
    self.id = obj.id or 'default id'
    self.x = obj.x or 0
    self.y = obj.y or 0
    self.width = obj.width or 0
    self.height = obj.height or 0
    self.minWidth = obj.minWidth or 0
    self.minHeight = obj.minHeight or 0

    self._style = {
        color = { 1, 1, 1 },
        hoverColor = nil,
        padding = { 0, 0, 0, 0 }, -- top, right, bottom, left
        corner = 0,
        opacity = 1,
        scale = 1,
        visible = true,
        borderWidth = 0,
        borderColor = { 0, 0, 0 }
    }
    self.gap = 0;
    self.hideBox = obj.hideBox or false;
    if self.hideBox then
        self._style.opacity = 0
    end
    self.hovered = false
    self.pressed = false

    self.globalPosition = { x = 0, y = 0 }
    self.children = obj.children or {}
    self.data = obj.data or nil

    self._hover = {
        onEnter = function(s) end,
        onExit = function(s) end
    }
    self._clickFn = obj.onClick or function() end;
    self._mouseReleaseFn = function() end;
    self._updateFn = function() end;
    self.drawSelf = function()
        love.graphics.rectangle(
            'fill',
            self.x,
            self.y,
            self.width,
            self.height,
            self._style.corner,
            self._style.corner
        )
    end
    self.drawBorder = function()
        if self._style.borderWidth > 0 then
            love.graphics.setColor(self._style.borderColor)
            love.graphics.setLineWidth(self._style.borderWidth)
            love.graphics.rectangle(
                'line',
                self.x - 1,
                self.y - 1,
                self.width + 2,
                self.height + 2,
                self._style.corner,
                self._style.corner
            )
            love.graphics.setLineWidth(1)
        end
    end
    self.setColor = function()
        local color = self._style.color
        if self.hovered and self._style.hoverColor then
            color = self._style.hoverColor
        end
        if color ~= nil then
            love.graphics.setColor({
                color[1],
                color[2],
                color[3],
                self._style.opacity
            })
        end
    end

    return self
end

function badar:draw()
    if not self._style.visible then
        return function()
            return self
        end
    end
    love.graphics.push()
    love.graphics.scale(self._style.scale)
    self.drawBorder()
    self.setColor()
    self.drawSelf()
    love.graphics.pop()

    return function()
        love.graphics.push()
        love.graphics.translate(math.floor(self.x + self._style.padding[4]), math.floor(self.y + self._style.padding[1]))
        local sW, sH = love.graphics.getWidth(), love.graphics.getHeight()
        self.globalPosition.x, self.globalPosition.y = love.graphics.inverseTransformPoint(sW, sH)
        self.globalPosition.x = sW - self.globalPosition.x
        self.globalPosition.y = sH - self.globalPosition.y

        for _, child in ipairs(self.children) do
            child:draw()()
        end

        love.graphics.pop()
        return self
    end
end

function badar:content(content)
    assert(type(content) == 'table', 'Badar. Content passed to container must be a table.')
    self.children = content;
    return self;
end

function badar:onHover(hoverLogic)
    for key, value in pairs(hoverLogic) do
        self._hover[key] = value
    end
    return self
end

function badar:onClick(func, mouseButton)
    self._clickFn = func
    self.mouseButton = mouseButton or 1
    self.pressed = true
    return self
end

function badar:getRect()
    return {
        self.globalPosition.x - self._style.padding[4],
        self.globalPosition.y - self._style.padding[1],
        (self.globalPosition.x + self.width - self._style.padding[2]) * self._style.scale,
        (self.globalPosition.y + self.height - self._style.padding[3]) * self._style.scale
    }
end

function badar:render()
    return self:draw()()
end

function badar:modify(func)
    func(self)
    return self
end

function badar:isMouseInside()
    local px, py = love.mouse.getX(), love.mouse.getY()
    local rect = self:getRect()

    local x, y, width, height = rect[1], rect[2], rect[3], rect[4]
    return px >= x and px <= width and py >= y and py <= height
end

function badar:mousepressed(button)
    if self:isMouseInside() and button == self.mouseButton then
        self:_clickFn()
    end
    for _, child in ipairs(self.children) do
        child:mousepressed(button)
    end
end

function badar:layout(obj)
    self.direction = obj.direction or nil
    self.gap       = obj.gap or 0;
    self.alignment = obj.alignment or nil;
    self.justify   = obj.justify or nil;
    self.centered  = obj.centered or false;
    local offset   = 0;
    local layout   = self:calculateLayout()
    local widest   = layout.widest + layout.padding.horizontal
    local highest  = layout.highest + layout.padding.vertical
    self.width     = layout.computedWidth;
    self.height    = layout.computedHeight;


    if #self.children == 0 then return self end
    local function center(child)
        if #self.children > 1 then
            print('ERROR: Badar. centered container must have only one child.')
        end
        child.x = (self.width - child.width - layout.padding.horizontal) / 2
        child.y = (self.height - child.height - layout.padding.vertical) / 2
    end

    local function row(child)
        child.x = offset;
        offset = offset + child.width + self.gap
        -- alignment
        if child.height ~= highest then
            if self.alignment == 'center' then
                child.y = (highest - child.height - layout.padding.vertical) / 2
            end
            if self.alignment == 'end' then
                child.y = highest - child.height - layout.padding.vertical
            end
        end
    end

    local function column(child)
        child.y = offset;
        offset = offset + child.height + self.gap
        --alignment
        if child.width ~= widest then
            if self.alignment == 'center' then
                child.x = (widest - child.width - layout.padding.horizontal) / 2
            end
            if self.alignment == 'end' then
                child.x = widest - child.width - layout.padding.horizontal
            end
        end
    end



    for _, child in ipairs(self.children) do
        if self.centered then center(child) end
        if self.direction == 'row' then row(child) end
        if self.direction == 'column' then column(child) end
        if child.justify == 'end' then
            if self.direction == 'row' then
                child.x = self.width - child.width - layout.padding.horizontal;
            end
            if self.direction == 'column' then
                child.y = self.height - child.height - layout.padding.vertical;
            end
        end
        if child.justify == 'center' then
            child.x = (self.width - child.width) / 2 - layout.padding.horizontal
            child.y = (self.height - child.height) / 2 - layout.padding.vertical
        end
    end

    if self.direction == 'row' then
        self.height = math.max(highest, self.minHeight)
    end
    if self.direction == 'column' then
        self.width = math.max(widest, self.minWidth)
    end
    return self
end

function badar:calculateLayout()
    local totalWidth, totalHeight, widest, highest = 0, 0, 0, 0
    for _, child in ipairs(self.children) do
        totalWidth = totalWidth + child.width;
        totalHeight = totalHeight + child.height
        highest = math.max(child.height, highest)
        widest = math.max(child.width, widest)
    end

    local hPadding = self._style.padding[4] + self._style.padding[2]
    local vPadding = self._style.padding[1] + self._style.padding[3]
    local gap = self.gap * (#self.children - 1)


    local contentWidth = (totalWidth + hPadding + gap) * self._style.scale;
    local contentHeight = (totalHeight + vPadding + gap) * self._style.scale

    local minimumWidth = math.max(contentWidth, self.minWidth)
    local minimumHeight = math.max(contentHeight, self.minHeight)


    return {
        highest = highest,
        widest = widest,
        padding = {
            horizontal = hPadding,
            vertical = vPadding
        },
        gap = gap,
        contentWidth = contentWidth,
        contentHeight = contentHeight,
        computedWidth = math.max(minimumWidth, self.width),
        computedHeight = math.max(minimumHeight, self.height)
    }
end

function badar:style(style)
    for key, value in pairs(style) do
        self._style[key] = value
    end
    return self
end

function badar:find(target)
    if self == nil then
        return nil
    end

    if self.id == target then
        return self
    end

    for i, child in ipairs(self.children or {}) do
        local result = child:find(target)
        if result ~= nil then
            return result
        end
    end

    return nil
end

function badar:mousemoved()
    if self:isMouseInside() then
        self.hovered = true
        self._hover.onEnter(self)
        self.mouseEntered = true
    else
        self.hovered = false
        if self.mouseEntered then
            self._hover.onExit(self)
            self.mouseEntered = false
        end
    end
    for _, child in ipairs(self.children) do
        child:mousemoved()
    end
end

function badar:mousereleased()
    if self.pressed then
        self:_mouseReleaseFn()
    end
    for _, child in ipairs(self.children) do
        child:mousereleased()
    end
end

function badar:onMouseRelease(func)
    self._mouseReleaseFn = func
    return self
end

function badar:onUpdate(func)
    self._updateFn = func
    return self
end

function badar:update()
    self:_updateFn()
    for _, child in ipairs(self.children) do
        child:update()
    end
end

return badar
