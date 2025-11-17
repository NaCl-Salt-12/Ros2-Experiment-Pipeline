# Using ros2experiment_pipeline

This is a pipeline for recording Ros2 experiments. It allows you to set a experiment name, that matches naming conventions and automatically launches your launch file and records all topics converts them to CSV files and uploads them to GitHub.
This is the process it follows:

- Runs a python script that captures the experiment name and ensures it matches naming conventions.
- the launch file is launched with the experiment name as an argument.
- the topic data is recorded using Ros2 bag
- the Ros2 bag files are converted to CSV files
- the files are then moved to a local git repository and committed and pushed to GitHub.

Running the script, once setup is complete all you need to do to run is execute the start_experiment.sh script:

```bash
bash start_experiment.sh
# OR
./start_experiment.sh
```

Feel free to modify the start_experiment.sh script to add or remove any functionality to suit your needs.

## Setup

Clone this repository to your local machine, but not into your ros2 workspace:

```bash
git clone https://github.com/NaCl-Salt-12/walfulls_ctrl.git
```

Then run the unpacking script to copy the necessary files into your ros2 workspace:

```bash
unpack.sh <path_to_your_ros2_workspace>
```

### Modify your launch file

Add your launch code the example launch file provided in the repo. Do not reorder the nodes and do not remove anything other than the example nodes.

### Modify the get_experiment_name.py (if desired)

The get_experiment_name.py script is used to capture the experiment name and ensure it matches naming conventions. You can modify this script to change the naming conventions or add additional functionality. Or change the location where the experiment history is stored.
Overall I do not recommend changing this script unless you have a specific need.

### Setup your git repository

#### Create a git repository

create a local git repository where your experiment data will be stored. This can be done using the following commands:

```bash
git iniit
git add .
git commit -m "Initial commit"
git remote add origin <your_git_repository_url>
```

Or you can clone a your new repository made in GitHub:

```bash
git clone <your_git_repository_url>
```

#### Create a deploy key

You will need to create a ssh key to allow the pipeline to push data to your git repository. Follow the steps provided [on github](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/managing-deploy-keys#deploy-keys) to set up your deploy key.

#### Configure the start_experiment script

At the top of the start-experiment script, you will find the following variables that need to be set:

- `DEPLOY_KEY_PATH`: The path to your deploy key. (i.e. /home/user/.ssh/id_rsa)
- `STAGE_PATH`: The path to a temporary staging directory where the experiment data will be stored before being moved to the git repository. (i.e. ${HOME}/bag_data) also used for local backups of ros2 bags.
- `GIT_PATH`: The path to your local git repository where the experiment data will be stored. (i.e. /home/user/experiment_logs)
- `SSH_URL`: The Git SSH URL of your git repository. (i.e. `git@github.com:USERNAME/REPOSITORY_NAME.git`) you can find this at the main page of the repository on GitHub, click on the green "Code" button and select "SSH" and copy the URL.

> [!NOTE]
> `{$HOME}` is a reference to your home directory, the same as `~`. You can use this variable in the paths above to make them relative to your home directory.

## FAQ

### **Q: Why have a staging directory?**

**A**: For two reasons: Backups and atomic commits. The staging directory is used to store the experiment data temporarily before being moved to the git repository. This allows for a backup of the ros2 bag files in case something goes wrong during the conversion to CSV or the git commit process. It also allows for atomic commits, meaning that all files are committed at once, rather than one at a time. This ensures that the experiment data is consistent and complete.

### Q: Why do not clone the repository into my ros2 workspace?

**A:** Because it allows for user customization of the pipeline without modifying the original repository. As well as allowing easer integration into existing ros2 workspaces, and git repositories. And allows use in multiple ros2 workspaces without duplicating the repository.
