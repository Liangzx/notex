# ubuntu update

```shell
# To check for a new Ubuntu release and ensure that all available updates
# are installed before upgrading, you can follow these steps:
# 1. Open the terminal: Launch the terminal application on your Ubuntu system.

# 2. Update the package lists: Run the following command to update the package lists from the repositories:
sudo apt update

# 3. Upgrade installed packages: After updating the package lists, upgrade the installed packages
# to their latest versions by running the following command:
sudo apt upgrade
# This command will upgrade all the installed packages to their latest versions.

# 4. Install release upgrade tool: Now, install the release-upgrade tool that will help
# you to upgrade to the new Ubuntu release. Run the following command:
sudo apt install update-manager-core

# 5. Check for a new release: Once all the updates are installed, run the following
#  command to check for a new Ubuntu release:
sudo do-release-upgrade -c
# This command will check for a new release and provide information about the availability of a new Ubuntu version.

# 6. If a new release is available, you can proceed with the upgrade process by running the following command:
sudo do-release-upgrade
# This command will initiate the upgrade process and guide you through the steps to upgrade your Ubuntu system.

```
