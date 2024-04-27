# Progress

[Progress Component](../../components/progress.lua) <br>
Dependencies:

- [classic](https://github.com/rxi/classic)
- [flux](https://github.com/rxi/flux)

### Usage

```lua
function love.load()
    myProgress = progress({ value = 50, trackColor = { 1, 0, 0 } })
    print(myProgress.value) -- prints 50
end
```

### `progress({options})`

Available options:

- `value` _number_ : 0 to 100.
- `trackColor` _table_
- `backgroundColor` _table_
- `width` _number_

Available functions

- `:setValue(value)`
