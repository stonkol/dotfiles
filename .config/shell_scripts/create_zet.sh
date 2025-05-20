##################### CREATE ZET #####################
# Ask to input the file name and create new file from a template
# Auto-injecting the current date and filename in the new file
alias zet='create_zet'

create_zet() {
    # Set the path where you want to create the file
    file_path=~/segunda-casa/pasillo/

    # Prompt user for the filename
    echo "Enter new file name: \c"
    read filename_input

    # Validate input to prevent potential issues
    if [[ ! $filename_input =~ ^[a-zA-Z0-9_-]+$ ]]; then
        echo "Invalid characters in the filename. Please use only letters, numbers, hyphens, or underscores."
        return 1
    fi

    # create unique identifier and links section
	current_date="$(date +"%Y-%m-%d %H:%m")"

    # Construct the filename with the user input and extension
    filename="${filename_input}.md"

    # Full path to the file
    full_path="${file_path}${filename}"

    # Check if the file already exists
    if [ -e "$full_path" ]; then
        echo "File already exists: $full_path"
    else
        # Template content for the new file
        template="# ${filename_input}\n\n##\n\n- date: ${current_date}\n\n- tags:\n"

        # Create the file with the template content
        echo -e "$template" > "$full_path"

        # Open the file in nvim with the full path
        nvim "$full_path"
    fi
}
