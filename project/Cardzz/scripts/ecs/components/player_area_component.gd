extends "component.gd"

signal dist_changed(old_dist,new_dist)

var dist setget set_dist

func set_dist(new_dist):
	emit_signal("dist_changed",dist,new_dist)
	dist = new_dist
