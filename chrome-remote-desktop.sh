#!/bin/bash

# Chrome Remote Desktop Installation Script
# Purpose: This script automates the installation of Chrome Remote Desktop on your virtual machine.
# Author: Your Name
# Repository: https://github.com/yourusername/chrome-remote-desktop-automated

# ===========================================================
# Usage Instructions:
# ===========================================================

# 1. System Requirements:
#    Ensure you have 'curl' and 'apt' (for Debian-based systems) or 'yum' (for Red Hat-based systems) installed.
#    This script is compatible with most Linux distributions.

# 2. Downloading the Script:
#    Use the following command to download the script:
#    ```bash
#    curl -o /usr/local/bin/chrome-remote-desktop.sh https://raw.githubusercontent.com/Prajwal-Koirala-DEV/chrome-remote-desktop-automated/refs/heads/main/chrome-remote-desktop.sh
#    ```

# 3. Making the Script Executable:
#    Grant execution permissions to the script:
#    ```bash
#    chmod +x /usr/local/bin/chrome-remote-desktop.sh
#    ```

# 4. Running the Script:
#    Execute the script with root privileges:
#    ```bash
#    sudo bash /usr/local/bin/chrome-remote-desktop.sh
#    ```
#    Follow the on-screen instructions to complete the installation of Chrome Remote Desktop.

# ===========================================================
# Advanced Usage:
# ===========================================================

# - The script supports various command-line arguments for custom installations.
#   Refer to the repository's README.md for more details.
# - For automated deployments, environment variables can be set before running this script.

# ===========================================================
# Troubleshooting:
# ===========================================================

# - If you encounter issues, ensure your system is up-to-date and retry the installation.
# - For specific errors, refer to the 'Troubleshooting' section in the repository's documentation.

# ===========================================================
# Contributing:
# ===========================================================

# - Contributions to the script are welcome! Please follow the contributing guidelines in the repository.

# ===========================================================
# Contact Information:
# ===========================================================

# - For support, feature requests, or bug reports, please open an issue on the GitHub repository.

# ===========================================================
# License:
# ===========================================================

# - This script is licensed under the MIT License.
# - Note: This script is provided 'as is', without warranty of any kind.
#   The user is responsible for understanding the operations and risks involved.

# Check if the script is running as root
function check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "Error: This script must be run as root."
        exit 1
    fi
}

# Call the function to check root privileges
check_root

# Function to gather current system details
function system-information() {
    # This function fetches the ID, version, and major version of the current system
    if [ -f /etc/os-release ]; then
        # If /etc/os-release file is present, source it to obtain system details
        # shellcheck source=/dev/null
        source /etc/os-release
        CURRENT_DISTRO=${ID}                                                                              # CURRENT_DISTRO holds the system's ID
        CURRENT_DISTRO_VERSION=${VERSION_ID}                                                              # CURRENT_DISTRO_VERSION holds the system's VERSION_ID
        CURRENT_DISTRO_MAJOR_VERSION=$(echo "${CURRENT_DISTRO_VERSION}" | cut --delimiter="." --fields=1) # CURRENT_DISTRO_MAJOR_VERSION holds the major version of the system (e.g., "16" for Ubuntu 16.04)
    fi
}

# Invoke the system-information function
system-information

# Define a function to check system requirements
function installing-system-requirements() {
    # Check if the current Linux distribution is supported
    if { [ "${CURRENT_DISTRO}" == "ubuntu" ] || [ "${CURRENT_DISTRO}" == "debian" ] || [ "${CURRENT_DISTRO}" == "raspbian" ] || [ "${CURRENT_DISTRO}" == "pop" ] || [ "${CURRENT_DISTRO}" == "kali" ] || [ "${CURRENT_DISTRO}" == "linuxmint" ] || [ "${CURRENT_DISTRO}" == "neon" ]; }; then
        # Check if required packages are already installed
        if { [ ! -x "$(command -v curl)" ] || [ ! -x "$(command -v cut)" ]; }; then
            # Install required packages depending on the Linux distribution
            if { [ "${CURRENT_DISTRO}" == "ubuntu" ] || [ "${CURRENT_DISTRO}" == "debian" ] || [ "${CURRENT_DISTRO}" == "raspbian" ] || [ "${CURRENT_DISTRO}" == "pop" ] || [ "${CURRENT_DISTRO}" == "kali" ] || [ "${CURRENT_DISTRO}" == "linuxmint" ] || [ "${CURRENT_DISTRO}" == "neon" ]; }; then
                apt-get update
                apt-get install curl coreutils -y
            fi
        fi
    else
        echo "Error: Your current distribution ${CURRENT_DISTRO} version ${CURRENT_DISTRO_VERSION} is not supported by this script. Please consider updating your distribution or using a supported one."
        exit
    fi
}

