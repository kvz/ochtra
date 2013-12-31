# Ochtra

Dispite testcases, syntax errors still find their way into our commits.

 - Maybe it was a change in that bash script that wasn't covered by tests. Too bad our deploys relied on it.
 - Maybe it was just a textual change and we didn't think it was necessary to run the associated code before pushing this upstream. Too bad we missed that quote.

Whatever the reason, 

> It's almost 2014 and we are still comitting broken code. 

This needs to change because in the

- Best case: Travis or Jenkins prevent those errors from hitting production and it's frustrating to go back and revert/redo that stuff. A waste of your time and state of mind, as you already moved onto other things.
- Worst case: your error goes unnoticed and hits production.

Git offers commit hooks to prevent bad code from entering the repository, but you have to install them on a local per-project basis.

Chances are you have been too busy/lazy and never took the time/effort to whip up a commit hook that could deal with all your projects and programming languages.

That holds true for me, however I recently had some free time and decided to invest it in cooking up `ochtra`. **O**ne **C**ommit **H**ook **T**o **R**ule **A**ll.

<!--more-->

## Features

I first set out to find existing hooks, but I found all of them had caveats I wanted to avoid. For example this hook:

 - Works on many languages (Ruby, JavaScript, Python, Bash, Go, and PHP)
 - Works on filenames with spaces
 - Works on initial commits
 - Will skip files that are staged to be deleted
 - Will not run when we're not currently on a branch
 - Checks files as staged in Git, not how they're currently happen to be saved in your working dir
 - Deals with discrepancies between linters sometimes printing errors on STDOUT vs STDERR

## The code

Feel free to review and suggest improvements on [Github](https://github.com/kvz/ochtra/blob/master/pre-commit).

## Test

Without installing anything, you can try `ochtra` on a local repository:

```bash
$ mkdir my-project && cd $_
$ git init
$ echo ";-)" > syntax-error.go
$ git add syntax-error.go
$ curl -s https://raw.github.com/kvz/ochtra/master/pre-commit |bash
```

This will showcase `ochtra` on a staged Go file with syntax errors without having to install or commit anything.

If you want to test `ochtra` against all languages, you can run the test suite:

```bash
git clone git@github.com:kvz/ochtra.git
cd ochtra
make test
```

## Install

As of Git 1.7.1, you can use the `init.templatedir` to store hooks that you want present in all your repositories. These files will be copied from e.g. `~/.gittemplate/` into your
current repo's `.git` dir upon every `git init`.

This also works for existing repos, and it will not overwrite files already present.

To install the pre-commit template type

```bash
$ mkdir -p ~/.gittemplate/hooks
$ curl https://raw.github.com/kvz/ochtra/master/pre-commit -o ~/.gittemplate/hooks/pre-commit \
 && chmod u+x $_
$ git config --global init.templatedir '~/.gittemplate'
```

The template is just sitting there. To install the hook into new (or existing!) repos, type

```bash
$ git init
```

From now on, any file you are about to commit will first be checked for syntax errors.

If you ever update your template you can type

```bash
$ rm .git/hooks/pre-commit && git init
```

in a repo to overwrite it there.

## Tips

- If you ever want to commit code and disable the pre-commit one time, type

```bash
$ git commit -n
```

This can be useful if you import big chunks of code that don't pass jshint yet.

## Feedback

It's a work in progress and I would like your feedback on this to make it harder, better, faster, stronger and have it support more languages. Our work is never over : )

Leave a comment here or let's collaborate on [Github](https://github.com/kvz/ochtra)

## Thanks to

These pages have been a great source of inspiration when building `ochtra`:

- <http://mark-story.com/posts/view/using-git-commit-hooks-to-prevent-stupid-mistakes>
- <http://stackoverflow.com/a/8842663/151666>
- <https://github.com/phpbb/phpbb/blob/develop-olympus/git-tools/hooks/pre-commit>

Taken from the introductory blogpost <http://kvz.io/blog/2013/12/29/one-git-commit-hook-to-rule-them-all/>


