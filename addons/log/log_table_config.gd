class_name LogTableConfig
extends Object
## Config object for tabular data.


var column_alignment: Array[HorizontalAlignment] = []
var columns: Array = []
var delimiter: String = "|"
var max_length: int = 32
var pad_cells: bool = true
var escape_delimiter: bool = false


static func default() -> LogTableConfig:
	return LogTableConfig.new()


func _init(
	p_columns: Array = columns,
	p_column_alignment: Array[HorizontalAlignment] = column_alignment,
	p_delimiter: String = delimiter,
	p_max_length: int = max_length,
	p_pad_cells: bool = pad_cells,
	p_escape_delimiter: bool = escape_delimiter,
) -> void:
	columns = p_columns
	column_alignment = p_column_alignment
	delimiter = p_delimiter
	max_length = p_max_length
	pad_cells = p_pad_cells
	escape_delimiter = p_escape_delimiter


func set_max_length(p_max_length: int) -> LogTableConfig:
	max_length = p_max_length
	return self
