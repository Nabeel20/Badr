# Badr 🌕

Badr _(Full moon in Arabic)_ is a easy and enjoyable way to write user interfaces, prioritizing _**developer experience**_, _**composition**_ and _**readability**_ 🌝

### Usage

Copy [badr.lua](badr.lua) to your project. <br>
🌙 For a **_functional_** example see: [example.lua](components/example.lua)

```lua
function love.load()
    menu = component { column = true, gap = 10 }
        + label 'Hello, World!'
        + label { text = 'love2d', id = '#2' }
        + button {
            text = 'Click me!',
            onClick = function(self)
                -- get child by id
                (self.parent % '#2').text = 'awesome'
            end
        }
end
```

## Creating a new component

Each component acts as a container for values and includes a `draw` function.There are some default properties (`id (string)`, `x`, `y`, `width`, `height`, `visible`, `parent` and `children`). However, you can pass any additional values to a component and utilize them as needed. To create a custom component, simply override the draw function, for inspiration take a look at [components](components).

### Basic layout support

Badr offers built-in support for simple layout composition with `row(boolean)`, `column(boolean)`, and `gap(number)`. For more advanced layouts, you can implement custom drawing logic.

```lua
local newComponent = component {
  x = 10,
  y = 10,
  myCustomProp = true,
  customFunction = myCustomLogic(),
  draw = function(self)
      -- your drawing logic here
      -- don't forget to loop through children to draw them
      if not self.visible then return end
      love.graphics.print('Hello!', self.x, self.y)
  end,
}
```

## Appending a child component

To append a child component to a parent component, you can use the following syntax `parent = parent + child`.

### Composition

Composition allows you to break your UI into simple, independent components. This approach offers greater flexibility and scalability.

```lua
local customComponent = component { row = true, gap = 10 }
    + label 'second'
    + label 'third'

local mainComponent = component { column = true }
    + label 'first'
    + customComponent
    + (component() + label 'fourth') -- this work also
```

## Removing a child component

To remove a child component from its parent, you can use the following syntax: `parent = parent - child`. To hide a component you can use `component.visible = false`.

## Updating a child component

To update a child component, you can directly modify its value using: `child.value = newValue`. For continuous updates, use `:onUpdate()`, and ensure to call component update method.

### Retrieving a child component by id

To retrieve a child component by its `id` (string), you can use the following syntax:, use the following syntax: `parent % id`. This will return the targeted child component

### Updating the position of all children

To update the position of a child component and all its children, you can use the following syntax `:updatePosition(x,y)`.

### Animating a child component

To animate any component, you can use `flux`. If you want to animate a component and all its children, you can use `:animate()`.

```lua
button {
    text = 'Click for animation',
    onClick = function(self)
        -- Animate this component
        self.opacity = 0
        flux.to(self, 0.4, { opacity = 1 })
        -- Animate the whole tree
        self.parent:animate(function(s)
            -- note that we pass the current position
            flux.to(s, 2, { x = s.x + 250 })
        end)
    end,
}
```

> [!NOTE]
> Don't forget to call `:draw()` and `:update()`.

To check if the mouse is within a component, you can use `:isMouseInside()`. Badr uses mouse.isDown() to check for mouse clicks. Feel free to use your own methods when creating your components.<br>
Feedback and ideas appreciated ✨

## License

This library is free software; you can redistribute it and/or modify it under
the terms of the MIT license. See [LICENSE](LICENSE) for details.
