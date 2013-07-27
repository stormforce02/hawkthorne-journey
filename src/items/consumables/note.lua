return{
    name = "note",
    image = "note",
    type = "consumable",
    MAX_ITEMS = 1,
    use = function( consumable, player )
    	local item = require('items/consumables/note')
		inspect(item)
		player.inventory:addItem(item)
	end
}
