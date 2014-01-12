# ochtra

<!-- badges/ -->
[![Build Status](https://secure.travis-ci.org/kvz/ochtra.png?branch=master)](http://travis-ci.org/kvz/ochtra "Check this project's build status on TravisCI")

[![Gittip donate button](http://img.shields.io/gittip/kvz.png)](https://www.gittip.com/kvz/ "Sponsor the development of ochtra via Gittip")
[![Flattr donate button](http://img.shields.io/flattr/donate.png?color=yellow)](https://flattr.com/submit/auto?user_id=kvz&url=https://github.com/kvz/ochtra&title=ochtra&language=&tags=github&category=software "Sponsor the development of ochtra via Flattr")
[![PayPayl donate button](http://img.shields.io/paypal/donate.png?color=yellow)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=kevin%40vanzonneveld%2enet&lc=NL&item_name=Open%20source%20donation%20to%20Kevin%20van%20Zonneveld&currency_code=USD&bn=PP-DonationsBF%3abtn_donate_SM%2egif%3aNonHosted "Sponsor the development of ochtra via Paypal")
[![BitCoin donate button](http://img.shields.io/bitcoin/donate.png?color=yellow)](https://coinbase.com/checkouts/19BtCjLCboRgTAXiaEvnvkdoRyjd843Dg2 "Sponsor the development of ochtra via BitCoin")
<!-- /badges -->

ochtra stands for
**O**ne
**C**ommit
**H**ook
**T**o
**R**ule
**A**ll
and is an attempt at creating the definitive Git commit hook that:

 - Works on all your languages (for now Ruby, JavaScript, Python, Bash, Dash, Go, PHP, XML, JSON, YAML)
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
curl -s https://raw.github.com/kvz/ochtra/master/pre-commit -ko .git/hooks/pre-commit \
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
curl https://raw.github.com/kvz/ochtra/master/pre-commit -o ~/.gittemplate/hooks/pre-commit \
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
