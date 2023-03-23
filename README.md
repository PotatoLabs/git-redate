# git-redate
### Made by [Potato Labs](http://taterlabs.com)

Change the dates of several git commits with a single command.

![alt tag](https://i.stack.imgur.com/yE4cQ.gif)

# Installation

For homebrew users, you need to run `brew tap PotatoLabs/homebrew-git-redate` and then `brew install git-redate`.

You can also create debian/rpm packages for installing by cloning this repo and running `make package` in the project directory.

The `make install` command can be used to directly install the script in the current system and `make uninstall` can be used to reverse the install operation.

If you want to do it manually you can move the `git-redate` file into any folders in your $PATH. Restart your terminal afterwards and you're good to go!

For window's users, you may paste the file into `${INSTALLATION_PATH}\mingw64\libexec\git-core`. Assuming you used the default settings the installation path will be `C:\Program Files\Git`.

# Usage

Simply run: `git redate --commits [[number of commits to view]]`.  You'll have to force push in order for your commit history to be rewritten.

To be able to edit all the commits at once add the --all option: `git redate --all`

**Make sure to run this on a clean working directory otherwise it won't work.**

The `--commits` (a.k.a. `-c`) argument is optional, and defaults to 5 if not provided.

