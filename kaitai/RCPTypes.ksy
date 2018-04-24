meta:
  id: rcp_types
  file-extension: rcp
  endian: be

enums:
  packet_options:
    0x11: timestamp
    0x12: data

  command:
    0x00: invalid
    0x01: version
    0x02: initialize
    0x03: discover
    0x04: update
    0x05: remove
    0x06: updatevalue

  metadata_options:
    0x1a: version
    0x1b: capabilities
    0x1c: commands

  parameter_options:
    0x20: value
    0x21: label
    0x22: description
    0x23: tags
    0x24: order
    0x25: parentid
    0x26: widget
    0x27: userdata
    0x28: userid

  boolean_options:
    0x30: default

  number_options:
    0x30: default
    0x31: minimum
    0x32: maximum
    0x33: multipleof
    0x34: scale
    0x35: unit

  vector_options:
    0x30: default
    0x31: minimum
    0x32: maximum
    0x33: multipleof
    0x34: scale
    0x35: unit

  string_options:
    0x30: default

  color_options:
    0x30: default

  enum_options:
    0x30: default
    0x31: entries

  fixed_array_options:
    0x30: default

  dynamic_array_options:
    0x30: default
    
  uri_options:
    0x30: default
    0x31: filter
    0x32: schema
    
  ipv4_options:
    0x30: default
   
  ipv6_options:
    0x30: default
    
  customtype_options:
    0x30: default
    0x31: uuid
    0x32: config

  datatype:
    0x01: customtype
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
    0x1b: vector2i32
    0x1c: vector2f32
    0x1d: vector3i32
    0x1e: vector3f32
    0x1f: vector4i32
    0x20: vector4f32
    0x21: string
    0x22: rgb
    0x23: rgba
    0x24: enum
    0x25: fixed_array
    0x26: dynamic_array
    0x27: bang
    0x28: group # parameter group
    0x2a: uri
    0x2b: ipv4
    0x2c: ipv6

  number_scale:
    0x00: linear
    0x01: logarithmic
    0x02: exp2

  widget_options:
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

  widgettype:
    0x01: customwidget
    0x09: info
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

  client_status:
    0x00: disconnected
    0x01: connected
    0x02: version_missmatch
    0x03: ok

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
