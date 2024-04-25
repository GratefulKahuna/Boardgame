extends Node

var player_1_tile = null
var first_level_tiles = [5, 7, 6, 5, 7, 6]
var current_player = "Notarbartolo"
var tile1 = preload("res://scenes/tiles/Tile.tscn")

var player_dict = {"Notarbartolo": 0, "Genius": 0, "Speedy": 0, "King of keys": 0, "Monster": 0}
var player_tile_dict = {"Notarbartolo": null, "Genius": null, "Speedy": null, "King of keys": null, "Monster": null}
var player_tile_str_dict = {"Notarbartolo": "Antwerp_world_diamond_centre", "Genius": "Antwerp_world_diamond_centre", "Speedy": "Antwerp_world_diamond_centre", "King of keys": "Antwerp_world_diamond_centre", "Monster": "Antwerp_world_diamond_centre"}
var tile_dict = {
	"Antwerp_world_diamond_centre": 0,
	"Opera": 9 + randi_range(1, 2),
	"Cinema": 7 + randi_range(1, 2),
	"Casino": 9 + randi_range(1, 2),
	"Cafe": 9 + randi_range(1, 2),
	"Computer_store": 7 + randi_range(1, 2),
	"Casino2": 7 + randi_range(1, 2),
	"Office": 7 + randi_range(1, 2),
	"Bar": 5 + randi_range(1, 2),
	"Gold_smith": 5 + randi_range(1, 2),
	"Jeweler": 3 + randi_range(1, 2),
	"Diamond_dealer": 5 + randi_range(1, 2),
	"Hotel": 3 + randi_range(1, 2),
	"Bank": 3 + randi_range(1, 2),
	"Gallery": 5 + randi_range(1, 2),
	"Police_station": 3 + randi_range(1, 2),
	"Gold_dealer": 5 + randi_range(1, 2),
	"Jewelry_store": 7 + randi_range(1, 2),
	"Locksmith": 7 + randi_range(1, 2),
	"Jewelry_buyer": 7 + randi_range(1, 2),
	"Watch_store": 9 + randi_range(1, 2),
	"Community_center": 9 + randi_range(1, 2),
	"Justice_department": 11 + randi_range(1, 2),
	"Synagogue": 11 + randi_range(1, 2)
	}

func getALlPlayersOnThisTile():
	var result = []
	for player in player_tile_dict:
		if player_tile_str_dict[current_player] == player_tile_str_dict[player]:
			result.append(player)
	return result

func allZeroes():
	for tile in tile_dict:
		if tile_dict[tile] != 0:
			return false
	return true
	
func nextPlayer():
	match current_player:
		"Notarbartolo":
			current_player = "Genius"
		"Genius":
			current_player = "Speedy"
		"Speedy":
			current_player = "King of keys"
		"King of keys":
			current_player = "Monster"
		"Monster":
			current_player = "Notarbartolo"
		_:
			print("Mismatch: incorrect player role")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
