;;; code-review-gitlab-test.el --- Test the Gitlab backend
;;; Commentary:
;;; Code:

(require 'buttercup)
(require 'code-review-gitlab)

(describe "code-review-gitlab-fix-diff"
  (it "writes rename headers for a renamed file"
    (expect (code-review-gitlab-fix-diff
             '(((diff . "@@ -1 +1 @@\n-a\n+b\n") (new_path . "new.txt")
                (old_path . "old.txt") (a_mode . "100644")
                (b_mode . "100644") (renamed_file . t))))
            :to-equal (concat "diff --git old.txt new.txt\n"
                              "rename from old.txt\nrename to new.txt\n"
                              "index 1111..2222 100644\n"
                              "--- old.txt\n+++ new.txt\n"
                              "@@ -1 +1 @@\n-a\n+b")))
  (it "writes only headers for a file without diff text"
    (expect (code-review-gitlab-fix-diff
             '(((diff . "") (new_path . "py.typed") (old_path . "py.typed")
                (a_mode . "0") (b_mode . "100644") (new_file . t))))
            :to-equal (concat "diff --git py.typed py.typed\n"
                              "new file mode 100644\n"
                              "index 0000000000000000000000000000000000000000"
                              "..1111")))
  (it "adds the missing final newline between files"
    (expect (code-review-gitlab-fix-diff
             '(((diff . "@@ -1 +1 @@\n-a\n+b") (new_path . "a") (old_path . "a")
                (a_mode . "100644") (b_mode . "100644"))
               ((diff . "@@ -1 +1 @@\n-c\n+d\n") (new_path . "b")
                (old_path . "b") (a_mode . "100644") (b_mode . "100644"))))
            :to-match "^\\+b\ndiff --git b b$")))

(describe "code-review-gitlab--host"
  (it "uses the host recorded for the pull request"
    (expect (code-review-gitlab--host
             (code-review-gitlab-repo :owner "o" :repo "r" :number "1"
                                      :host "git.example.com/api"))
            :to-equal "git.example.com/api"))
  (it "falls back to `code-review-gitlab-host'"
    (let ((code-review-gitlab-host "fallback.example.com/api"))
      (expect (code-review-gitlab--host
               (code-review-gitlab-repo :owner "o" :repo "r" :number "1"))
              :to-equal "fallback.example.com/api"))))

(provide 'code-review-gitlab-test)
;;; code-review-gitlab-test.el ends here
