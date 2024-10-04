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
    if { [ "${CURRENT_DISTRO}" == "ubuntu" ] || [ "${CURRENT_DISTRO}" == "debian" ] || [ "${CURRENT_DISTRO}" == "raspbian" ] || [ "${CURRENT_DISTRO}" == "pop" ] || [ "${CURRENT_DISTRO}" == "kali" ] || [ "${CURRENT_DISTRO}" == "linuxmint" ] || [ "${CURRENT_DISTRO}" == "neon" ] || [ "${CURRENT_DISTRO}" == "fedora" ] || [ "${CURRENT_DISTRO}" == "centos" ] || [ "${CURRENT_DISTRO}" == "rhel" ] || [ "${CURRENT_DISTRO}" == "almalinux" ] || [ "${CURRENT_DISTRO}" == "rocky" ] || [ "${CURRENT_DISTRO}" == "arch" ] || [ "${CURRENT_DISTRO}" == "archarm" ] || [ "${CURRENT_DISTRO}" == "manjaro" ] || [ "${CURRENT_DISTRO}" == "alpine" ] || [ "${CURRENT_DISTRO}" == "freebsd" ] || [ "${CURRENT_DISTRO}" == "ol" ]; }; then
        # Check if required packages are already installed
        if { [ ! -x "$(command -v curl)" ] || [ ! -x "$(command -v cut)" ]; }; then
            # Install required packages depending on the Linux distribution
            if { [ "${CURRENT_DISTRO}" == "ubuntu" ] || [ "${CURRENT_DISTRO}" == "debian" ] || [ "${CURRENT_DISTRO}" == "raspbian" ] || [ "${CURRENT_DISTRO}" == "pop" ] || [ "${CURRENT_DISTRO}" == "kali" ] || [ "${CURRENT_DISTRO}" == "linuxmint" ] || [ "${CURRENT_DISTRO}" == "neon" ]; }; then
                apt-get update
                apt-get install curl coreutils -y
            elif { [ "${CURRENT_DISTRO}" == "fedora" ] || [ "${CURRENT_DISTRO}" == "centos" ] || [ "${CURRENT_DISTRO}" == "rhel" ] || [ "${CURRENT_DISTRO}" == "almalinux" ] || [ "${CURRENT_DISTRO}" == "rocky" ]; }; then
                yum check-update
                yum install curl coreutils -y
            elif { [ "${CURRENT_DISTRO}" == "arch" ] || [ "${CURRENT_DISTRO}" == "archarm" ] || [ "${CURRENT_DISTRO}" == "manjaro" ]; }; then
                pacman -Sy --noconfirm archlinux-keyring
                pacman -Su --noconfirm --needed curl coreutils
            elif [ "${CURRENT_DISTRO}" == "alpine" ]; then
                apk update
                apk add curl coreutils
            elif [ "${CURRENT_DISTRO}" == "freebsd" ]; then
                pkg update
                pkg install curl coreutils
            elif [ "${CURRENT_DISTRO}" == "ol" ]; then
                yum check-update
                yum install curl coreutils -y
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
