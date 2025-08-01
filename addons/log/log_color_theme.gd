@tool
extends Resource
class_name LogColorTheme

func _init() -> void:
	print("log color theme init")

## prefixes ########################################

@export var color_src_prefix: Color = "aquamarine"
@export var color_addons_prefix: Color = "peru"
@export var color_test_prefix: Color = "green_yellow"

## delimiters ########################################

@export var color_comma: Color = "crimson"
@export var color_ampersand: Color = "coral"
@export var color_pipe: Color = "coral"
@export var color_carrot: Color = "coral"

@export var colors_rainbow_delims: Array[Color] = ["crimson", "cornflower_blue", "coral", "pink", "peru"]

@export var colors_dict_keys: Array[Color] = ["coral", "cadet_blue", "pink", "peru"]

## types ############################################

@export var color_nil: Color = "coral"
@export var color_bool: Color = "pink"
@export var color_int: Color = "cornflower_blue"
@export var color_float: Color = "cornflower_blue"

@export var color_vectors: Color = "cornflower_blue"
@export var color_rects: Color = "cornflower_blue"

@export var color_class_name: Color = "cadet_blue"
@export var color_string: Color = "dark_gray"
@export var color_string_name: Color = "pink"
@export var color_node_path: Color = "pink"

## to_color_dict ############################################

func to_color_dict() -> Dictionary:
	var color_dict = {}

	color_dict["SRC"] = color_src_prefix
	color_dict["ADDONS"] = color_addons_prefix
	color_dict["TEST"] = color_test_prefix

	color_dict[","] = color_comma
	color_dict["|"] = color_pipe
	color_dict["&"] = color_ampersand
	color_dict["^"] = color_carrot

	color_dict["("] = colors_rainbow_delims
	color_dict[")"] = colors_rainbow_delims
	color_dict["["] = colors_rainbow_delims
	color_dict["]"] = colors_rainbow_delims
	color_dict["{"] = colors_rainbow_delims
	color_dict["}"] = colors_rainbow_delims
	color_dict["<"] = colors_rainbow_delims
	color_dict[">"] = colors_rainbow_delims

	color_dict["dict_key"] = colors_dict_keys
	color_dict["vector_value"] = color_float
	color_dict["class_name"] = color_class_name

	color_dict[TYPE_NIL] = color_nil
	color_dict[TYPE_BOOL] = color_bool
	color_dict[TYPE_INT] = color_int
	color_dict[TYPE_FLOAT] = color_float

	color_dict[TYPE_VECTOR2] = color_vectors
	color_dict[TYPE_VECTOR2I] = color_vectors
	color_dict[TYPE_RECT2] = color_rects
	color_dict[TYPE_RECT2I] = color_rects
	color_dict[TYPE_VECTOR3] = color_vectors
	color_dict[TYPE_VECTOR3I] = color_vectors
	color_dict[TYPE_TRANSFORM2D] = color_rects
	color_dict[TYPE_VECTOR4] = color_vectors
	color_dict[TYPE_VECTOR4I] = color_vectors
	color_dict[TYPE_PLANE] = color_rects
	color_dict[TYPE_QUATERNION] = color_rects
	color_dict[TYPE_AABB] = color_rects
	color_dict[TYPE_BASIS] = color_rects
	color_dict[TYPE_TRANSFORM3D] = color_rects
	color_dict[TYPE_PROJECTION] = color_rects

	color_dict[TYPE_STRING] = color_string
	color_dict[TYPE_STRING_NAME] = color_string_name
	color_dict[TYPE_NODE_PATH] = color_node_path

	color_dict[TYPE_COLOR] = "pink"
	color_dict[TYPE_RID] = "pink"
	color_dict[TYPE_OBJECT] = "pink"
	color_dict[TYPE_CALLABLE] = "pink"
	color_dict[TYPE_SIGNAL] = "pink"

	# Do these ever get through if we're walking these ourselves?
	color_dict[TYPE_DICTIONARY] = "pink"
	color_dict[TYPE_ARRAY] = "pink"

	# Maybe want a hint/label before array openers?
	color_dict[TYPE_PACKED_BYTE_ARRAY] = "pink"
	color_dict[TYPE_PACKED_INT32_ARRAY] = "pink"
	color_dict[TYPE_PACKED_INT64_ARRAY] = "pink"
	color_dict[TYPE_PACKED_FLOAT32_ARRAY] = "pink"
	color_dict[TYPE_PACKED_FLOAT64_ARRAY] = "pink"
	color_dict[TYPE_PACKED_STRING_ARRAY] = "pink"
	color_dict[TYPE_PACKED_VECTOR2_ARRAY] = "pink"
	color_dict[TYPE_PACKED_VECTOR3_ARRAY] = "pink"
	color_dict[TYPE_PACKED_COLOR_ARRAY] = "pink"

	color_dict[TYPE_MAX] = "pink"


	return color_dict
