back to: [RCP Specification](RCPSpecification.md)  
jump to: [RCP Value](RCPValue.md)


## Widget (0x24):

### Widget Id

The `Widget Id` is a 2-byte value where the most significant bit determines whether options are following (0) or not (1).

     0               1  
      7 6 5 4 3 2 1 0 7 6 5 4 3 2 1 0 
     +-+-----------------------------+
     |T|         widget-id           |
     |E|            (15)             |
     |R|                             |
     |M|                             |
     +-+-----------------------------+

| Name          | Option Id<br/>hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   |
| --------------|---------------------|-----------|-----------------|------------|---------------|
| **Widget Id** | - | int16 | textbox (0x0011) | n | type of widget. see widget type-table and widget options
| label-visible | 0x51 (81) | byte | 1 (true) | y | if label is visible
| value-visible | 0x52 (82) | byte | 1 (true) | y | if value is visible
| needs-confirmation | 0x53 (83) | byte | 0 (false) | y | if input needs to be confirmed
| userdata | 0x54 (84) | uint32 size-prefixed array of bytes | 0 | y | e.g.: additional configuraiton (options) for widget
| ... special widget options... |
<br />

### Widget type table:

| Typename   | hex&nbsp;(dec)   | Default for Value | Description |
|------------|------------------|-------------------|-------------|
| Default Widget | 0x0001 (1) | | The default widget
| Custom Widget | 0x0002 (2) | | A custom widget
| Info | 0x0010 (16) | | Only shows the label and value. Group parameters are collapsable.
| Textbox | 0x0011 (17) | string | A text-input. Default widget for string.
| Bang | 0x0012 (18) | bang | A Button
| Press | 0x0013 (19) | | On press sends 1, on release sends 0.
| Checkbox | 0x0014 (20) | boolean | A checkbox supporting following states: off, on, indeterminate. Toggles the value on each press between true and false and unsets the indeterminate state option if it was set.
| Switch | 0x0014 (20) | boolean | A switch supporting following states: off, on. Switches the value on each press to its opposite state.
| Numberbox | 0x0015 (21) | number without min/max | A numberbox or spinner.
| Dial | 0x0016 (22) | | |
| Slider | 0x0017 (23) | number with min/max |
| Slider2d | 0x0018 (24) |
| Range | 0x0019 (25) | range | A range-slider
| Dropdown | 0x001a (26) | enum | A drop-down list of options
| Radiobutton | 0x001b (27) | | |
| Colorbox | 0x001c (28) | color | |
| Table | 0x001d (29) | array / list| |
| Filechooser | 0x001e (30) | uri | |
| Directorychooser | 0x001f (31) | | |
| IP | 0x0020 (32) | IPv4 / IPv6 | |
| List | 0x4000 (32768) | | Layouting Widget for Groups
| Listpage | 0x4001 (32769) | | Layouting Widget for Groups
| Tabs | 0x4002 (32770)| | Layouting Widget for Groups
<br />

### Textbox:

| Name          | Option Id<br/>hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   |
| --------------|---------------------|-----------|-----------------|------------|---------------|
| multiline | 0x56 (86) | boolean | false | y | enable/disable multiline textfield.
| password | 0x57 (87) | boolean | false | y | enable/disable if textbox is a password input.
| placeholder | 0x58 (88) | multilanguage string-short | "" | y | Text to be displayed if the value is empty.
<br />

### Checkbox:

| Name          | Option Id<br/>hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   |
| --------------|---------------------|-----------|-----------------|------------|---------------|
| indeterminate | 0x56 (86) | boolean | false | y | enable/disable the indeterminate state of the checkbox (e.g.: shows neither off nor on).

<br />

### Numberbox:

| Name          | Option Id<br/>hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   |
| --------------|---------------------|-----------|-----------------|------------|---------------|
| precision | 0x56 (86) | uint8 | 2 | y | The precision for value display.
| stepsize-multiplier | 0x57 (87) | type of value | 1 | y | Assuming a numberbox has buttons to step the value up/down, this option defines a multiplier for Value.stepsize. If Value.stepsize == 0 then assume Value.stepsize to be 1 for this multiplication.
| cyclic | 0x58 (88) | boolean | false | y | Inspector should wrap around Value.maximum and Value.minimum.
| nan-meaning | 0x59 (89) | string-short | "NaN" | y | String that describes the meaning of NaN for float-values.
<br />

### Dial:

| Name          | Option Id<br/>hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   |
| --------------|---------------------|-----------|-----------------|------------|---------------|
| precision | 0x56 (86) | uint8 | 2 | y | The precision for the value display.
| cyclic | 0x57 (87) | boolean | false | y | if dial is cyclic
| nan-meaning | 0x58 (88) | tiny-string | "NaN" | y | String that describes the meaning of NaN for float-values.
<br />

### Slider:

| Name          | Option Id<br/>hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   |
| --------------|---------------------|-----------|-----------------|------------|---------------|
| precision | 0x56 (86) | uint8 | 2 | y | The precision for the value display.
| horizontal | 0x57 (87) | boolean | true | y | if slider is horizontal
| nan-meaning | 0x58 (88) | tiny-string | "NaN" | y | String that describes the meaning of NaN in the context of the value.
| trackfill-mode | 0x59 (89) | byte | 0 | y | Defines on which side of the slider the track is filled.
<br />


| Trackfill Mode    | value   |
| ------------------|---------|
| None | 0 |
| Left | 1 |
| Center | 2 |
| Right | 3 |



### Range:

| Name          | Option Id<br/>hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   |
| --------------|---------------------|-----------|-----------------|------------|---------------|
| precision | 0x56 (86) | uint8 | 2 | y | The precision for the value display.
| nan-meaning | 0x57 (87) | tiny-string | "NaN" | y | String that describes the meaning of NaN in the context of the value.
<br />

### Custom Widget:

| Name          | Option Id<br/>hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   |
| --------------|---------------------|-----------|-----------------|------------|---------------|
| widgetid          | 0x56 (86) | uint32     | 0 | y | ID of custom widget. The ID must be sent on initialize but can be omitted on incremental updates.
| config        | 0x57 (87) | uint32 size-prefixed byte-array | - | y | Custom config - can be anything.
