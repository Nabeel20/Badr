local center = function(child, parent)
    local padding = {
        horizontal = parent._style.padding[2] + parent._style.padding[4],
        vertical = parent._style.padding[1] + parent._style.padding[3]
    }
    child.x = math.round((parent.width - padding.horizontal) / 2 - child.width / 2)
    child.y = math.round(((parent.height - padding.vertical) / 2) - (child.height / 2))

    return child
end

return center
