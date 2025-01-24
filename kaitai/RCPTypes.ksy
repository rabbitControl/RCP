meta:
  id: rcp_types
  file-extension: rcp
  endian: be

enums:

  command:
    0x01: info
    0x02: initialize
    0x03: update
    0x04: updatevalue
    0x05: remove  

  infodata_options:
    0x1a: applicationid
    0x1b: applicationversion

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
    0x29: readonly
    0x30: enabled

  boolean_options:
    0x30: default

  number_options:
    0x30: default
    0x31: minimum
    0x32: maximum
    0x33: stepsize
    0x34: unit

  range_options:
    0x30: default

  string_options:
    0x30: default
    0x31: regular_expression

  vector_options:
    0x30: default
    0x31: minimum
    0x32: maximum
    0x33: multipleof
    0x34: scale
    0x35: unit


  rgb_options:
    0x30: default

  rgba_options:
    0x30: default

  rgb_float_options:
    0x30: default

  rgba_float_options:
    0x30: default

  enum_options:
    0x30: default
    0x31: entries
    0x32: minimum_selection_count
    0x33: maximum_selection_count

  array_options:
    0x30: default

  uri_options:
    0x30: default
    0x31: filter
    0x32: schema

  ipv4_options:
    0x30: default

  ipv6_options:
    0x30: default

  image_options:
    0x30: default

  customtype_options:
    0x30: default
    0x31: typeid
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
    0x24: rgb_float
    0x25: rgba_float
    0x26: enum
    0x27: array
    0x28: bang
    0x29: group # parameter group
    0x2a: uri
    0x2b: ipv4
    0x2c: ipv6
    0x2d: range
    0x2e: image

  widget_options:
    0x51: label_visible
    0x52: value_visible
    0x53: needs_confirmation
    0x54: userdata

  widgettype:
    0x0001: default
    0x0002: custom
    0x0010: info
    0x0011: textbox
    0x0012: button
    0x0013: switch
    0x0014: checkbox
    0x0015: press
    0x0016: numberbox
    0x0017: dial
    0x0018: slider
    0x0019: slider2d
    0x001a: range
    0x001b: dropdown
    0x001c: radiobutton
    0x001d: colorchooser
    0x001e: table
    0x001f: uri
    0x0020: ip
    0x0021: image
    0x4000: list
    0x4001: tabs


  button_widget_options:
    0x56: button_label
    0x57: trigger_on_up  

  switch_widget_options:
    0x56: switch_label_on
    0x57: switch_label_off

  checkbox_widget_options:
    0x56: indeterminate

  press_widget_options:
    0x56: press_label_on
    0x57: press_label_of

  textbox_widget_options:
    0x56: multiline
    0x57: password
    0x58: placeholder

  numberbox_widget_options:
    0x56: precision
    0x57: stepsize_multiplier
    0x58: cyclic
    0x59: nan_meaning

  dial_widget_options:
    0x56: precision
    0x57: stepsize_multiplier
    0x58: cyclic
    0x59: nan_meaning

  slider_widget_options:
    0x56: precision
    0x57: stepsize_multiplier
    0x58: horizontal
    0x59: nan_meaning
    0x5a: trackfill_mode

  trackfill_mode:
    0x00: none
    0x01: left
    0x02: center
    0x03: right

  range_widget_options:
    0x56: precision
    0x57: stepsize_multiplier
    0x58: nan_meaning

  uri_widget_options:
    0x56: placeholder
    0x57: button_label

  image_widget_options:
    0x56: overlay_text

  customwidget_options:
    0x56: widgetid
    0x57: config