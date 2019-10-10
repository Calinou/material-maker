tool
extends Object
class_name MMGenContext

var renderer : MMGenRenderer
var variants : Dictionary = {}

func _init(r : MMGenRenderer):
	renderer = r

func has_variant(generator):
	return variants.has(generator)

func get_variant(generator, variant):
	var rv = -1
	if variants.has(generator):
		rv = variants[generator].find(variant)
		if rv == -1:
			variants[generator].push_back(variant)
	else:
		variants[generator] = [variant]
	return rv
