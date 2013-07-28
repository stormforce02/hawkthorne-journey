local Board = require "board"
local Gamestate = require "vendor/gamestate"
local window = require "window"
local fonts = require "fonts"
local dialog = require "dialog"
local Prompt = {}

Prompt.__index = Prompt

local corner = love.graphics.newImage('images/menu/small_corner.png')
local arrow = love.graphics.newImage("images/menu/small_arrow.png")
arrow:setFilter('nearest', 'nearest')
---
-- Create a new Prompt
-- @param message to display
-- @param callback when user answer's prompt
-- @return Prompt
function Prompt.new(message, callback, options, drawable, getsInput)
    local prompt = {}
    setmetatable(prompt, Prompt)
    prompt.message = message
	prompt.getsInput = getsInput
	prompt.input=""
	prompt.shift=false
    prompt.callback = callback
    prompt.options = options or {'Yes','No'}
    prompt.selected = #prompt.options

    local font = fonts.set('arial')

    prompt.width = 0
    prompt.height = 22

    for i,o in pairs( prompt.options ) do
        prompt.width = prompt.width + font:getWidth(o) + 20
    end

    prompt.dialog = dialog.new(message, nil, drawable, prompt.getsInput)

    fonts.revert()
    Prompt.currentPrompt = prompt
    return prompt
end

function Prompt:update(dt)
    if self.dialog.state == 'closed' and self.callback and not self.called then
        self.called = true
        Prompt.currentPrompt = nil
        self.callback(self.options[self.selected])
    end
end

function Prompt:draw()
    if self.dialog.state == 'closed' then
        return
    end

    local font = fonts:set('arial')

    if self.dialog.board.state == 'opened' then --leaky abstraction
		self.dialog:draw(self.options[self.selected]=="")
        local _, y1, x2, _ = self.dialog:bbox()

        local x = x2 - self.width + self.height / 2
        local y = y1 - self.height / 2

		love.graphics.setColor(112, 28, 114, 255)
		love.graphics.rectangle('fill', x, y, self.width, self.height)
		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.rectangle('line', x, y, self.width, self.height)

        love.graphics.setColor( 255, 255, 255, 255 )
        love.graphics.draw(corner, x - 2, y - 2)
        love.graphics.draw(corner, x - 2, y + self.height - 2)
        love.graphics.draw(corner, x - 2 + self.width, y - 2)
        love.graphics.draw(corner, x - 2 + self.width, y + self.height - 2)

        x = x + self.height / 2
        y = y + self.height / 4

        for i,o in pairs( self.options ) do
            love.graphics.setColor( 255, 255, 255, 255 )

            if self.options[self.selected]~='' then
				if i == self.selected then
					love.graphics.setColor( 254, 204, 2, 255 )
					love.graphics.draw(arrow, x - arrow:getWidth() - 3, y + 1) 
				end
			end

            love.graphics.print(o, x, y)
            x = x + font:getWidth(o) + 20  --padding
        end
    end
    love.graphics.setColor(255, 255, 255, 255)

    fonts.revert()
end

function Prompt:keypressed( button, key )
    if self.dialog.state ~= 'opened' then
        return
    end
	
	print("Button: " .. tostring(button) .. ", key: " .. tostring(key))

    if button == 'RIGHT' then
        if self.selected < #self.options then
            self.selected = self.selected + 1
        end
        return true
    elseif button == 'LEFT' then
        if self.selected > 1 then
            self.selected = self.selected - 1
        end
        return true
	elseif button == 'UP' then
        if self.options[self.selected] == '' then
            self.selected = 1
        end
        return true
	elseif button == 'DOWN' then
        if self.options[#self.options] == '' then
            self.selected = #self.options
        end
        return true
	elseif (button == 'INTERACT' or button == 'JUMP') and self.options[self.selected]~="" then
	
		local closeOn = {'Exit', 'Cancel', 'Save', 'Yes', 'No'}
		
		for i, v in ipairs(closeOn) do
			if self.options[self.selected] == v then
				self.dialog.board:close()
				self.dialog.state = 'closing'
			end
		end
		return true
	elseif button == 'START' then
		self.dialog.board:close()
        self.dialog.state = 'closing'
		return true
    end
	
	local woShift = "`1234567890-=qwertyuiop[]\asdfghjkl;zxcvbnm,./"
	local wShift = "~!@#$%^&*()_+QWERTYUIOP{}|ASDFGHJKL:ZXCVBNM<>?"
	
	if self.getsInput and self.options[self.selected]=="" then
		self.dialog:addMessage(tostring(key),shift)
		
		if key == "backspace" then 
			self.input = string.sub(self.input, 0,  #self.input-1)
		elseif key=="lshift" or key == "rshift" then
			--catch that
		else
			self.input=self.input .. tostring(key)
		end
	end
	
    return self.dialog:keypressed(button)

end

return Prompt





