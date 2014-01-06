# ochtra [![Build Status][BuildStatusIMGURL]][BuildStatusURL]

[BuildStatusIMGURL]:        https://secure.travis-ci.org/kvz/ochtra.png?branch=master
[BuildStatusURL]:           https://travis-ci.org/kvz/ochtra "Build Status"

## Synopsis

Ochtra stands for
**O**ne
**C**ommit
**H**ook
**T**o
**R**ule
**A**ll
and is an attempt at a definitive Git commit hook that:

 - Has a focus on keeping syntax errors out of your codebase, not being too opinionated about coding style
 - Works with many languages (for now Ruby, JavaScript, Python, Bash, Dash, Go, PHP, XML)
 - Is globally installable for all repositories you work with

And deals with some common pitfalls you'll find in other hooks:

 - Works on initial commits
 - Will skip files that are staged to be deleted
 - Will not run when we're not currently on a branch
 - Works on filenames with spaces
 - Checks files as staged in Git, not how they're currently happen to be saved in your working dir
 - Deals with discrepancies between linters sometimes printing errors on STDOUT vs STDERR

[![Build Status](https://travis-ci.org/kvz/ochtra.png?branch=master)](https://travis-ci.org/kvz/ochtra)

## Try

Without installing anything, you can see `ochtra` in action on a local repository:

```bash
mkdir my-project && cd $_
git init
echo ";-)" > syntax-error.go
git add syntax-error.go
curl -s https://raw.github.com/kvz/ochtra/master/pre-commit |bash
```

## Install

As of Git 1.7 you can install `ochtra` as a git template. This will make it present in all new repositories.

```bash
mkdir -p ~/.gittemplate/hooks
curl https://raw.github.com/kvz/ochtra/master/pre-commit -o ~/.gittemplate/hooks/pre-commit \
 && chmod u+x $_
git config --global init.templatedir '~/.gittemplate'
```

Now, to install in existing repositories you can type

```bash
rm .git/hooks/pre-commit
git init # just copies any non-existing files from ~/.gittemplate to current repo
```

## Tests

To run the (basic) tests:

```bash
make test
```

## Contributors

Feel free to report issues, comment on [my blog](http://kvz.io/blog/2013/12/29/one-git-commit-hook-to-rule-them-all/) or send a pull requests.

Contributors so far:

- Stefan Näwe (reporting issue)
- mihaeu (reporting issue)

## Tips

- If you ever want to commit code and disable the pre-commit one time, type

```bash
$ git commit -n
```

This can be useful if you import big chunks of code that don't pass jshint yet.

## Thanks

These pages have been a source of inspiration when building `ochtra`:

- <http://mark-story.com/posts/view/using-git-commit-hooks-to-prevent-stupid-mistakes>
- <http://stackoverflow.com/a/8842663/151666>
- <https://github.com/phpbb/phpbb/blob/develop-olympus/git-tools/hooks/pre-commit>

## License

[MIT Licensed](LICENSE)
