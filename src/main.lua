-- Change this value to the gamestate you would like to load
local state = 'baseball'

--
-- You shouldn't need to change any of the lines below
--
local loader = require 'loader'
loader:target(state)

require 'main_release'
