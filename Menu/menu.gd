extends Control

func Play():
	# Starts the game
	get_tree().change_scene("res://scenes/game.tscn")
	pass

func Quit():
	# Exits the game
	get_tree().quit()
	pass
