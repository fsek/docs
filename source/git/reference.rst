Reference
=========

A quick-reference list of common Git commands. All commands are prefixed with ``git``.

================
Setup
================

.. list-table::
   :widths: 40 60
   :header-rows: 1

   * - Command
     - Description
   * - ``config --global user.name "Name"``
     - Set your name (used in commits)
   * - ``config --global user.email "mail"``
     - Set your email (used in commits)
   * - ``init``
     - Initialize a new repo in the current folder
   * - ``clone [url]``
     - Clone a remote repository locally

================
Inspecting state
================

.. list-table::
   :widths: 40 60
   :header-rows: 1

   * - Command
     - Description
   * - ``status``
     - Show changed, staged, and untracked files
   * - ``log``
     - Show commit history
   * - ``log --oneline``
     - Compact commit history, one line per commit
   * - ``diff``
     - Show unstaged changes
   * - ``diff --staged``
     - Show staged changes (what will be committed)
   * - ``reflog``
     - Show history of HEAD movements — useful for recovering lost commits

================
Staging and committing
================

.. list-table::
   :widths: 40 60
   :header-rows: 1

   * - Command
     - Description
   * - ``add [file]``
     - Stage a specific file
   * - ``add -A``
     - Stage all changed files
   * - ``commit -m "message"``
     - Commit staged changes with a message
   * - ``commit --amend``
     - Modify the last commit (only before pushing)

================
Branching
================

.. list-table::
   :widths: 40 60
   :header-rows: 1

   * - Command
     - Description
   * - ``branch``
     - List all local branches
   * - ``branch [name]``
     - Create a new branch
   * - ``branch -d [name]``
     - Delete a branch (safe — refuses if unmerged)
   * - ``branch -D [name]``
     - Delete a branch (force)
   * - ``checkout [name]``
     - Switch to a branch
   * - ``checkout -b [name]``
     - Create a new branch and switch to it

================
Pushing and pulling
================

.. list-table::
   :widths: 40 60
   :header-rows: 1

   * - Command
     - Description
   * - ``push -u origin [branch]``
     - Push branch to remote and set upstream
   * - ``push``
     - Push to the configured upstream branch
   * - ``pull``
     - Fetch and merge changes from the remote
   * - ``fetch``
     - Download changes from remote without merging

.. warning::

   Avoid ``git push -f`` (force push). It overwrites remote history and can destroy
   your collaborators' work. **Never force push to main.** If you need to overwrite
   a remote feature branch after a local rebase, use ``git push --force-with-lease``
   instead — it will abort if someone else has pushed since you last fetched.

================
Rebasing
================

.. list-table::
   :widths: 40 60
   :header-rows: 1

   * - Command
     - Description
   * - ``rebase [branch]``
     - Replay your commits on top of another branch
   * - ``rebase --continue``
     - Continue after resolving a conflict
   * - ``rebase --abort``
     - Abort the rebase and return to the original state
   * - ``rebase -i HEAD~[n]``
     - Interactively edit the last ``n`` commits

In interactive rebase, each commit can be given one of the following actions:

- ``pick`` — keep the commit as-is
- ``reword`` — keep the commit but edit the message
- ``squash`` — fold into the commit above (combines messages)
- ``fixup`` — fold into the commit above (discards this message)
- ``drop`` — remove the commit entirely

================
Undoing things
================

.. list-table::
   :widths: 40 60
   :header-rows: 1

   * - Command
     - Description
   * - ``revert [commit]``
     - Create a new commit that undoes a previous one (safe, preserves history)
   * - ``reset --soft [commit]``
     - Move HEAD back, keep changes staged
   * - ``reset --mixed [commit]``
     - Move HEAD back, keep changes unstaged
   * - ``reset --hard [commit]``
     - Move HEAD back and discard all changes (destructive)
   * - ``checkout -- [file]``
     - Discard unstaged changes to a file

.. note::

   Prefer ``git revert`` over ``git reset`` when undoing changes that have already been
   pushed to a shared remote. ``revert`` is safe because it adds a new commit rather than
   rewriting history.
