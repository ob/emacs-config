# emacs-config
My `.emacs` configuration files.

# Installing

I use [Hack](http://sourcefoundry.org/hack/) as my default font so you need to have it installed. 
The easiest way is to use [HomeBrew](https://brew.sh) and then type:

```
$ brew cask install font-hack
```

You also need Emacs installed, I use `emacs-mac`. You can install it like so:

```
$ brew tap railwaycat/emacsmacport
$ brew cask install emacs-mac
```

After that, clone this repository to your `~/.emacs.d` directory:

```
$ git clone https://github.com/ob/emacs-config.git ~/.emacs.d
```

Finally, open Emacs using the open command:

```
$ open /Applications/Emacs.app
```

If everything went well Emacs should open and self-configure, downloading all the necessary packages.
If you find bugs, please file an Issue.

Thanks,

-ob
