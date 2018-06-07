# Installation checklist:

## Install packages and sync dotfiles

```
./install.sh
```

## Add Github ssh key

```
ssh-keygen -t rsa -b 4096 -C "kevindrosendahl@gmail.com" -f ~/.ssh/id_rsa-github
cat ~/.ssh/id_rsa-github.pub
```

## Follow platform specific checklist

- [macOS](./platform/darwin/README.md)
