extends Node

# --------------------------------------------------------------------------------------------------
# MISC
# --------------------------------------------------------------------------------------------------
func _ready():
	log_test()

func log_test():
	debug_error("everything is fine, just a boot up test")
	debug_alert("This person is probably a femboy ngl")
	debug_warn("Explosive kittens :3")
	debug("Debug","Dyam i really hate those bugs")
	debug_badge("Debugger V1 loaded")
	print(" ")
	# print_rich("[color=#1f1f1f][bgcolor=#ffffff]  Debugger V1 loaded  ") 


# --------------------------------------------------------------------------------------------------
# DEBUG LOG
# --------------------------------------------------------------------------------------------------


func debug_error(message):
	print_rich("[color=#ff5b3d][b]Error:[/b] " + "[color=#c9c9c9]" + message) 

func debug_warn(message):
	print_rich("[color=#ffffff][b]Warning:[/b] " + "[color=#c9c9c9]" + message) 

func debug_alert(message):
	print_rich("[color=#ffff0b][b]Alert:[/b] " + "[color=#c9c9c9]" + message) 

func debug(title:String, message: String):
	print_rich("[color=#ffffff][b]" + title + ":[/b] " + "[color=#c9c9c9]" + message) 

func debug_badge(message:String):
	print_rich("[color=#1f1f1f][bgcolor=#ffffff]   " + message + "   ") 


# --------------------------------------------------------------------------------------------------
# Var editor
# --------------------------------------------------------------------------------------------------
