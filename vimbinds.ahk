; vimbinds.ahk
; This script provides Vim-like keybindings for text editing in any application.
; It can be toggled on or off using the hotkey Option+V.

#Requires AutoHotkey v2.0
#SingleInstance Force

; #################################################################################
; # Settings
; #################################################################################

; Set the toggle hotkey
toggle_hotkey := "!v"

; Variable to track the state of the script (enabled or disabled)
global vim_mode_enabled := 0

; #################################################################################
; # Main Script Logic
; #################################################################################

; Toggle the script on or off
Hotkey toggle_hotkey, toggle_vim_mode

toggle_vim_mode(*) {
    global vim_mode_enabled
    vim_mode_enabled := !vim_mode_enabled
    if (vim_mode_enabled) {
        turn_on_vim_bindings()
        TrayTip "Vim Binds", "ON"
    } else {
        turn_off_vim_bindings()
        TrayTip "Vim Binds", "OFF"
    }
}

turn_on_vim_bindings() {
    ; Remap keys for normal mode
    Hotkey "j", Func("Send").Bind("{Down}")
    Hotkey "k", Func("Send").Bind("{Up}")
    Hotkey "h", Func("Send").Bind("{Left}")
    Hotkey "l", Func("Send").Bind("{Right}")
    Hotkey "w", move_word_forward
    Hotkey "b", move_word_backward
    Hotkey "e", move_to_end_of_word
    Hotkey "0", move_to_start_of_line
    Hotkey "$", move_to_end_of_line
    Hotkey "x", delete_char
    Hotkey "d", d_key_handler
    Hotkey "y", y_key_handler
    Hotkey "p", paste
    Hotkey "o", new_line_below
    Hotkey "O", new_line_above
    Hotkey "i", enter_insert_mode
    Hotkey "Escape", exit_insert_mode
    Hotkey "u", undo
    Hotkey "^r", redo
}

turn_off_vim_bindings() {
    ; Unmap all the keys by restoring their native function
    Hotkey "j", "j"
    Hotkey "k", "k"
    Hotkey "h", "h"
    Hotkey "l", "l"
    Hotkey "w", "w"
    Hotkey "b", "b"
    Hotkey "e", "e"
    Hotkey "0", "0"
    Hotkey "$", "$"
    Hotkey "x", "x"
    Hotkey "d", "d"
    Hotkey "y", "y"
    Hotkey "p", "p"
    Hotkey "o", "o"
    Hotkey "O", "O"
    Hotkey "i", "i"
    Hotkey "Escape", "Escape"
    Hotkey "u", "u"
    Hotkey "^r", "^r"
}

move_word_forward(*) {
    Send "^{Right}"
}

move_word_backward(*) {
    Send "^{Left}"
}

move_to_end_of_word(*) {
    Send "^{Right}"
    Send "{Left}"
}

move_to_start_of_line(*) {
    Send "{Home}"
}

move_to_end_of_line(*) {
    Send "{End}"
}

delete_char(*) {
    Send "{Delete}"
}

d_key_handler(*) {
    key := Input(,"V T0.4")
    if (key == "d") {
        delete_line()
    }
}

delete_line(*) {
    Send "{Home}+{End}{Delete}"
}

y_key_handler(*) {
    key := Input(, "V T0.4")
    if (key == "y") {
        yank_line()
    }
}

yank_line(*) {
    Send "{Home}+{End}"
    Send "^c"
}

paste(*) {
    Send "^v"
}

new_line_below(*) {
    Send "{End}{Enter}"
    enter_insert_mode()
}

new_line_above(*) {
    Send "{Home}{Enter}{Up}"
    enter_insert_mode()
}

enter_insert_mode(*) {
    global vim_mode_enabled
    if (vim_mode_enabled) {
        turn_off_vim_bindings()
        vim_mode_enabled := 0
        TrayTip "Vim Binds", "INSERT"
    }
}

exit_insert_mode(*) {
    global vim_mode_enabled
    if (!vim_mode_enabled) {
        turn_on_vim_bindings()
        vim_mode_enabled := 1
        TrayTip "Vim Binds", "NORMAL"
    }
}

undo(*) {
    Send "^z"
}

redo(*) {
    Send "^y" ; In many windows apps, redo is Ctrl+Y
}

; Initialize the script in the disabled state
turn_off_vim_bindings()
return 