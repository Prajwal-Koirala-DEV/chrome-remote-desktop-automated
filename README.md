# chrome-remote-desktop-automated

Welcome to **chrome-remote-desktop-automated**! This project simplifies the installation of Chrome Remote Desktop and all necessary tools in your virtual machine (VM) hosted on various cloud providers such as AWS, Digital Ocean, Linode, and others.

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Supported Cloud Providers](#supported-cloud-providers)
- [Contributing](#contributing)
- [License](#license)

## Introduction

Chrome Remote Desktop is a powerful tool that allows you to access your computer remotely. This automation script provides a straightforward way to set it up on your cloud VM, making remote access a breeze.

## Features

- **Automated Installation**: Installs Chrome Remote Desktop with a single command.
- **Cross-Provider Compatibility**: Works with multiple cloud providers including AWS, Digital Ocean, and Linode.
- **Dependency Management**: Installs all required dependencies automatically.
- **User-Friendly**: Simple and clear instructions for use.

## Requirements

- A virtual machine instance on a supported cloud provider.
- SSH access to the instance.
- Basic knowledge of command-line interface.

## Installation

To get started, clone this repository to your local machine:

```bash
git clone https://github.com/yourusername/chrome-remote-desktop-automated.git
cd chrome-remote-desktop-automated
```

Ensure you have the necessary permissions to execute scripts on your VM.

## Usage

1. **Connect to your VM** via SSH.

   ```bash
   ssh username@your-vm-ip
   ```

2. **Run the installation script**:

   ```bash
   bash install.sh
   ```

3. **Follow the prompts** to complete the setup. You may need to sign in to your Google account.

4. **Access your VM** from any device using Chrome Remote Desktop!

## Supported Cloud Providers

This automation script has been tested and is compatible with the following cloud providers:

- AWS
- Digital Ocean
- Linode
- Google Cloud Platform
- Any other provider that supports standard Linux distributions

## Contributing

Contributions are welcome! If you have suggestions for improvements or new features, feel free to open an issue or submit a pull request.

1. Fork the repository.
2. Create your feature branch (`git checkout -b feature/AmazingFeature`).
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`).
4. Push to the branch (`git push origin feature/AmazingFeature`).
5. Open a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

---

Thank you for checking out **chrome-remote-desktop-automated**! Happy remote accessing!
