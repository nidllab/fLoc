
# fLoc Installation

Version: $Id:$ $Format:%cd by %aN$

# Always download the latest version from GitHub!


[toc]

# Requirements

- Matlab (tested on 2018b)
- Psychtoolbox 3

# Setup Matlab

1. Open Matlab
2. Type `pathtool` to open the path dialog
3. Remove any reference to an existing `fam-fLoc` folder/subfolders
4. Click **Add Folder**
5. Select the `fam-fLoc` folder. **Do not add subfolders.**
6. Click **Save**


# Protect files

1. Open the `fam-fLoc folder`
2. Select all the `.m` files (`fLoc`) and the `functions` folder.
3. Right click > Properties
4. Check **Read Only** under Attributes
5. Click **OK**


# Site-specific configuration

## Picture size

Note: this configuration is specific to the Matlab license, not the specific machine.

1. On the presentation PC, type `license` in the version of Matlab you will be using
2. Add a row to `functions/floc_machine_config.csv`, with
    - the output of `license` in the first column
    - the pixel size of the images in the second column
    - an optional note in the third column

    e.g. `1144620,378,uconn`
3. Save the `floc_machine_config.csv file`






