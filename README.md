# msmid's dotfiles

Inspired by and based on:

https://github.com/andrew8088/dotfiles
https://github.com/mathiasbynens/dotfiles
https://github.com/holman/dotfiles

## TODO

- [ ] setup postgres, start&stop service

## GIT

Aliases: https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh

## Troubleshooting

### `ionic cap run ios` not showing target devices

If you installed full xcode and move it to Applications, you need to update 

```
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
```

Sauce: https://stackoverflow.com/questions/17980759/xcode-select-active-developer-directory-error/17980786#17980786