# ochtra [![Build Status](https://travis-ci.org/kvz/ochtra.png?branch=master)](https://travis-ci.org/kvz/ochtra)

ochtra stands for
**O**ne
**C**ommit
**H**ook
**T**o
**R**ule
**A**ll
and is an attempt at creating the definitive Git commit hook that:

 - Has a focus on keeping syntax errors out of your codebase, not being too opinionated about coding style
 - Works with all common languages (for now Ruby, JavaScript, Python, Bash, Dash, Go, PHP, XML, JSON, YAML)
 - Is globally installable for all repositories you work with

And deals with some common pitfalls you'll find in other hooks:

 - Works on initial commits
 - Will skip files that are staged to be deleted
 - Will not run when we're not currently on a branch
 - Can co-exist with your current commit hook, just rename it to `pre-ochtra`
 - Works on filenames with spaces
 - Checks files as staged in Git, not how they're currently saved in your working dir
 - Deals with discrepancies between linters sometimes printing errors on STDOUT vs STDERR

## Try it

Without installing anything, you can see `ochtra` in action on a local test repository:

```bash
mkdir test-repo && cd $_
git init
echo ";-)" > syntax-error.go
git add syntax-error.go
curl -s https://raw.github.com/kvz/ochtra/master/pre-commit |bash
```

This will show that `syntax-error.go` has indeed, a syntax error.

## Install

As of Git 1.7 you can install `ochtra` as a git template.

```bash
mkdir -p ~/.gittemplate/hooks
curl https://raw.github.com/kvz/ochtra/master/pre-commit -o ~/.gittemplate/hooks/pre-commit \
 && chmod u+x $_
git config --global init.templatedir '~/.gittemplate'
```

This will make it present in all newly create repositories.

Now, to install in existing repositories you can type

```bash
cd my-project
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

- [abtris](https://github.com/abtris) (YAML, JSON & XML support)
- Stefan Näwe (reporting issue)
- mihaeu (reporting issue)

## Tips

- If you already had a `pre-commit` hook that you want to preserve and have
executed before `ochtra`, just rename it to `pre-ochtra`.

- If you ever want to commit code and disable the pre-commit one time, type

```bash
$ git commit -n
```

This can be useful if you import big chunks of code that don't pass jshint yet.

- If you want to install linters, have a look
at the [.travis.yml](.travis.yml) file, it has instructions for all of them

## Thanks

These pages have been a source of inspiration when building `ochtra`:

- <http://mark-story.com/posts/view/using-git-commit-hooks-to-prevent-stupid-mistakes>
- <http://stackoverflow.com/a/8842663/151666>
- <https://github.com/phpbb/phpbb/blob/develop-olympus/git-tools/hooks/pre-commit>

## License

[MIT Licensed](LICENSE)
