local container = require 'badar'
local text = require 'components.text'
local closeIcon = love.graphics.newImage('assets/close-line.png')
local flux = require 'libs.flux'

local style = {
    borderColor = Hex('#d1d5db'),
    borderWidth = 0.1,
    corner = 4,
    padding = { 14, 14, 10, 14 },
    textColor = { 0, 0, 0 },
}

local toast = function(parent, options)
    local toast = container({ minWidth = 80, alive = 0, id = 'toast' })
    if options.variant == 'destructive' then
        style.color = Hex('#dc2626')
        style.borderWidth = 0
        style.textColor = { 1, 1, 1 }
    end
    local content = {
        container()
            :style({ opacity = 0 })
            :content({
                text(options.description)
                    :style({
                        size = 14,
                        color = style.textColor
                    }),
            }):layout({ direction = 'column' }),


        icon(closeIcon, { id = 'close' })
            :style({ visible = false, color = style.textColor })
            :onClick(function(i)
                flux.to(toast, 0.5, { x = -toast.width - 100 }):oncomplete(function()
                    for index, child in ipairs(parent.children) do
                        if child.id == 'toast' then
                            table.remove(parent.children, index)
                            break
                        end
                    end
                end)
            end)
    }

    if options.title then
        content[1]:content({
            text(options.title):style({ size = 14, color = style.textColor, fontFamily = 'assets/Poppins-Bold.ttf' }),
            text(options.description)
                :style({ size = 12, color = style.textColor })
        }):layout()
    end

    if options.action then
        table.insert(content, 2, options.action)
    end
    toast
        :content(content)
        :style(style)
        :layout({ direction = 'row', alignment = 'center', gap = 8 })
        :onHover({
            onEnter = function(i)
                i:find('close'):style({ visible = true })
            end
        }):onUpdate(function(i)
        i.alive = i.alive + 1
        if i.alive > 150 then
            flux.to(i, 0.5, { x = -i.width - 100 }):oncomplete(function()
                for index, child in ipairs(parent.children) do
                    if child.id == 'toast' then
                        table.remove(parent.children, index)
                        break
                    end
                end
            end)
        end
    end)

    if parent:find('toast') == nil then
        table.insert(parent.children, toast)
    end

    -- don't know why * 2
    local toastPosition = parent.height - toast.height - parent._style.padding[3] * 2
    toast.y = toastPosition
    toast:modify(function(i)
        i.y = i.y + 100
        flux.to(i, 0.3, { y = toastPosition })
    end)
end
return toast
