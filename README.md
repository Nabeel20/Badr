# Badar 🌕

Badar (Full moon in Arabic) is a declarative, flexbox inspired GUI library for LÖVE 2D.<br>
Badar focuses on composition, auto-layout and reactivity; width, height, position auto-calculated (if not provided) based on parent properties.

## Installation

The `badar.lua` file should be dropped into an existing project and required by it.<br>

Dependencies you should also add:

- [classic](https://github.com/rxi/classic) to make it easier to build your own UI components.
- [Hump:Signal](https://github.com/vrld/hump/blob/master/signal.lua) Pass mouse events for all elements.

### Example

```lua
function love.load()
    local container = require 'libs.badar'

    local button = container({ width = 25, height = 25 }):color({ 1, 0, 0 })
    local square = container({ width = 10, height = 10 }):color({ 0, 0, 1 }, true)

    main = container({ width = screenWidth, height = screenHeight })
        :content({
            square,
            button:onClick(function()
                square:update(function(sq)
                    sq.width = sq.width + 10;
                    return sq
                end)
            end),
        })
        :column()
        :padding({ 16, 16, 16, 16 })
end

function love.draw()
    main:render()
end
```

## Reactivity

You can define your UI tree of nodes within `love.load` or `love.draw`.<br>

- Use `load` function for animations purposes (e.g `flux`) or for readability.
- Use `draw` for more 'reactivity' as you don't need to use `:update()` function to update values, but you need to define your component within `draw`

## Functions

### Creating a new "container"

```lua
local container = require 'path.to.bardar.lua'
local c = container()
```

This function makes a new 'container' that can manage its 'children'. You can pass an optional table to set the `x`, `y`, `width`, and `height`. <br>
The container is based on a LÖVE `rectangle`. Space is distributed equally between children if props was not configured.

### :content({})

Adds children to container.

### :center()

Centers container's child.

### :row(gap)

This function aligns child elements along the x-axis, with a predefined `gap` of space between each element. The default value for the `gap` is set to 0.

### :column(gap)

This function aligns child elements along the y-axis, with a predefined `gap` of space between each element. The default value for the `gap` is set to 0.

### :color(color (table), fillBackground (boolean))

Sets color and draw mode of its container. The second argument is optional, and the default value is `false`.<br>
Set `canHover = true` to your container constructor to 'fill' the container on mouse hover.

### :padding({0,0,0,0})

This function adds padding to the container. The padding is applied in the following order: Top, Right, Bottom, and then Left.

### :onClick(fn)

Sets `fn` to be executed when mouse left button is clicked.

### update(function(o) return o end)

This function allows for the modification of container properties. You _must_ return argument to apply your updates.

```lua
container():update(function(o)
    o.canHover= true
    return o
end)
```

### :render()

Calls container and its children `draw` function

### :draw()

Used to override `draw` function when creating your own component. <br>
This function return another function to make sure the drawing order of children; use `:render()` as it is syntax sugar for `:draw()()`.

```lua
text = badar:extend()
function text:new(text)
    badar.new(self)
    self.text = text
end
function text:draw()
    love.graphics.print(self.text, self.x, self.y)
    return function()
        return self
    end
end
```

## License

This library is free software; you can redistribute it and/or modify it under
the terms of the MIT license. See [LICENSE](LICENSE) for details.
