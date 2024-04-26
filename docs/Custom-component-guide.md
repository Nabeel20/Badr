## Creating your custom component

This guide provides instructions on how to develop your own component. You have the option to either 'override' the default definition (for instance, creating a custom drawing for text), or establish a function with predefined styles for more efficient usage (for example, see the button component). <br>
The library [classic](https://github.com/rxi/classic), which is not included in this package, is utilized to implement the inheritance and ‘template’ methodology. <br>
Please note that any function can be overridden to suit your specific requirements. This flexibility allows for extensive customization and adaptability in your component development process.

### Extend base component

```lua
local badar = require 'path.to.badar.lua'
local myComponent = badar:extend() -- classic.lua functionality

function myComponent:new(you_arguments)
    myComponent.super.new(self, obj) -- to inherit functionality form default template
end
```

### Extend basic functionality

To extend the basic functionality of your component, you can utilize `myComponent.super.functionName()`. This allows you to invoke the default function.

```lua
function text:style(style)
    text.super.style(self, style) -- call default method
    self.width = self.font:getWidth(self._text) + self._style.padding[2] + self._style.padding[4]
    self.height = self.font:getHeight(self._text) + self._style.padding[1] + self._style.padding[3]
    return self
end
```

### Container `drawFunc`

This prop sets the drawing logic for its container, the default is `love.graphics.rectangle`.
It can be used for printing [text](components/text.lua) for example.

```lua
container({
    drawFunc = function () end
})
```

### `:getRect()`

Returns container 'rectangle' to compute its layout. It must return a table with `{x ,y , width, height}`.

### `:style({})`

Sets container's style. Returns `self`.

```lua
function text:style(style)
    text.super.style(self, style) -- to call the base method
    self.width = self.font:getWidth(self._text) + self._style.padding[2] + self._style.padding[4]
    self.height = self.font:getHeight(self._text) + self._style.padding[1] + self._style.padding[3]
    return self
end
```
