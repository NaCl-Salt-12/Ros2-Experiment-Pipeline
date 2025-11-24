#!/bin/bash

if [ "$#" -ne 1 ]; then
	echo "Usage: $0 <path_to_your_ros2_workspace>"
	exit 1
fi

if [ ! -d "$1" ]; then
	echo "ERROR: Provided path is not a directory: $1"
	exit 1
else
	echo "Found directory: $1"
fi

if find "$1" -type f -name "setup.bash" -print -quit | grep -q .; then
	echo "Ros2 workspace detected at: $1"
else
	echo "Ros2 workspace not found at: $1"
	while true; do
		# Prompt the user with a default choice in parentheses
		read -r -p "Do you want to continue? (y/n): " response

		# Use a case statement to check the input
		case "$response" in
		# Match 'y' or 'Y' for yes
		[yY])
			echo "Continuing setup..."
			break
			;;
		[nN])
			echo "Setup aborted by user."
			exit 1
			;;

		*)
			echo "Invalid input. Please enter 'y' or 'n'."
			;;
		esac
	done
fi

echo "Copying scripts to ros2 workspace..."

mkdir -p "$1/scripts"

for file in ./scripts/*; do
	if [ -f "$file" ]; then
		filename=$(basename "$file")

		if cp "$file" "$1/scripts/"; then
			echo "**$filename** copied successfully"
		else
			echo "ERROR: Failed to copy **$filename**"
			exit 1
		fi
	fi
done

echo "Successfully copied all scripts."

if [ -d "$1"/launch ]; then
	echo "Launch directory already exists in the workspace."
else
	mkdir -p "$1/launch"
	echo "Created launch directory in the workspace."
fi

for file in ./launch/*; do
	if [ -f "$file" ]; then
		filename=$(basename "$file")

		if cp "$file" "$1/launch/"; then
			echo "**$filename** copied successfully"
		else
			echo "ERROR: Failed to copy **$filename**"
			exit 1
		fi
	fi
done

echo "Successfully copied all launch files."

if cp ./start_experiment.sh "$1/"; then
	echo "start_experiment.sh copied successfully"
else
	echo "ERROR: Failed to copy start_experiment.sh"
	exit 1
fi

echo "All files copied successfully to the ROS2 workspace at: $1"

chmod +x "$1/start_experiment.sh"

echo "Unpacking complete."
echo "To finish setup please follow the instructions outlined in the README.md file."
