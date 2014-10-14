# vim-jekyll

Vim extensions for Jekyll 2 sites.

*Note: this is a prerelease version, which may change or break frequently.*

<!--[![Build Status][buildimg]](https://travis-ci.org/noahfrederick/vim-jekyll)-->

## Installation

### Dependencies

Technically, these dependencies are all optional, but the best features rely on
them.

- projectionist.vim
- dispatch.vim

## Development

### Testing

Tests are written for [vspec][vspec], which can be installed via
[vim-flavor][vim-flavor]:

	bundle install
	vim-flavor install

The test suite can then be run via the rake task:

	rake test

### Documentation

The documentation in `doc/` is generated from the plug-in source code via
[vimdoc][vimdoc]. Do not edit `doc/jekyll.txt` directly. Refer to the
existing inline documentation as a guide for documenting new code.

The help doc can be rebuilt by running:

	rake doc

[buildimg]: https://travis-ci.org/noahfrederick/vim-jekyll.png?branch=master
[vspec]: https://github.com/kana/vim-vspec
[vim-flavor]: https://github.com/kana/vim-flavor
[vimdoc]: https://github.com/google/vimdoc
