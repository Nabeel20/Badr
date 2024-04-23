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

```lua
:layout({
    direction = 'row' -- center and column also
    gap = 0,
    alignment = 'center' , -- or end
    justify = 'end' -- or end
})
```

### `:onClick(fn, mouseButton(num))`

Sets `fn` to be executed when mouse left button is clicked. Container is passed as argument to `fn`. Default mouseButton is 1 for left mouse button, right one is 2.

### `:onHover({onEnter = fn, onExit = fn})`

Sets _optional_ `onEnter` or `onExit` function to be respond to mouse event. Container props are passed to each function.

### `:update(function(foo) end)`

This function allows for the modification of container properties. Can be used to animate container props (e.g `flux`)

```lua
container():content({children}):update(function(o)
    o._style.hoverEnabled= true
end)
```
