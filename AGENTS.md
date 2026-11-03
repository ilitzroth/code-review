# AGENTS.md

Notes for coding agents working on this repository.

## What this is

A fork of
[wandersoncferreira/code-review](https://github.com/wandersoncferreira/code-review),
an Emacs package for reviewing pull/merge requests from inside Emacs. Upstream
is unmaintained since December 2022. All work happens on the `port` branch,
which:

- ports the database layer to current EmacSQL and closql, and the Gitlab
  requests to current Ghub;
- removes Bitbucket support entirely;
- fixes Gitlab replies, approvals and review feedback.

Only the Gitlab backend has been tested since the port, against a self-hosted
instance (`git.robovision.ai`). The Github backend compiles but is untested.
Don't send changes upstream.

## Layout

All source files are at the top level:

- `code-review.el`: entry point, `code-review-mode` and its keymap, defcustoms.
- `code-review-interfaces.el`: generic functions each forge backend implements.
- `code-review-gitlab.el`, `code-review-github.el`: the backends.
- `code-review-db.el`: persistence (closql/EmacSQL, SQLite), classes for pull
  requests, buffers, paths and comments.
- `code-review-section.el`: renders the review buffer with magit-section; it
  overrides `magit-diff-insert-file-section` and `magit-diff-wash-hunk` while
  drawing.
- `code-review-comment.el`: the comment editing buffer.
- `code-review-actions.el`: interactive commands and the transient menu.
- `code-review-parse-hunk.el`, `code-review-utils.el`, `code-review-faces.el`:
  helpers.
- `test/`: buttercup specs. `docs/`: user documentation.

## Environment

The package is used with Emacs 31 and current MELPA versions of magit, forge,
ghub, closql and emacsql. It is installed from a checkout with
`package-vc-install-from-checkout`, which compiles the files in place.
`.elpaignore` keeps `test/` out of that compilation.

`Cask`, `Makefile` and `.github/workflows/` are upstream leftovers (Emacs 26/27,
CI only on `master`). They are not maintained and CI does not run on `port`.

## Checks

Byte-compile everything against the installed packages. Run it on a copy, so no
`.elc` files are left next to the sources of a live installation that expects to
recompile them itself:

```sh
d=$(mktemp -d) && cp *.el "$d" && rm -f "$d"/*-autoloads.el && cd "$d" &&
emacs -Q --batch \
  --eval '(progn (package-initialize) (package-activate (quote forge))
                 (push default-directory load-path))' \
  -f batch-byte-compile code-review*.el
```

The expected output is three warnings that `ghub-graphql` is obsolete, in
`code-review-github.el`. They stay because its replacement, `ghub-query`,
behaves differently and the Github code cannot be tested here. Any other warning
is new and should be fixed.

Tests use [buttercup](https://github.com/jorgenschaefer/emacs-buttercup), which
is not a runtime dependency; install it somewhere and run:

```sh
emacs -Q --batch \
  --eval '(progn (package-initialize) (package-activate (quote forge))
                 (push default-directory load-path))' \
  -l buttercup -f buttercup-run-discover test/
```

Known state of the suite:

- The test files lack a `lexical-binding: t` cookie, so current buttercup
  refuses to load them and every spec fails.
- With the cookie added, 42 of 43 specs pass. The failure expects
  `code-review-db--comment-already-written?` to return `t`; current dash makes
  `-contains-p` return the matching tail of the list instead, which callers
  treat the same way.

## Conventions

- Every file uses `lexical-binding: t`. Use `when-let*`/`if-let*`, not the
  obsolete unstarred forms.
- Keep new lines, comments and docstrings within 80 columns; Markdown is
  formatted with `mdformat --wrap=80`.
- Gitlab requests go through `code-review-gitlab--request` and its `--get`,
  `--post` and `--put` wrappers, which handle the host and the token lookup
  (`code-review-gitlab--auth`). Don't call `ghub-request` directly.
- Tokens come from auth-source. With `code-review-auth-login-marker` set to
  `forge`, Forge's tokens are reused, including those stored under the REST host
  `HOST/api/v4`.
- Features Gitlab doesn't support report "Not supported in Gitlab yet." rather
  than failing.
- Don't reintroduce Bitbucket code.
- Don't commit `.elc` or `*-autoloads.el` files.

## Testing against a forge

Opening a review only reads from the forge, so it is safe on any merge request.
Anything that writes (comments, replies, feedback, approval) must be tried on a
throwaway merge request in a test repository, never on a real colleague's merge
request.
