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
		if self.content == nil and prompt.input ~="" and prompt.input ~=nil then
			self.content=prompt.input
		end
         prompt = nil
         player.freeze = false
         player.invulnerable = false
    end
	prompt = Prompt.new(message, callback, options, nil, self.content==nil)
		
    local itemNode = require('items/consumables/note')
    local item = Item.new(itemNode)
    player.inventory:addItem(item)
    end
}

return self