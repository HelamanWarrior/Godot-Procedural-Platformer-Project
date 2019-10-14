extends Position2D

# this is the space in between each block the block's sprite is 8 pixels
export(int) var grid_size = 8

# get the block to preload so we can instance it later
export(PackedScene) var block = preload("res://Block.tscn")

# the number of blocks that you want to be generated
export(int) var max_block_number = 30
# this variable is just the current amount of blocks that currently exits
var current_block_number = 0

# these variables are used to limit how high up and down the blocks can be created
export(int) var max_position_limit = 60
export(int) var min_position_limit = 20

# use a custom signal to tell the world scene to create blocks
# signals are usefull when instancing the block outside of this current scene
# this signal takes two arguments the block we want to create, and the location of the block
signal create_block(block, location)

func _ready():
	# check if the world node exists through the global singleton
	if Global.world != null:
		# if it is not equal to null which means it exists we will then
		# link the signal to the world, through the Global singleton
		connect("create_block", Global.world, "_on_LevelGenerator_create_block")

func _process(delta):
	# make the level generator continually move to the grid size
	global_position.x += grid_size
	
	# this action variable will decide through random numbers
	# where the generator is going to move up or down (to create hills)
	# this is where our "procedural" content comes in
	# this project does not use noise textures
	var action = round(rand_range(0, 20))
	
	# this action variable affects if it moves up
	# change these values to make the terrain more flat or rough
	if action >= 0 and action < 4:
		# check to see if the position y is greater the minimum position limit
		if global_position.y > min_position_limit:
			global_position.y -= grid_size
		# else move the position down a block
		else:
			global_position.y += grid_size
	# or if it moves down
	elif action >= 4 and action < 9:
		# check to see if the position y is less than the maximum position limit
		if global_position.y < max_position_limit:
			global_position.y += grid_size
		# else move the position up a block
		else:
			global_position.y -= grid_size
	
	# create the blocks by emiting the signal which is caught by the world
	# we set the block(argument 0) to the block that we want to create
	# the block that we are creating is specified at the variable towards the top
	# then we set the location(argument 1) to the generator's position
	emit_signal("create_block", block, global_position)
	
	# this creates another block below the one on top
	emit_signal("create_block", block, Vector2(global_position.x, global_position.y + grid_size))
	
	# add to the current block number
	current_block_number += 1
	
	# check if the current block number meets the max block number
	if current_block_number >= max_block_number:
		# destroy the generator if it does, so we don't create any more blocks
		queue_free()