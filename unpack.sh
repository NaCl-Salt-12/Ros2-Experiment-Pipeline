#!/bin/bash

skip_environment_setup=false
skip_launch_file=false
skip_scripts=false
skip_start_script=false

while [[ $# -gt 0 ]]; do
	case $1 in
	--skip-env-setup)
		skip_environment_setup=true
		shift
		;;
	--skip-launch)
		skip_launch_file=true shift
		;;
	--skip-scripts)
		skip_scripts=true
		shift
		;;
	--skip-start-script)
		skip_start_script=true
		shift
		;;
	-h | --help)
		echo "Usage: $0 [--skip-env-setup] <path_to_your_ros2_workspace>"
		echo ""
		echo "Options:"
		echo "  --skip-env-setup    Skip the Python environment setup step."
		echo "  --skip-launch       Skip copying launch files."
		echo "  --skip-scripts      Skip copying scripts."
		echo "  --skip-start-script Skip copying start_experiment.sh."
		exit 0
		;;
	*)
		break
		;;
	esac
done

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

if [[ "$skip_scripts" == "true" ]]; then
	echo "Skipping copying scripts as per user request."
else

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
fi

if [[ "$skip_launch_file" == "true" ]]; then
	echo "Skipping copying launch files as per user request."
else
	echo "Copying launch files to ros2 workspace..."
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
fi

if [[ "$skip_start_script" == "true" ]]; then
	echo "Skipping copying start_experiment.sh as per user request."
else
	echo "Copying start_experiment.sh to ros2 workspace..."
	if cp ./start_experiment.sh "$1/"; then
		echo "start_experiment.sh copied successfully"
		chmod +x "$1/start_experiment.sh"
	else
		echo "ERROR: Failed to copy start_experiment.sh"
		exit 1
	fi
fi

echo "All files copied successfully to the ROS2 workspace at: $1"

if [[ "$skip_environment_setup" == "true" ]]; then
	echo "Skipping python environment setup as per user request."
	chmod +x "$1/start_experiment.sh"
	echo "Unpacking complete."
	echo "To finish setup please follow the instructions outlined in the README.md file."
	exit 0
fi

echo "Setting up python environment..."

if python3 -m venv "$1/scripts/script_env"; then
	echo "Virtual environment created successfully."
else
	echo "ERROR: Failed to create virtual environment."
	exit 1
fi

source "$1/scripts/script_env/bin/activate"

pip install --upgrade pip

pip install -r requirements.txt

echo "Unpacking complete."
echo "To finish setup please follow the instructions outlined in the README.md file."
