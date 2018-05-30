# Pasta

> Another yet ZSH prompt

![screenshot](screenshot.png)

## Overview

Light, pretty fast and not so ugly prompt

### Shows

* Git status
* Node.js version
* Red promt character on non exit `0` codes
* Execution time(if it's more then `5`)

### Git Status Indicators

`*` after branch name show that it's dirty

| Variable | Indicator | Meaning |
|----------|-----------|---------|
| `ZSH_THEME_GIT_PROMPT_UNTRACKED` | Red % | Untracked files |
| `ZSH_THEME_GIT_PROMPT_ADDED` | Green ✓ | Files added to git |
| `ZSH_THEME_GIT_PROMPT_MODIFIED` | Blue * | Modified files |
| `ZSH_THEME_GIT_PROMPT_DELETED` | Red ✖ | Deleted files |
| `ZSH_THEME_GIT_PROMPT_RENAMED` | Blue ~ | Renamed files |
| `ZSH_THEME_GIT_PROMPT_UNMERGED` | Cyan # | Unmerged files 

## Installation

### As an [Oh My ZSH!](https://github.com/robbyrussell/oh-my-zsh) custom theme

Clone pasta into your custom plugins repo

```shell
git clone https://github.com/egorkaru/pasta $ZSH_CUSTOM/themes/pasta
ln -s $ZSH_CUSTOM/themes/pasta/pasta.zsh-theme $ZSH_CUSTOM/themes/
```
Then set a theme in your `.zshrc`

```shell
ZSH_THEME='pasta'
```

## License
`pasta` available under the terms of the MIT License.