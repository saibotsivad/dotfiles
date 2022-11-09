# dotfiles

Dotfiles for command line stuff.

## run setup

In this folder you will want to run:

    ./setup-COMPUTER.sh

Where `COMPUTER` is any of the computer names.

## new computer

You'll want to copy one of the `./setup-COMPUTER.sh` files, e.g.:

    cp setup-mbair.sh setup-COMPUTER.sh

## launch on login

To launch commands when logging in, you can do this:

    Create a text file containing your commands (bash script):

    #!/bin/bash

    # Start the MongoDB server
    /Applications/MongoDB/bin/mongod --dbpath /usr/local/mongo/data --fork --logpath /usr/local/mongo/log

    Save this file in ~/Library/Startup.cmd
    You can test it by double-clicking the file in the Finder
    Make it executable: chmod +x ~/Library/Startup.cmd
    Add this file in System Preferences > Accounts > Login items

note that the file can be anywhere, doesn't have to end with .cmd either. just chmod +x it



    Start Automator.app;
    Select "Application";
    Click "Show library" in the toolbar (if hidden);
    Add "Run shell script" (from the Actions/Utilities);
    Copy-and-paste your script into the window;
    Test it;
    Save it somewhere: a file called your_name.app will be created);
    Depending your MacOSX version:
        Old versions: Go to System Preferences → Accounts → Login items, or
        New version: Go to System Preferences → Users and Groups → Login items (top right);
    Add this newly-created app;

Log off, log back in, and you should be done. ;)
