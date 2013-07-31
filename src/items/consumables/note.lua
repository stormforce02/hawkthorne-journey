local Item = require 'items/item'
local Prompt = require 'prompt'
 
 local self = {}
 
self = {
    name = "note",
    image = "note",
    type = "consumable",
    MAX_ITEMS = 1,
    use = function( consumable, player )
		player.freeze = true
		player.invulnerable = true
		local message = {}
		local options = {}
		if self.content == nil then
			message={"What would you like to write?\n "}
			options={'On-screen Keyboard', 'Finish Note', 'Exit', ''}
		else
			message={"This note reads... \n"..self.content}
			options={'Erase Note', 'Exit'}
		end
		local callback = function(result)
			if prompt.message == "What would you like to write?\n " then
				if prompt.selected == 2 then self.content = prompt.input
				elseif prompt.selected == 3 then self.content = nil end
			else
				if prompt.selected == 1 then self.content = nil end
			end
		end
		prompt = nil
		player.freeze = false
		player.invulnerable = false
		prompt = Prompt.new(message, callback, options, nil, true)
		
		local itemNode = require('items/consumables/note')
		local item = Item.new(itemNode)
		player.inventory:addItem(item)
    end
}
return self