# Call the function to check for system requirements and install necessary packages if needed
installing-system-requirements

# The following function checks if the current init system is one of the allowed options.
function check-current-init-system() {
    # This function checks if the current init system is systemd or sysvinit.
    # If it is neither, the script exits.
    CURRENT_INIT_SYSTEM=$(ps --no-headers -o comm 1)
    # This line retrieves the current init system by checking the process name of PID 1.
    case ${CURRENT_INIT_SYSTEM} in
    # The case statement checks if the retrieved init system is one of the allowed options.
    *"systemd"* | *"init"* | *"bash"* | *"sh"*)
        # If the init system is systemd or sysvinit (init), continue with the script.
        ;;
    *)
        # If the init system is not one of the allowed options, display an error message and exit.
        echo "Error: The ${CURRENT_INIT_SYSTEM} initialization system is currently not supported. Please stay tuned for future updates."
        exit
        ;;
    esac
}

# The check-current-init-system function is being called.
check-current-init-system

# The following function checks if there's enough disk space to proceed with the installation.
function check-disk-space() {
    # This function checks if there is more than 1 GB of free space on the drive.
    FREE_SPACE_ON_DRIVE_IN_MB=$(df -m / | tr --squeeze-repeats " " | tail -n1 | cut --delimiter=" " --fields=4)
    # This line calculates the available free space on the root partition in MB.
    if [ "${FREE_SPACE_ON_DRIVE_IN_MB}" -le 1024 ]; then
        # If the available free space is less than or equal to 1024 MB (1 GB), display an error message and exit.
        echo "Error: You need more than 1 GB of free space to install everything. Please free up some space and try again."
        exit
    fi
}

# The check-disk-space function is being called.
check-disk-space

# Define a function named 'install-chrome-remote-desktop'.
function install-chrome-remote-desktop() {
    # Check if chrome-remote-desktop is not installed by verifying if the command exists.
    # The '-x' checks if the file is executable, and the 'command -v' checks if it's in the PATH.
    if [ ! -x "$(command -v chrome-remote-desktop)" ]; then
        # Download Google's signing key and add it to the system's trusted GPG keys.
        curl -s https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/chrome-remote-desktop.gpg
        # Add the Chrome Remote Desktop repository to the system's list of package sources.
        echo "deb [arch=$(dpkg --print-architecture)] https://dl.google.com/linux/chrome-remote-desktop/deb stable main" | sudo tee /etc/apt/sources.list.d/chrome-remote-desktop.list
        # Update the package list to include the newly added repository.
        apt-get update
        # Set the DEBIAN_FRONTEND variable to 'noninteractive' to avoid prompts during installation.
        export DEBIAN_FRONTEND=noninteractive
        # Install Chrome Remote Desktop without asking for user confirmation (assume "yes" for prompts).
        apt-get install --assume-yes chrome-remote-desktop
    fi
}

# Call the function to start installing Chrome Remote Desktop.
install-chrome-remote-desktop

# Define a function named 'install-xdce-environment' to install the XFCE environment and related components.
function install-xdce-environment() {
    # Check if chrome-remote-desktop is not installed (the environment setup is dependent on this).
    if [ ! -x "$(command -v chrome-remote-desktop)" ]; then
        # Set the DEBIAN_FRONTEND variable to 'noninteractive' to avoid user prompts during installation.
        export DEBIAN_FRONTEND=noninteractive
        # Install the XFCE desktop environment along with some essential components.
        # xfce4: XFCE desktop, desktop-base: default themes, dbus-x11: DBus for X, xscreensaver: screen saver.
        apt-get install --assume-yes xfce4 desktop-base dbus-x11 xscreensaver
        # Write a configuration to ensure Chrome Remote Desktop uses the XFCE desktop session.
        sudo bash -c 'echo "exec /etc/X11/Xsession /usr/bin/xfce4-session" > /etc/chrome-remote-desktop-session'
        # Disable the LightDM display manager service as it isn't needed for remote desktop usage.
        systemctl disable lightdm.service
        # Install the task package for a full XFCE desktop experience.
        apt-get install --assume-yes task-xfce-desktop
        # Download Google Chrome's latest stable version, then install it while fixing any dependency issues.
        curl -L -o google-chrome-stable_current_amd64.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && sudo apt install --assume-yes --fix-broken ./google-chrome-stable_current_amd64.deb
    fi
}

# Call the function to install the XFCE environment and related components.
install-xdce-environment
