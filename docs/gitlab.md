# Gitlab

## Auth

If you use Forge, reuse its token and skip the rest of this section:

``` emacs-lisp
(setq code-review-auth-login-marker 'forge)
```

Otherwise:

1. [Create a personal access token using Gitlab](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html)
2. Choose the `api` scope
3. Add a line to your auth source file, usually `~/.authinfo.gpg`, with your
   login and token:

```
machine gitlab.com/api login yourlogin^code-review password MYTOKENGOESHERE
```

The token is also found when the line names the REST endpoint instead
(`gitlab.com/api/v4`), which is where Forge stores its tokens.

## Self-hosted instances

Point these three options at your instance, e.g. for `git.example.com`:

``` emacs-lisp
(setq code-review-gitlab-base-url "git.example.com"          ; MR URLs
      code-review-gitlab-host "git.example.com/api"          ; REST
      code-review-gitlab-graphql-host "git.example.com/api") ; GraphQL
```

With these set, both `code-review-start` with an MR URL (including projects in
nested groups) and `code-review-forge-pr-at-point` work.

## Approve Merge Request

`r a` approves the merge request.  Gitlab's approve API takes no message, so
feedback set with `r s f` is posted as a separate comment next to the approval.

Gitlab's repository can require a password from users before approving a Merge
Request (see details
[here](https://docs.gitlab.com/ee/user/project/merge_requests/approvals/settings.html#require-user-password-to-approve))
and if this is enabled you will be prompted to type your username and password
again.

## Not supported

Requesting changes (`r r`) is not supported for Gitlab.
