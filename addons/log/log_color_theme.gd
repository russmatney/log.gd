@tool
extends Resource
class_name LogColorTheme

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

# @export var colors_dict_keys: Array[Color] = ["coral", "cadet_blue", "pink", "peru"]

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

@export var color_type_color: Color = "pink"
@export var color_rid: Color = "pink"
@export var color_object: Color = "pink"
@export var color_callable: Color = "pink"
@export var color_signal: Color = "pink"

@export var color_array: Color = "pink"
@export var color_dictionary: Color = "pink"
@export var color_packed_array: Color = "pink"
@export var color_type_max: Color = "pink"

## to_color_dict ############################################

func to_color_dict() -> Dictionary:
	var color_dict = {}

	color_dict["SRC"] = color_src_prefix
	color_dict["ADDONS"] = color_addons_prefix
	color_dict["TEST"] = color_test_prefix

	color_dict["|"] = color_pipe
	color_dict["&"] = color_ampersand
	color_dict["^"] = color_carrot

	# consider rainbow for commas too
	# color_dict[","] = colors_rainbow_delims
	color_dict[","] = color_comma

	color_dict["("] = colors_rainbow_delims
	color_dict[")"] = colors_rainbow_delims
	color_dict["["] = colors_rainbow_delims
	color_dict["]"] = colors_rainbow_delims
	color_dict["{"] = colors_rainbow_delims
	color_dict["}"] = colors_rainbow_delims
	color_dict["<"] = colors_rainbow_delims
	color_dict[">"] = colors_rainbow_delims

	color_dict["dict_key"] = colors_rainbow_delims
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

	color_dict[TYPE_COLOR] = color_type_color
	color_dict[TYPE_RID] = color_rid
	color_dict[TYPE_OBJECT] = color_object
	color_dict[TYPE_CALLABLE] = color_callable
	color_dict[TYPE_SIGNAL] = color_signal

	# Do these ever get through if we're walking these ourselves?
	color_dict[TYPE_DICTIONARY] = color_dictionary
	color_dict[TYPE_ARRAY] = color_array

	# Maybe want a hint/label before array openers?
	color_dict[TYPE_PACKED_BYTE_ARRAY] = color_packed_array
	color_dict[TYPE_PACKED_INT32_ARRAY] = color_packed_array
	color_dict[TYPE_PACKED_INT64_ARRAY] = color_packed_array
	color_dict[TYPE_PACKED_FLOAT32_ARRAY] = color_packed_array
	color_dict[TYPE_PACKED_FLOAT64_ARRAY] = color_packed_array
	color_dict[TYPE_PACKED_STRING_ARRAY] = color_packed_array
	color_dict[TYPE_PACKED_VECTOR2_ARRAY] = color_packed_array
	color_dict[TYPE_PACKED_VECTOR3_ARRAY] = color_packed_array
	color_dict[TYPE_PACKED_COLOR_ARRAY] = color_packed_array

	color_dict[TYPE_MAX] = color_type_max


	return color_dict


### static term safe helpers

# terminal safe colors:
# - black
# - red
# - green
# - yellow
# - blue
# - magenta
# - pink
# - purple
# - cyan
# - white
# - orange
# - gray

static var TERMSAFE_RAINBOW: Array = ["red", "blue", "green", "pink", "orange"]

static var COLORS_TERM_SAFE: Dictionary = {
	"SRC": "cyan",
	"ADDONS": "red",
	"TEST": "green",
	",": "red",
	"(": TERMSAFE_RAINBOW,
	")": TERMSAFE_RAINBOW,
	"[": TERMSAFE_RAINBOW,
	"]": TERMSAFE_RAINBOW,
	"{": TERMSAFE_RAINBOW,
	"}": TERMSAFE_RAINBOW,
	"<": TERMSAFE_RAINBOW,
	">": TERMSAFE_RAINBOW,
	"|": TERMSAFE_RAINBOW,
	"&": "orange",
	"^": "orange",
	"dict_key": TERMSAFE_RAINBOW,
	"vector_value": "green",
	"class_name": "magenta",
	TYPE_NIL: "pink",
	TYPE_BOOL: "pink",
	TYPE_INT: "green",
	TYPE_FLOAT: "green",
	TYPE_STRING: "pink",
	TYPE_VECTOR2: "green",
	TYPE_VECTOR2I: "green",
	TYPE_RECT2: "green",
	TYPE_RECT2I: "green",
	TYPE_VECTOR3: "green",
	TYPE_VECTOR3I: "green",
	TYPE_TRANSFORM2D: "pink",
	TYPE_VECTOR4: "green",
	TYPE_VECTOR4I: "green",
	TYPE_PLANE: "pink",
	TYPE_QUATERNION: "pink",
	TYPE_AABB: "pink",
	TYPE_BASIS: "pink",
	TYPE_TRANSFORM3D: "pink",
	TYPE_PROJECTION: "pink",
	TYPE_COLOR: "pink",
	TYPE_STRING_NAME: "pink",
	TYPE_NODE_PATH: "pink",
	TYPE_RID: "pink",
	TYPE_OBJECT: "pink",
	TYPE_CALLABLE: "pink",
	TYPE_SIGNAL: "pink",
	TYPE_DICTIONARY: "pink",
	TYPE_ARRAY: "pink",
	TYPE_PACKED_BYTE_ARRAY: "pink",
	TYPE_PACKED_INT32_ARRAY: "pink",
	TYPE_PACKED_INT64_ARRAY: "pink",
	TYPE_PACKED_FLOAT32_ARRAY: "pink",
	TYPE_PACKED_FLOAT64_ARRAY: "pink",
	TYPE_PACKED_STRING_ARRAY: "pink",
	TYPE_PACKED_VECTOR2_ARRAY: "pink",
	TYPE_PACKED_VECTOR3_ARRAY: "pink",
	TYPE_PACKED_COLOR_ARRAY: "pink",
	TYPE_MAX: "pink",
	}
