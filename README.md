# ochtra

<!-- badges/ -->
[![Build Status](https://secure.travis-ci.org/kvz/ochtra.png?branch=master)](http://travis-ci.org/kvz/ochtra "Check this project's build status on TravisCI") [![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fkvz%2Fochtra.svg?type=shield)](https://app.fossa.io/projects/git%2Bgithub.com%2Fkvz%2Fochtra?ref=badge_shield)

<!-- /badges -->

ochtra stands for
**O**ne
**C**ommit
**H**ook
**T**o
**R**ule
**A**ll
and is an attempt at creating the definitive Git commit hook that:

 - Works on all your languages (for now Ruby, JavaScript, Python, Bash, Dash, Go, PHP, XML, JSON, YAML, HTML)
 - Is globally installable for all your repositories
 - Aims to keep syntax errors from entering your codebase
 - Is not religous about coding style (you still can have your own custom `pre-ochtra` hook for that)

ochtra deals with some common pitfalls you'll find in other hooks:

 - Works on initial commits
 - Will skip files that are staged to be deleted
 - Will not run when we're not currently on a branch
 - Can co-exist with your current commit hook, just rename it to `pre-ochtra`
 - Works on filenames with spaces
 - Checks files as staged in Git, not how they're currently saved in your working dir
 - Deals with discrepancies between linters sometimes printing errors on STDOUT vs STDERR

## Try it now

Without installing anything, you can see ochtra in action on a local test repository:

```bash
cd /tmp
mkdir test-repo && cd $_

git init
curl -s https://raw.githubusercontent.com/kvz/ochtra/master/pre-commit -ko .git/hooks/pre-commit \
 && chmod u+x $_

echo ";-)" > syntax-error.go
git add syntax-error.go
git commit
```

You'll notice that ochtra won't let you commit that `syntax-error.go`:

![screen shot 2014-01-07 at 15 18 47](https://f.cloud.github.com/assets/26752/1859626/b1b5d4ac-77a6-11e3-9434-0d1485bfd13f.png)

Phew : ) Now for `.go` files it won't typically be a huge problem as your Go project won't run with syntax errors in the first place. But what about making that quick documentation change and leaving a typo? What about that Bash file in your repository? ochtra has got you covered.

## Install

As of Git 1.7 you can install ochtra as a git template.

```bash
mkdir -p ~/.gittemplate/hooks
curl https://raw.githubusercontent.com/kvz/ochtra/master/pre-commit -o ~/.gittemplate/hooks/pre-commit \
 && chmod u+x $_
git config --global init.templatedir '~/.gittemplate'
```

This will make it present in all newly create repositories.

Now, to install/update in existing repositories you can type

```bash
cd my-project
rm .git/hooks/pre-commit
git init # just copies any non-existing files from ~/.gittemplate to current repo
```

## Uninstall

To remove ochtra from one project, type

```bash
rm .git/hooks/pre-commit
```

To remove the automatic installer for new Git repos, type

```bash
git config --global --unset init.templatedir
# git config --global --remove-section init
```

## Tests

To run the tests:

```bash
make test
```

## Contributors

Feel free to report issues, comment on [my blog](http://kvz.io/blog/2013/12/29/one-git-commit-hook-to-rule-them-all/) or send a pull requests.

Contributors so far:

- [abtris](https://github.com/abtris) (YAML, JSON & XML support)
- Stefan Näwe (reporting issue)
- mihaeu (reporting issue)
- [Mischa ter Smitten](https://github.com/tersmitten) (curl fix for githubusercontent when installing)
- [Jan Dorsman](https://github.com/oldskool) (fix PHP error logging)
- [qdx](https://github.com/qdx) (fix pipestatus & Git invalid object bug)
- [Jostein Kjønigsen](https://github.com/josteink) (TypeScript support)
- [Dan Boulet](https://github.com/dboulet) (HTML support, improve YAML/Git/Go support and tests)

## Tips

- If you already had a `pre-commit` hook that you want to preserve and have
executed before ochtra, just rename it to `pre-ochtra`.

- If you ever want to commit code and disable the pre-commit one time, type

```bash
$ git commit -n
```

This can be useful if you import big chunks of code that don't pass jshint yet.

- If you want to install linters, have a look
at the [.travis.yml](.travis.yml) file, it has instructions for all of them

## Thanks

These pages have been a source of inspiration when building ochtra:

- <http://mark-story.com/posts/view/using-git-commit-hooks-to-prevent-stupid-mistakes>
- <http://stackoverflow.com/a/8842663/151666>
- <https://github.com/phpbb/phpbb/blob/develop-olympus/git-tools/hooks/pre-commit>

## License

[MIT Licensed](LICENSE)


[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fkvz%2Fochtra.svg?type=large)](https://app.fossa.io/projects/git%2Bgithub.com%2Fkvz%2Fochtra?ref=badge_large)