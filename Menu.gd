extends Control


func _ready():
	pass


func _on_StartButton_pressed():
	#get_tree().change_scene("res://terrain.tscn")
	get_tree().change_scene("res://terrain.tscn")

func _on_Quit_pressed():
	get_tree().quit()





