function edit_clipboard
    # Create a temporary file
    set temp_file (mktemp /tmp/clipboard_edit.XXXXXX)

    # Get the clipboard content and save it to the temporary file
    wl-paste > $temp_file

    # Open the temporary file in Neovim
    nvim $temp_file

    # Clean up the temporary file
    rm $temp_file
end

