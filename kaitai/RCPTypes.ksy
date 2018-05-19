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
    0x31: regular_expression

  color_options:
    0x30: default

  enum_options:
    0x30: default
    0x31: entries
    0x32: multiselect

  array_options:
    0x30: default
    0x31: structure

  list_options:
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
    0x25: array
    0x26: list
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
    0x01: left
    0x02: right
    0x03: top
    0x04: bottom
    0x05: center

  widgettype:
    0x0001: customwidget
    0x0010: info
    0x0011: textbox
    0x0012: bang
    0x0013: press
    0x0014: toggle
    0x0015: numberbox
    0x0016: dial
    0x0017: slider
    0x0018: slider2d
    0x0019: range
    0x001a: dropdown
    0x001b: radiobutton
    0x001c: colorbox
    0x001d: table
    0x001e: filechooser
    0x001f: directorychooser
    0x0020: ip
    0x8000: list
    0x8001: listpage
    0x8002: tabs


  textbox_options:
    0x56: multiline
    0x57: wordwrap
    0x58: password
    
  numberbox_options:
    0x56: precision
    0x57: format
    0x58: stepsize
    0x59: cyclic
    
  numberbox_format:
    0x01: dec
    0x02: hex
    0x03: bin
    
  slider_options:
    0x56: horizontal
    
  dial_options:
    0x56: cyclic
    
  customwidget_options:
    0x56: uuid
    0x57: config

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
