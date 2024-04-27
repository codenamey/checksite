# Checksite Application

## Overview

Checksite is a utility for managing a site checking service. It provides basic commands to start, stop, and check the status of the service.

## Installation

Follow these steps to install Checksite on your system:

### Prerequisites

- Ensure you have administrative access to the system.
- `checksite.go` should be compiled if it's meant to be executed directly (not covered here).

### Steps

1. Clone the repository or download the files to your local machine.


2. Run the installation script with administrative privileges:
   ```bash
   sudo ./install.sh
   ```

3. If you like install manually just Copy the `checksite` script to the appropriate system directories:

   ```bash
   # Copy init script
   sudo cp etc/init.d/checksite /etc/init.d/
   
   # Copy application scripts
   sudo cp usr/local/bin/checksite.sh /usr/local/bin/

   sudo chmod u+x /etc/init.d/checksite /usr/local/bin/checksite.sh
```

## File Structure

After installation, your file structure should look like this:
/
|-- etc
|   `-- init.d
|       `-- checksite
`-- usr
    `-- local
        `-- bin
            |-- checksite.sh

checksite.go is not mentioned post-installation as it's assumed to be compiled or not required at runtime directly.

## Usage

```
# Start the service:

sudo /etc/init.d/checksite start

# Stop the service:

sudo /etc/init.d/checksite stop

# Check the status of the service:

sudo /etc/init.d/checksite status
```

