##################### CREATE DAILY #####################
# Create new file from a template, which includes:
# 1. todo list
# 2. day hightlights
# 3. daily reflection
# Auto-injecting the template into the new file
#######################################################

alias day='create_daily'

create_daily() {
	# Set the path where you want to create the file
	file_path=~/[second-brain]/[office]/

	# Prompt user for the filename
	#  echo "Enter new file name: \c"
	#  read filename_input

	# Validate input to prevent potential issues
	#if [[ ! $filename_input =~ ^[a-zA-Z0-9_-]+$ ]]; then
	#    echo "Invalid characters in the filename. Please use only letters, numbers, hyphens, or underscores."
	#    return 1
	# fi

	# create unique identifier and links section
	current_date="$(date +"%Y-%m-%d")"

	# Construct the filename with the user input and extension
	filename="${current_date}.md"

	# Full path to the file
	full_path="${file_path}${filename}"

	# Check if the file already exists
	if [ -e "$full_path" ]; then
		echo "File already exists: $file_name"
		# Open the existing file in nvim
		nvim "$full_path"
	else
		# Template content for the new file
		template="# ${current_date} - Daily\n\n##\n\n- tags: \n\n## Todo List\n\n- [] - [] Movie\n\n## Hightlights\n\n\n## Reflections"

		# Create the file with the template content
		echo -e "$template" >"$full_path"

		# Open the file in nvim with the full path
		nvim "$full_path"
	fi
}
