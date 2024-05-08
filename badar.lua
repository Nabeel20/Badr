--
-- badar
--
-- Copyright (c) 2024 Nabeel
--
-- This library is free software; you can redistribute it and/or modify it
-- under the terms of the MIT license. See LICENSE for details.
--
local badar = function(obj)
    local self = {
        id = 'default',
        x = 0,
        y = 0,
        width = 0,
        height = 0,
        _style = {
            color = { 1, 1, 1 },
            hoverColor = nil,
            padding = { 0, 0, 0, 0 }, -- top, right, bottom, left
            corner = 0,
            opacity = 1,
            scale = 1,
            visible = true,
            borderWidth = 0,
            borderColor = { 0, 0, 0 }
        },
        children = {},
        globalPosition = { x = 0, y = 0 },
        passMouseEvent = true
    }
    for key, value in pairs(obj) do
        self[key] = value
    end

    --
    self.drawSelf = function()
        local drawRectangle = function(mode)
            love.graphics.rectangle(
                mode,
                math.round(-self.width / 2),
                math.round(-self.height / 2),
                math.round(self.width),
                math.round(self.height),
                self._style.corner,
                self._style.corner
            )
        end
        love.graphics.push()
        love.graphics.translate(math.round(self.x + self.width / 2), math.round(self.y + self.height / 2))
        love.graphics.scale(self._style.scale, self._style.scale)
        drawRectangle('fill')

        -- drawing border
        if self._style.borderWidth > 0 then
            love.graphics.setColor(self._style.borderColor)
            love.graphics.setLineWidth(self._style.borderWidth)
            drawRectangle('line')
            love.graphics.setLineWidth(1)
        end
        love.graphics.pop()
    end
    self.draw = function()
        if not self._style.visible then
            return function()
                return self
            end
        end

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
        self:drawSelf()

        return function()
            love.graphics.push()
            love.graphics.translate(
                math.round(self.x + self._style.padding[4]),
                math.round(self.y + self._style.padding[1]))
            local sW, sH = love.graphics.getWidth(), love.graphics.getHeight()
            self.globalPosition.x, self.globalPosition.y = love.graphics.inverseTransformPoint(sW, sH)
            self.globalPosition.x = math.round(sW - self.globalPosition.x)
            self.globalPosition.y = math.round(sH - self.globalPosition.y)
            for _, child in ipairs(self.children) do
                child:draw()()
            end
            love.graphics.pop()

            return self
        end
    end
    self.render = function()
        self.update()
        self.draw()()
    end

    --
    self.style = function(style)
        for key, value in pairs(style) do
            self._style[key] = value
        end
        return self
    end
    self.content = function(content, layout)
        assert(type(content) == 'table', 'Badar. Content passed to container must be a table.')
        self.children = content;
        local children = self.children;
        local padding = {
            horizontal = self._style.padding[2] + self._style.padding[4],
            vertical = self._style.padding[1] + self._style.padding[3]
        }
        local gap = (layout.gap or 0) * (#children - 1)
        local isVertical = layout.direction == 'column';
        local contentWidth = 0
        local contentHeight = 0


        for _, child in ipairs(children) do
            child.parent = {
                width = self.width,
                height = self.height
            }
            if child.width == 0 then
                child.width = math.round(self.width * (child.xratio or 1))
            end
            if child.height == 0 then
                child.height = math.round(self.height * (child.yratio or 1))
            end
            contentWidth = contentWidth + child.width + gap
            contentHeight = contentHeight + child.height + gap
        end

        if self.width == 0 and self.parent == nil then
            assert(false, 'Container with children without width')
        end
        if self.height == 0 and self.parent == nil then
            assert(false, 'Container with children without height')
        end

        -- justify
        local contentDimension = self.width - contentWidth
        if isVertical then contentDimension = self.height - contentHeight end
        local offset = {
            ['start'] = 0,
            ['center'] = contentDimension / 2,
            ['end'] = contentDimension,
            ['space-between'] = 0
        }
        --- @diagnostic disable-next-line: cast-local-type
        offset = offset[(layout.justify or 'start')]

        if layout.justify == 'space-between' then
            layout.gap = 0
            layout.gap = (contentDimension - layout.gap) / (#children - 1)
        end

        -- direction and centering
        for _, child in ipairs(children) do
            if layout.centered then
                if #self.children > 1 then
                    assert(false, 'Centered container must have one child, add them to a container.')
                end
                child.x = math.round((self.width - child.width - padding.horizontal) / 2)
                child.y = math.round((self.height - child.height - padding.vertical) / 2)
                break;
            end

            if isVertical then
                child.y = offset;
                offset = offset + child.height + (layout.gap or 0)

                local alignment = {
                    ['start'] = 0,
                    ['center'] = math.round((self.height - padding.horizontal - child.width) / 2),
                    ['end'] = math.round(self.height - padding.horizontal - child.height)
                }
                child.x = alignment[layout.alignment or 'start']

                if child.alignSelf == 'end' then
                    child.y = math.round(self.height - child.height - padding.vertical)
                end
                if child.alignSelf == 'center' then
                    child.y = math.round((self.height - child.height - padding.horizontal) / 2)
                end
            else -- row
                child.x = offset;
                offset = offset + child.width + (layout.gap or 0)
                local alignment = {
                    ['start'] = 0,
                    ['center'] = math.round((self.height - padding.vertical - child.height) / 2),
                    ['end'] = math.round(self.height - padding.vertical - child.height)
                }
                child.y = alignment[layout.alignment or 'start'];

                if child.alignSelf == 'end' then
                    child.x = math.round(self.width - child.width - padding.horizontal)
                end
                if child.alignSelf == 'center' then
                    child.x = math.round((self.width - child.width - padding.horizontal) / 2)
                end
            end
        end
        return self;
    end

    --
    self.update = function()
        if type(self.onUpdateFunction) == "function" then
            self:onUpdateFunction()
        end
        for _, child in ipairs(self.children) do
            child.update()
        end
        return self
    end
    self.onUpdate = function(func)
        self.onUpdateFunction = func
        return self
    end

    --
    self.mousereleased = function()
        if not self.passMouseEvent then return end;
        if self.pressed and type(self.onMouseRealease_function) == "function" then
            self:onMouseRealease_function()
        end
        for _, child in ipairs(self.children) do
            child:mousereleased()
        end
    end
    self.onMouseRelease = function(func)
        self.onMouseRealease_function = func;
        return self;
    end

    -- utilities
    self.modify = function(func)
        func(self);
        return self;
    end
    self.find = function(target)
        if self.id == target then
            return self
        end

        for _, child in ipairs(self.children or {}) do
            local result = child.find(target)
            if result ~= nil then
                return result
            end
        end

        return nil
    end
    local isMouseInside = function()
        local getRect = function()
            return {
                self.globalPosition.x - self._style.padding[4],
                self.globalPosition.y - self._style.padding[1],
                (self.globalPosition.x + self.width - self._style.padding[2]),
                (self.globalPosition.y + self.height - self._style.padding[3])
            }
        end
        local px, py = love.mouse.getX(), love.mouse.getY()
        local rect = getRect()

        local x, y, width, height = rect[1], rect[2], rect[3], rect[4]
        return px >= x and px <= width and py >= y and py <= height
    end
    --
    self.mousemoved = function()
        if not self.passMouseEvent then return end;
        if isMouseInside() then
            self.hovered = true
            if type(self.onEnter) == "function" then
                self.onEnter(self)
            end
            self.mouseEntered = true
        else
            self.hovered = false
            if self.mouseEntered then
                if type(self.onExit) == "function" then
                    self.onExit(self)
                end
                self.mouseEntered = false
            end
        end
        for _, child in ipairs(self.children) do
            child.mousemoved()
        end
    end
    self.onHover = function(hoverLogic)
        for key, value in pairs(hoverLogic) do
            self[key] = value
        end
        return self;
    end

    --
    self.onClick = function(func, mouseButton)
        self.onClick_function = func
        self.mouseButton = mouseButton or 1
        self.pressed = true
        return self
    end
    self.mousepressed = function(btn)
        if not self.passMouseEvent then return end;
        local events = {}
        self.handlePress(btn, function(data)
            table.insert(events, data)
        end)
        if #events > 1 then
            events[#events].func(events[#events].self)
        elseif #events > 0 then
            events[1].func(events[1].self)
        end
    end
    self.handlePress = function(button, func)
        if isMouseInside() and button == self.mouseButton then
            if type(self.onClick_function) == "function" then
                if type(func) == "function" then
                    func({
                        func = self.onClick_function,
                        self = self,
                        id = self.id
                    })
                end
            end
        end
        for _, child in ipairs(self.children) do
            child.handlePress(button, func)
        end
    end

    return self
end

function math.round(num) return math.floor(num + .5) end

function table.spread(t1, t2)
    for key, value in pairs(t2) do
        t1[key] = value
    end
    return t1
end

return badar
