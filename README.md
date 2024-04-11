# Badar 🌕

Badar (Full moon in Arabic) is a declarative, flexbox inspired GUI library for LÖVE 2D.<br>
Badar focuses on composition, auto-layout and reactivity; width, height, position auto-calculated (if not provided) based on parent properties.

## Installation

The `badar.lua` file should be dropped into an existing project and required by it.<br>
💡 Define two global variables `screenWidth` and `screenHeight`, which badar uses them to calculate mouse position.

There are also dependencies that should be added to enhance functionality:

- [classic](https://github.com/rxi/classic) which simplifies the process of creating your own UI components.

### Usage

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

function love.mousepressed(x, y, button, istouch)
    main:mousePressed(x, y, button)
end
```

## Functions

### Creating a new "container"

```lua
local container = require 'path.to.badar.lua'
local c = container()
```

This function makes a new 'container' that can manage its 'children'. You can pass an optional table to set the `x`, `y`, `width`, and `height`. <br>
The container is based on a LÖVE `rectangle`. Space is distributed equally between children if props was not configured.

<details>
  <summary>Container's props</summary>
  
- ``x``,``y``,``width``,``height``
- `autoLayout` (table): a table with x and y keys, used to calculate layout if width and height are not defined.
- `canHover` (boolean): can be used to add hover effect without the logic added.
- `background` (boolean): if true container draw mode is fill.
</details>

### `:content({})`

Adds children to container.

### `:center()`

Centers container's child.

### `:row(gap)`

This function aligns child elements along the x-axis, with a predefined `gap` of space between each element. The default value for the `gap` is set to 0.

### `:column(gap)`

This function aligns child elements along the y-axis, with a predefined `gap` of space between each element. The default value for the `gap` is set to 0.

### `:color(color (table), fillBackground (boolean))`

Sets color and draw mode of its container. The second argument is optional, and the default value is `false`.<br>
Set `canHover = true` to your container constructor to 'fill' the container on mouse hover.

### `:padding({0,0,0,0})`

This function adds padding to the container. The padding is applied in the following order: Top, Right, Bottom, and then Left.

### `:onClick(fn)`

Sets `fn` to be executed when mouse left button is clicked.

### `:update(function(foo) return foo end)`

This function allows for the modification of container properties. You _must_ return argument to apply your updates.

> [!IMPORTANT]
> `update()` should be called the last in your calls chain. It depends on what you declare first.

```lua
container():content({children}):update(function(o)
    o.canHover= true
    return o
end)
```

### `:render()`

This function calls the `draw` function for the container and all of its children.
Should be called within `love.draw` function.


## License

This library is free software; you can redistribute it and/or modify it under
the terms of the MIT license. See [LICENSE](LICENSE) for details.
