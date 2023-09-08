# git-redate
### Made by [Potato Labs](http://taterlabs.com)

Change the dates of several git commits with a single command.

![alt tag](https://i.stack.imgur.com/yE4cQ.gif)

# Installation

For homebrew users, you need to run `brew tap PotatoLabs/homebrew-git-redate` and then `brew install git-redate`.

If you're not using homebrew, you can clone this repo and move the `git-redate` file into any folders in your $PATH. Restart your terminal afterwards and you're good to go!

For window's users, you may paste the file into `${INSTALLATION_PATH}\mingw64\libexec\git-core`. Assuming you used the default settings the installation path will be `C:\Program Files\Git`.

# Usage

Simply run: `git redate --commits [[number of commits to view]]`.  You'll have to force push in order for your commit history to be rewritten.

To be able to edit all the commits at once add the --all option: `git redate --all`.  This option can be negated with `--no-all`.

You can also specify a range of commits[^git-gitrevisions-help] as a positional parameter, instead of `--count` or `--all`: `git redate HEAD~10..HEAD~6`

**Make sure to run this on a clean working directory otherwise it won't work.**

The `--commits` (a.k.a. `-c`) argument is optional, and defaults to 5 if not provided.

<!-- note that this renders an info box -->
> **Note**
> See `git redate -h` for further usage information.

## Configuration

You may set default values for various `git redate` options in your Git client configuration.[^git-config-help]

The available options are:

- `redate.all`: takes a boolean value (`true`, `false`, `yes`, `no`, etc.[^git-config-help]). When enabled, `git redate` defaults to editing all commits.
- `redate.commits`: takes a positive integer.  Used as the default number of commits to edit.
- `redate.debug`: takes a boolean value.  When enabled, `git redate` defaults to issuing extra diagnostic information to standard error.
- `redate.limit`: takes a positive integer.  Used as the default number of commits to modify in a single `git filter-branch` operation.

Example configuration:

```INI
[redate]
all = no
commits = 10
debug = true
limit = 35
```

[^git-gitrevisions-help]: See [`git help gitrevisions`](https://git-scm.com/docs/gitrevisions) for various ways to spell commit ranges.
[^git-config-help]: See [`git help config`](https://git-scm.com/docs/git-config) for more info on configuring your Git client.
