tool
extends Node
class_name MMGenBase

class OutputPort:
	var generator : MMGenBase = null
	var output_index : int = 0
	
	func _init(g : MMGenBase, o : int):
		generator = g
		output_index = o
	
	func get_shader():
		return generator.get_shader(output_index)
	
	func get_shader_code(uv):
		return generator.get_shader_code(uv, output_index)
	
	func get_globals():
		return generator.get_globals()
	
	func to_str():
		return generator.name+"("+str(output_index)+")"

var position : Vector2 = Vector2(0, 0)
var parameters = {}

func get_seed():
	return 0

func get_type():
	return "generic"

func get_source(input_index : int):
	return get_parent().get_port_source(name, input_index)

func get_input_shader(input_index : int):
	var source = get_source(input_index)
	if source != null:
		return source.get_shader()

func get_shader(output_index : int, context = MMGenContext.new()):
	return get_shader_code("UV", output_index, context);

# this will need an output index for switch
func get_globals():
	var list = []
	for i in range(10):
		var source = get_source(i)
		if source != null:
			var source_list = source.get_globals()
			for g in source_list:
				if list.find(g) == -1:
					list.append(g)
	return list

func get_shader_code(uv, slot = 0, context = MMGenContext.new()):
	var rv = _get_shader_code(uv, slot, context)
	if rv != null:
		if !rv.has("f"):
			if rv.has("rgb"):
				rv.f = "(dot("+rv.rgb+", vec3(1.0))/3.0)"
			elif rv.has("rgba"):
				rv.f = "(dot("+rv.rgba+".rgb, vec3(1.0))/3.0)"
			else:
				rv.f = "0.0"
		if !rv.has("rgb"):
			if rv.has("rgba"):
				rv.rgb = rv.rgba+".rgb"
			else:
				rv.rgb = "vec3("+rv.f+")"
		if !rv.has("rgba"):
			rv.rgba = "vec4("+rv.rgb+", 1.0)"
		rv.globals = get_globals()
	return rv

func _get_shader_code(uv : String, output_index : int, context = MMGenContext.new()):
	return null