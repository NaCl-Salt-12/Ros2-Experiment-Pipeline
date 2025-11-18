# Using ROS2-Experiment-Pipeline

This pipeline automates the recording/logging of experiments using the ROS2 framework. It handles experiment naming conventions, launches your configuration, records topics, converts data to CSV format, and uploads results to GitHub.

### Process Overview

The pipeline executes the following steps:

1. Captures and validates the experiment name against naming conventions
2. Launches the specified launch file with the experiment name as an argument
3. Records topic data using ROS2 bag
4. Converts ROS2 bag files to CSV format
5. Moves files to a local Git repository, commits, and pushes to GitHub

### Running the script

Once setup is complete, execute the experiment script:

```bash
bash start_experiment.sh
# OR
./start_experiment.sh
```

Feel free to modify the start_experiment.sh script to add or remove any functionality to suit your needs.

## Setup

### Clone the repository

Clone this repository outside of your ROS2 workspace:

```bash
git clone https://github.com/NaCl-Salt-12/ROS2-Experiment-Pipeline.git
```

### Unpack Files

Run the unpacking script to copy the necessary files into your ROS2 workspace:

```bash
unpack.sh <path_to_your_ros2_workspace>
```

### Modify your experiment_launch file

Add your launch code to the example launch file provided in the repository. Do not reorder the nodes or remove anything other than the example nodes.

### Modify get_experiment_name.py (Optional)

The get_experiment_name.py script captures and validates experiment names. You can modify this script to:

- Change naming conventions
- Add additional functionality
- Modify the experiment history storage location

Modifying this script is not recommended unless you have a specific requirement.

### Setup your git repository

#### Create a git repository

Create a local Git repository for storing experiment data:

```bash
git iniit
git add .
git commit -m "Initial commit"
git remote add origin <your_git_repository_url>
```

Alternatively, clone an existing repository from GitHub:

```bash
git clone <your_git_repository_url>
```

#### Create a deploy key

Generate an SSH key to enable the pipeline to push data to your Git repository. Follow the [GitHub documentation on deploy keys](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/managing-deploy-keys#deploy-keys) for setup instructions.

### Configure the start_experiment Script

Set the following variables at the top of the `start_experiment.sh` script:

- `DEPLOY_KEY_PATH`: Path to your deploy key. (e.g., `${HOME}/.ssh/id_rsa`)
- `STAGE_PATH`: Path to a temporary staging directory for experiment data before moving to the Git repository (e.g.,`${HOME}/bag_data`). Also used for local backups of ROS2 bags
- `GIT_PATH`: Path to your local Git repository for experiment data storage (e.g., `${HOME}/experiment_logs`)
- `SSH_URL`: Git SSH URL of your git repository. (e.g., `git@github.com:USERNAME/REPOSITORY_NAME.git`) Find this on your repository's main page by clicking the green "Code" button and selecting "SSH"

> [!NOTE]
> `{$HOME}` references your home directory (equivalent to ~) and should be used in the paths above to make them relative to your home directory.

## FAQ

### **Q: Why have a staging directory?**

**A**: The staging directory serves two purposes: backups and atomic commits. It temporarily stores experiment data before moving it to the Git repository, providing a backup of ROS2 bag files in case of conversion or commit failures. It also enables atomic commits, ensuring all files are committed simultaneously for consistent and complete experiment data.

### Q: Why do not clone the repository into my ROS2 workspace?

**A**: Keeping the repository separate from your ROS2 workspace provides several benefits:

- Enables pipeline customization without modifying the original repository
- Simplifies integration into existing ROS2 workspaces and Git repositories
- Allows usage across multiple ROS2 workspaces without repository duplication
