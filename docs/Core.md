## Creating a new "container"

```lua
local container = require 'path.to.badar.lua'
local c = container({})
```

- `id`; a string can be used to find targeted notes.
- `x`, `y`; container's position.
- `width`, `height`; container's dimensions.
- `minWidth`, `minHeight`; container's minimum dimensions.
- `drawFunc`; can be used to override default 'rectangle' drawing method (e.g `text` component uses `printf()`)
- `data`; a table you can pass any 'custom' data for your needs.

This function makes a new 'container' that can manage its 'children'. <br>
The container is based on a LÖVE `rectangle`. Space is distributed equally between children if props was not configured.

### `:content({})`

Adds children to container.

### `:find(id (string))`

Search container's children and return child which has the same id.

### `:style({})`

Overrides default container styles. Pass the key you want to override.

```lua
:style({
    color = { 1, 1, 1 },
    padding = { 0, 0, 0, 0 }, -- top, right, bottom, left
    corner = 0, -- corner radius
    opacity = 1,
    filled = false,
    hoverEnabled = false,
    scale = 1
})
```

### `:layout({})`

Aligns children along the main `axis` and along the cross axis using `alignment`, whereas `justify` can be used to align child (not its children) on its parent main axis. <br>

> [!IMPORTANT]
> This function should be called after `:content()` and `:style()` as when you 'finish' defining your component.

```lua
:layout({
    direction = 'row' -- or column
    gap = 0,
    alignment = 'center' , -- or end
    justify = 'end' -- or end
    centered = false
})
```

### `:onClick(fn, mouseButton(num))`

Assigns `fn` to be executed when mouse left button is clicked. The container is passed as an argument to `fn`. The second argument is an optional number, default is `1` for left mouse button. . This argument is used to specify which mouse button the function. Right mouse button is `2`.

### `:onHover({onEnter = fn, onExit = fn})`

Sets an _optional_ `onEnter` or `onExit` function to be respond to mouse events. Container props are passed to each function.

### `:onMouseRelease(fn)`

Calls the function if mouse was released after it was captured by container click event.

### `:update(function(foo) end)`

This function allows for the modification of container properties. Can be used to animate container props (e.g `flux`)

```lua
container():content({children}):update(function(o)
    o._style.hoverEnabled= true
end)
```
