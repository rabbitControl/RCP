meta:
  id: rcp_types
  file-extension: rcp
  endian: be

enums:
  packet:
    0x10: id
    0x11: timestamp
    0x12: data

  command:
    0x00: invalid
    0x01: version
    0x02: initialize
    0x03: add
    0x04: update
    0x05: remove
    0x06: updatevalue

  metadata:
    0x1a: version
    0x1b: capabilities
    0x1c: commands

  parameter:
    0x20: value
    0x21: label
    0x22: description
    0x23: order
    0x24: parent
    0x25: widget
    0x26: userdata

  boolean_property:
    0x30: default

  number_property:
    0x30: default
    0x31: minimum
    0x32: maximum
    0x33: multipleof
    0x34: scale
    0x35: unit

  vector_property:
    0x30: default
    0x31: minimum
    0x32: maximum
    0x33: multipleof
    0x34: scale
    0x35: unit

  string_property:
    0x30: default

  color_property:
    0x30: default

  enum_property:
    0x30: default
    0x31: entries

  fixed_array_property:
    0x30: default

  dynamic_array_property:
    0x30: default

  compound_property:
    0x30: default

  datatype:
    0x10: boolean
    0x11: int8
    0x12: uint8
    0x13: int16
    0x14: uint16
    0x15: int32
    0x16: uint32
    0x17: int64
    0x18: uint64
    0x19: float32
    0x1a: float64
    0x1b: vector2i8
    0x1c: vector2i16
    0x1d: vector2i32
    0x1e: vector2i64
    0x1f: vector2f32
    0x20: vector2f64
    0x21: vector3i8
    0x22: vector3i16
    0x23: vector3i32
    0x24: vector3i64
    0x25: vector3f32
    0x26: vector3f64
    0x27: vector4i8
    0x28: vector4i16
    0x29: vector4i32
    0x2a: vector4i64
    0x2b: vector4f32
    0x2c: vector4f64
    0x2d: tiny_string # tiny string
    0x2e: short_string # short string
    0x2f: string # long string
    0x30: rgb
    0x31: rgba
    0x32: enum
    0x33: fixed_array
    0x34: dynamic_array
    0x36: image
    0x37: bang
    0x38: time
    0x39: group # parameter group
    0x3a: compound

  number_scale:
    0x00: linear
    0x01: logarithmic
    0x02: exp2

  widget:
    0x50: type
    0x51: enabled
    0x52: visible
    0x53: label_visible
    0x54: value_visible
    0x55: label_position

  label_position:
    0x00: left
    0x01: right
    0x02: top
    0x03: bottom
    0x04: center

  widget_type:
    0x10: textbox
    0x11: numberbox
    0x12: button
    0x13: checkbox
    0x14: radiobutton
    0x15: slider
    0x16: dial
    0x17: colorbox
    0x18: table
    0x19: treeview
    0x1a: dropdown
    0x1f: xyfield


types:
  tiny_string:
    seq:
      - id: my_len
        type: u1
      - id: data
        type: str
        size: my_len
        encoding: UTF-8
  short_string:
    seq:
      - id: my_len
        type: u2
      - id: data
        type: str
        size: my_len
        encoding: UTF-8
  long_string:
    seq:
      - id: my_len
        type: u4
      - id: data
        type: str
        size: my_len
        encoding: UTF-8
  userdata:
    seq:
      - id: my_len
        type: u4
      - id: data
        size: my_len
