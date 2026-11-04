[![GPL v3](https://img.shields.io/badge/license-GPL_v3-green.svg)](http://www.gnu.org/licenses/gpl-3.0.txt)

# Code Review

Review Github pull requests and Gitlab merge requests from Emacs: read the diff
and the discussion, write comments, replies and code suggestions, and approve or
request changes. The buffers are built with
[magit-section](https://emacsair.me/2020/01/23/magit-section/) and the commands
are in a [transient](https://github.com/magit/transient) menu.

> **This is a fork** of
> [wandersoncferreira/code-review](https://github.com/wandersoncferreira/code-review),
> which is unmaintained since December 2022 and no longer loads with current
> versions of its dependencies. The `port` branch:
>
> - ports the database layer to current EmacSQL and closql, and the Gitlab
>   requests to current Ghub (which dropped `glab-get` and friends);
> - removes Bitbucket support;
> - fixes Gitlab replies, approval and review feedback against current Gitlab,
>   and reviews each merge request on its own Gitlab instance.
>
> Only Gitlab has been tested since the port, on gitlab.com and on a self-hosted
> instance. Github compiles but is untested.

![Demo of code review package](./docs/code_review_demo.png)

## Installation

Do not install `code-review` from MELPA: that is the unported upstream version.
Install this fork's `port` branch with `package-vc`, which also installs the
dependencies from the archives (MELPA must be in `package-archives`):

```emacs-lisp
(package-vc-install
 '(code-review :url "https://github.com/ilitzroth/code-review" :branch "port"))
```

Or, from a local clone:

```emacs-lisp
(package-vc-install-from-checkout "~/path/to/code-review" "code-review")
```

## Documentation

The manual is in Info: `C-h i m Code Review RET`. Its source is
[docs/code-review.texi](./docs/code-review.texi); `code-review.info` and `dir`
at the top of the repository are built from it.

With `package-vc-install` the manual is found automatically. With
`package-vc-install-from-checkout`, add the clone to Info's path:

```emacs-lisp
(with-eval-after-load 'info
  (add-to-list 'Info-directory-list "~/path/to/code-review"))
```

## Quick start

- `M-x code-review-start` and give a PR URL, or
  `M-x code-review-forge-pr-at-point` on a PR in a Forge or Magit buffer.
- `RET` on a diff line to comment, on a comment to reply, on a local comment to
  edit it.
- `r` for the transient menu: `r s f` sets the feedback, `r a` approves, `r r`
  requests changes (Github only), `r c` sends the comments.

To use Forge's tokens, `(setq code-review-auth-login-marker 'forge)`. See the
manual's Gitlab and Github chapters for authentication and self-hosted
instances.

## Thanks

Thanks [Laurent Charignon](https://github.com/charignon) for the awesome
[github-review](https://github.com/charignon/github-review) package and
stewardship. Github Review made me more familiar with the problem domain and
`code-review` is an attempt to build on top of it.

Thanks [Ag Ibragimov](https://github.com/agzam) for the amazing idea to use
`magit-section` to build a more suitable interface to this problem.
