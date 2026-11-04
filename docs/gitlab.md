# Gitlab

## Auth

If you use Forge, reuse its token and skip the rest of this section:

```emacs-lisp
(setq code-review-auth-login-marker 'forge)
```

Otherwise:

1. [Create a personal access token using Gitlab](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html)
1. Choose the `api` scope
1. Add a line to your auth source file, usually `~/.authinfo.gpg`, with your
   login and token:

```
machine gitlab.com/api login yourlogin^code-review password MYTOKENGOESHERE
```

The token is also found when the line names the REST endpoint instead
(`gitlab.com/api/v4`), which is where Forge stores its tokens.

## Self-hosted instances

Each review uses the Gitlab instance of its merge request, so reviews on
gitlab.com and on self-hosted instances work side by side without any
configuration:

- From Forge (`code-review-forge-pr-at-point`), the API host is the one Forge
  uses for the repository.
- From a URL (`code-review-start`), any `https://HOST/…/-/merge_requests/N` URL
  is recognized. The API host is the one in HOST's entry in `forge-alist`, or
  else `HOST/api`.

Ghub finds your username in the Git variable `gitlab.HOST.user`, or else
`gitlab.user`, as for Forge:

```sh
git config --global gitlab.git.example.com.user yourlogin
```

`code-review-gitlab-host` and `code-review-gitlab-graphql-host` are only used
for reviews saved before the host was recorded, and for an instance whose API
host isn't `HOST/api` and isn't in `forge-alist`. In that case set them, with
`code-review-gitlab-base-url`, for that instance, e.g. for `git.example.com`:

```emacs-lisp
(setq code-review-gitlab-base-url "git.example.com"          ; MR URLs
      code-review-gitlab-host "git.example.com/api"          ; REST
      code-review-gitlab-graphql-host "git.example.com/api") ; GraphQL
```

## Approve Merge Request

`r a` approves the merge request. Gitlab's approve API takes no message, so
feedback set with `r s f` is posted as a separate comment next to the approval.

Gitlab's repository can require a password from users before approving a Merge
Request (see details
[here](https://docs.gitlab.com/ee/user/project/merge_requests/approvals/settings.html#require-user-password-to-approve))
and if this is enabled you will be prompted to type your username and password
again.

## Not supported

Requesting changes (`r r`) is not supported for Gitlab.
