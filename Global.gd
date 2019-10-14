extends Node

# this script is a singleton
# that means that it will be run in every single scene in the game
# we use this to get the world node
# we do this so the level generator doesn't have to directly access it
# this will prevent errors when running the scenes seperate

# null will mean that the world node does not exist
# this is what the level generator is going to need to access
var world = null