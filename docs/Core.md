## Creating a new "container"

```lua
local container = require 'path.to.badar.lua'
local c = container({})
```

- `id`; a string can be used to find targeted notes.
- `x`and `y`; container's position.
- `width`, `height`; container's dimensions.
- `drawSelf`; drawing function that can be used to override default 'rectangle' drawing method (e.g `text` component uses `printf()`)
- `xratio` and `yratio`, a ratio (0 to 1) to calculate dimensions based on parent size.
- You can pass as a key-value in function argument or using dot operation (e.g, container.Value = 20)

This function makes a new 'container' that can manage its 'children'. <br>
The container is based on a LÖVE `rectangle`. Space is distributed equally between children if props was not configured.

### `.content(children {}, layout {})`

Adds children to container. Layout props:

```lua
{
    direction = 'row' -- or column
    gap = 0,
    alignment = 'center' , -- or end
    justify = 'end' -- or end
    centered = false
}

```

### `.find(id (string))`

Search container's children and return child which has the same id.

### `.style({})`

Overrides default container styles. Pass the key you want to override. **Padding is added to container dimensions**.

```lua
.style({
    color = { 1, 1, 1 },
    hoverColor = { 0, 1, 0 },
    padding = { 0, 0, 0, 0 }, -- top, right, bottom, left
    corner = 0,               -- corner radius
    opacity = 1,
    scale = 1,
    borderWidth = 2,
    borderColor = { 0, 0, 0 }
})
```

### `.onClick(fn, mouseButton(num))`

Assigns `fn` to be executed when mouse left button is clicked. The container is passed as an argument to `fn`. The second argument is an optional number, default is `1` for left mouse button. . This argument is used to specify which mouse button the function. Right mouse button is `2`.

### `.onHover({onEnter = fn, onExit = fn})`

Sets an _optional_ `onEnter` or `onExit` function to be respond to mouse events. Container props are passed to each function.

### `.onMouseRelease(fn)`

Calls the function if mouse was released after it was captured by container click event.

### `.modify(function(foo) end)`

This function allows for the modification of container properties. Can be used to animate container props (e.g `flux`).

```lua
container().content({children}):modify(function(o)
    o.width = 250
end)
```

### `.onUpdate(fn)`

Sets a function to be called every frame. Container's prop are passed as an argument to `fn`.
