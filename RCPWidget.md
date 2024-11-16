back to: [RCP Specification](RCPSpecification.md)  
jump to: [RCP Value](RCPValue.md)


## Widget:

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

| Name          | Option Id<br/>hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   | Since |
| --------------|---------------------|-----------|-----------------|------------|---------------|----|
| **Widget Id** | - | [Widget Id](#Widget-Id) | - | n | Type of widget. See [Widget type table](#Widget-type-table) and widget options | 1.0
| label-visible | 0x51 (81) | byte | 1 (true) | y | if label is visible | 1.0
| value-visible | 0x52 (82) | byte | 1 (true) | y | if value is visible | 1.0
| needs-confirmation | 0x53 (83) | byte | 0 (false) | y | if input needs to be confirmed | 1.0
| userdata | 0x54 (84) | [RCP Int](RCPSpecification.md#RCP-Int) size-prefixed array of bytes | 0 | y | e.g.: additional configuraiton (options) for widget | 1.0
| special widget options... | | | | | Options for the widget. See below.
<br />

### Widget type table:

| Name   | hex&nbsp;(dec)   | Supported types<br>(* default) | Description | Since |
|--------|------------------|--------------------------------|-------------|-------|
| Default Widget | 0x0001 (1) | | The default widget for the type (as specified below) | 1.0
| Custom Widget | 0x0002 (2) | *custom | A custom widget | 1.0
| Info | 0x0010 (16) | all | Only shows the label and value. Group parameters are collapsable. This is the fallback widget for all widgets the client does not implement. | 1.0
| Textbox | 0x0011 (17) | *string | A text-input. Default widget for string. | 1.0
| Button | 0x0012 (18) | *bang | A Button | 1.0
| Switch | 0x0014 (20) | *boolean | A switch supporting following states: off, on. Switches the value on each press to its opposite state. | 1.0
| Checkbox | 0x0014 (20) | boolean | A checkbox supporting following states: off, on, indeterminate. Toggles the value on each press between true and false and unsets the indeterminate state option if it was set. | 1.0
| Press | 0x0013 (19) | boolean | On press sends 1, on release sends 0. | 1.0
| Numberbox | 0x0015 (21) | *number without min/max, number with min/max | A numberbox or spinner. | 1.0
| Dial | 0x0016 (22) | number | | 1.0
| Slider | 0x0017 (23) | *number with min/max | | 1.0
| Slider2d | 0x0018 (24) | vector2 with min/max | X/Y single touch field interface | 1.0
| Range | 0x0019 (25) | *range | A range-slider | 1.0
| Dropdown | 0x001a (26) | *enum | A drop-down list of options | 1.0
| Radiobutton | 0x001b (27) | enum | | 1.0
| Colorchooser | 0x001c (28) | *color | | 1.0
| Table | 0x001d (29) | *array / list | | 1.0
| URI | 0x001e (30) | *uri | | 1.0
| IP | 0x0020 (32) | *IPv4 / IPv6 | | 1.0
| Image | 0x0021 (33) | *Image | | 1.0
| List | 0x4000 (32768) | *group | Layouting Widget for Groups | 1.0
| Listpage | 0x4001 (32769) | group | Layouting Widget for Groups | 1.0
| Tabs | 0x4002 (32770)| group | Layouting Widget for Groups | 1.0
<br />


### Button:

| Name          | Option Id<br/>hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   | Since
| --------------|---------------------|-----------|-----------------|------------|---------------|----|
| button-label | 0x56 (86) | [RCP Language String](RCPSpecification.md#RCP-Language-String) | 0 | y | The label used on the button. | 1.0
| trigger-on-up | 0x57 (87) | boolean | false | y | If set the button triggers the bang on up. | 1.0
<br />


### Switch:

| Name          | Option Id<br/>hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   | Since
| --------------|---------------------|-----------|-----------------|------------|---------------|----|
| switch-label-on | 0x56 (86) | [RCP Language String](RCPSpecification.md#RCP-Language-String) | 0 | y | The label used on the switch if the value is on. | 1.0
| switch-label-off | 0x57 (87) | [RCP Language String](RCPSpecification.md#RCP-Language-String) | 0 | y | The label used on the switch if the value is off. | 1.0
<br />


### Checkbox:

| Name          | Option Id<br/>hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   | Since
| --------------|---------------------|-----------|-----------------|------------|---------------|----|
| indeterminate | 0x56 (86) | boolean | false | y | enable/disable the indeterminate state of the checkbox (e.g.: shows neither off nor on). | 1.0

<br />


### Press:

| Name          | Option Id<br/>hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   | Since
| --------------|---------------------|-----------|-----------------|------------|---------------|----|
| press-label-on | 0x56 (86) | [RCP Language String](RCPSpecification.md#RCP-Language-String) | 0 | y | The label used on the press-widget if the value is on. | 1.0
| press-label-off | 0x57 (87) | [RCP Language String](RCPSpecification.md#RCP-Language-String) | 0 | y | The label used on the press-widget if the value is off. | 1.0
<br />


### Textbox:

| Name          | Option Id<br/>hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   | Since |
| --------------|---------------------|-----------|-----------------|------------|---------------|----|
| multiline | 0x56 (86) | boolean | false | y | enable/disable multiline textfield. | 1.0
| password | 0x57 (87) | boolean | false | y | enable/disable if textbox is a password input. | 1.0
| placeholder | 0x58 (88) | [RCP Language String](RCPSpecification.md#RCP-Language-String) | "" | y | Text to be displayed if the value is empty. | 1.0
<br />



### Numberbox / Dial:

| Name          | Option Id<br/>hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   | Since
| --------------|---------------------|-----------|-----------------|------------|---------------|----|
| precision | 0x56 (86) | uint8 | 3 | y | The precision for value display. | 1.0
| stepsize-multiplier | 0x57 (87) | type of value | 1 | y | Assuming a numberbox has buttons to step the value up/down, this option defines a multiplier for Value.stepsize. If Value.stepsize == 0 then assume Value.stepsize to be 1 for this multiplication. | 1.0
| cyclic | 0x58 (88) | boolean | false | y | Inspector should wrap around Value.maximum and Value.minimum. | 1.0
| nan-meaning | 0x59 (89) | [RCP Language String](RCPSpecification.md#RCP-Language-String) | "NaN" | y | String that describes the meaning of NaN for float-values. | 1.0
<br />



### Slider:

| Name          | Option Id<br/>hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   | Since
| --------------|---------------------|-----------|-----------------|------------|---------------|----|
| precision | 0x56 (86) | uint8 | 3 | y | The precision for the value display. | 1.0
| stepsize-multiplier | 0x57 (87) | type of value | 1 | y | Assuming a numberbox has buttons to step the value up/down, this option defines a multiplier for Value.stepsize. If Value.stepsize == 0 then assume Value.stepsize to be 1 for this multiplication. | 1.0
| horizontal | 0x58 (86) | boolean | true | y | if slider is horizontal | 1.0
| nan-meaning | 0x59 (89) | [RCP Language String](RCPSpecification.md#RCP-Language-String) | "NaN" | y | String that describes the meaning of NaN in the context of the value. | 1.0
| trackfill-mode | 0x5a (90) | byte | 0 | y | Defines on which side of the slider the track is filled. | 1.0
<br />


| Trackfill Mode    | value   | Since |
| ------------------|---------|-------|
| None | 0 | 1.0
| Left | 1 | 1.0
| Center | 2 | 1.0
| Right | 3 | 1.0



### Range:

| Name          | Option Id<br/>hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   | Since
| --------------|---------------------|-----------|-----------------|------------|---------------|----|
| precision | 0x56 (86) | uint8 | 3 | y | The precision for the value display. | 1.0
| stepsize-multiplier | 0x57 (87) | type of value | 1 | y | Step the values up/down (e.g. with cursor keys), this option defines a multiplier for Value.stepsize. If Value.stepsize == 0 then assume Value.stepsize to be 1 for this multiplication. | 1.0
| nan-meaning | 0x58 (88) | [RCP Language String](RCPSpecification.md#RCP-Language-String) | "NaN" | y | String that describes the meaning of NaN in the context of the value. | 1.0
<br />


### URI

| Name          | Option Id<br/>hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   | Since
| --------------|---------------------|-----------|-----------------|------------|---------------|----|
| placeholder | 0x56 (86) | [RCP Language String](RCPSpecification.md#RCP-Language-String) | 0 | y | Text to be displayed if the value is empty. | 1.0
| button-label | 0x57 (87) | [RCP Language String](RCPSpecification.md#RCP-Language-String) | 0 | y | The label used on a button to open a file-dialog. | 1.0
<br />


### Image

| Name          | Option Id<br/>hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   | Since
| --------------|---------------------|-----------|-----------------|------------|---------------|----|
| overlay-text | 0x56 (86) | [RCP Language String](RCPSpecification.md#RCP-Language-String) | 0 | y | Text to be displayed as overlay. | 1.0
<br />


### Custom Widget:

| Name          | Option Id<br/>hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   | Since
| --------------|---------------------|-----------|-----------------|------------|---------------|----|
| widgetid          | 0x56 (86) | [RCP Int](RCPSpecification.md#RCP-Int) | 0 | y | ID of custom widget. The ID must be sent on initialize but can be omitted on incremental updates. | 1.0
| config        | 0x57 (87) | [RCP Int](RCPSpecification.md#RCP-Int) size-prefixed byte-array | - | y | Custom config - can be anything. | 1.0
