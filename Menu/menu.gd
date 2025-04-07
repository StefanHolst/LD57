extends Control

func Play():
	# Starts the game
	get_tree().change_scene_to_file("res://Game.tscn")
	pass
	
func Highscore():
	get_tree().change_scene_to_file("res://Menu/Highscore.tscn")
	pass

func Quit():
	# Exits the game
	get_tree().quit()
	pass
