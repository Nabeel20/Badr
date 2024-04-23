## Override functions

Can be used to create custom components (see components folder).

### `drawFunc`

Sets drawing logic for its container, default is `love.graphics.rectangle`. It can be used for [text](components/text.lua) for example.

```lua
container({
    drawFunc = function () end
})
```

### `:getRect()`

Returns container 'rectangle' to compute layout. It must return table with `{x ,y , width, height}`.

### `:style({})`

Sets container's style. Returns `self`

```lua
function text:style(style)
    text.super.style(self, style) -- to call the base method
    self.width = self.font:getWidth(self._text) + self._style.padding[2] + self._style.padding[4]
    self.height = self.font:getHeight(self._text) + self._style.padding[1] + self._style.padding[3]
    return self
end
```
