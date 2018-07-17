-> back to [RCP Specification](RCPSpecification.md)

## Widget (0x24):

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| **type** | - | uint16 | textbox (0x0011) | n | type of widget. see widget type-table and widget options
| enabled | 0x50 (80) | byte | true | y | if widget allows user input
| label-visible | 0x51 (81) | byte | true | y | if label is visible
| value-visible | 0x52 (82) | byte | true | y | if value is visible
| ... special widget options... |
| **terminator** | 0 | byte | 0 | n | terminator


### Widget type table:

| typename   | hex   | description
|------------|-------|--------------|
| Custom Widget | 0x0001 | a custom widget
| Info | 0x0010 | For discovery: only shows datatype, label. groupParameters are collapsable
| Textbox | 0x0011 |
| Bang | 0x0012 | fires on press
| Press | 0x0013 | onPress sends 1, onRelease sends 0
| Toggle | 0x0014 | Switch: toggles it's state on each press
| Numberbox | 0x0015 |
| Dial | 0x0016 |
| Slider | 0x0017 |
| Slider2d | 0x0018 |
| Range | 0x0019 |
| Dropdown | 0x001a |
| Radiobutton | 0x001b |
| Colorbox | 0x001c |
| Table | 0x001d |
| Filechooser | 0x001e |
| Directorychooser | 0x001f |
| IP | 0x0020 |
| List | 0x8000 | Layouting Widget for Groups
| Listpage | 0x8001 | Layouting Widget for Groups
| Tabs | 0x8002 | Layouting Widget for Groups


### Textbox:

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| multiline | 0x56 (86) | boolean | false | y | enable/disable multiline textfield
| wordwrap | 0x57 (87) | boolean | false | y | enable/disable word wrap
| password | 0x58 (88) | boolean | false | y | enable/disable if testbox is a password input


### Numberbox:

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| precision | 0x56 (86) | uint8 | 2 | y | set precision for numberbox
| format | 0x57 (87) | uint8 | 0x01 | y | set format of numberbox: dec/hex/bin
| stepsize | 0x58 (88) | T of value | if Value.multipleof > 0, then value.multipleof. Else dependent on value.subtype: If real: 0.01. If int: 1 | y | a value always must be within it’s definition. Therefore If stepsize collides with value.multipleof, then value.multipleof is used: to keep value within it’s defintion.
| cyclic | 0x59 (89) | boolean | false | y | inspector should wrap around value

## format table:

| typename   | hex   |
|------------|-------|
| dec | 0x01 |
| hex | 0x02 |
| bin | 0x03 |


### Dial:

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| cyclic | 0x56 (86) | boolean | false | y | if dial is cyclic


### Slider:

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| horizontal | 0x56 (86) | boolean | true | y | if slider is horizontal


### Table:
work-in-progress:
option: labels for dimensions: array of labels


### Range:
```
min		             max
|----------------------------|
      |------|
      v1     v2
```

### Custom Widget:

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| uuid          | 0x56 (86) | UUID: 16-byte     | 0 | y | UUID of custom widget. this must be unique to avoid widget-conflicts. !0
| config        | 0x57 (87) | 4-byte size-prefixed byte-array | - | y | custom config, can be anything
