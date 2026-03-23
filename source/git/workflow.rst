.. _git-workflow:

Git workflow
============

This guide walks you through the most important concepts in Git and how to use them
day-to-day.

-----------
Key concepts
-----------

**Repository (repo)**
  A folder tracked by Git. It contains your files and the entire history of every change
  ever made to them.

**Commit**
  A snapshot of your changes. Each commit has a message describing what changed and why.
  Commits are the building blocks of your project's history.

**Branch**
  An independent line of development. The default branch is usually called ``main`` or
  ``main``. You create new branches to work on features or fixes without touching the
  main branch.

**Remote**
  A copy of the repository hosted somewhere else, typically GitHub. You push your changes
  to the remote to share them, and pull from it to receive others' changes.

-----------
First-time setup
-----------

Before your first commit, tell Git who you are. This information is attached to every
commit you make::

  git config --global user.name "Your Name"
  git config --global user.email "you@example.com"

-----------
Starting out
-----------

To start tracking an existing folder with Git::

  git init

More commonly, you'll begin by cloning an existing repository from GitHub::

  git clone [url]

This downloads the repository into a new folder and sets up the remote automatically.

-----------
Making changes
-----------

The basic loop of working with Git looks like this:

**1. Check what has changed**

Before doing anything, it's useful to see the current state of your working directory::

  git status

This shows which files have been modified, which are staged, and which are untracked.

**2. Stage your changes**

Git doesn't automatically include every changed file in your next commit — you choose
what to include by *staging* files::

  git add [filename]

To stage all changed files at once::

  git add -A

**3. Commit your changes**

A commit bundles your staged changes into a named snapshot::

  git commit -m "Describe what changed and why"

Write short, clear commit messages. A good rule of thumb: the message should complete
the sentence "This commit will...". For example: *"Add login form validation"* or
*"Fix broken link in the navbar"*.

Avoid vague messages like *"fix"*, *"stuff"*, or *"asdf"*. Your collaborators — and
future you — will be grateful.

**4. Repeat**

Make small, focused commits. It's much easier to review and understand a history where
each commit does one thing than one where a single commit changes everything at once.

-----------
Branching
-----------

Always do your work on a separate branch, not directly on ``main``. This keeps the
main branch stable and makes collaboration much easier.

Create a new branch and switch to it::

  git checkout -b my-feature

Work on your branch freely. You can always see which branch you're on with ``git status``
or::

  git branch

To switch to an existing branch::

  git checkout [branch-name]

-----------
Syncing with the remote
-----------

**Pushing** sends your local commits to GitHub::

  git push -u origin [branch-name]

The ``-u`` flag sets the upstream so that future pushes from this branch only need
``git push``.

**Pulling** downloads changes from the remote and applies them to your current branch::

  git pull

Do this on ``main`` regularly to stay up to date with your collaborators' work.

-----------
Updating your branch
-----------

While you've been working, others may have pushed changes to ``main``. Before opening
a pull request, incorporate those changes into your branch with ``rebase``::

  git checkout main
  git pull
  git checkout my-feature
  git rebase main

Rebase replays your commits on top of the latest ``main``, keeping the project history
clean and linear.

**Resolving conflicts**

If Git can't automatically combine changes, it will pause and ask you to resolve the
conflicts manually. Open the affected files (Git marks the conflicting sections) and
edit them until the file looks the way it should. Then::

  git add [resolved-file]
  git rebase --continue

If things go wrong and you want to start over::

  git rebase --abort

-----------
Pull requests
-----------

Once your branch is pushed to GitHub, open a **pull request** (PR). A PR is a request
to merge your branch into ``main``. It gives collaborators a chance to review your
changes, leave comments, and suggest improvements before anything reaches the main branch.

Write a clear description of what your PR does and why. If it closes an issue, mention
it. Address any feedback by making new commits on the same branch — the PR updates
automatically.

When everyone is satisfied, merge the PR into ``main``.

-----------
A note on force pushing
-----------

Avoid ``git push -f`` (force push). It rewrites the remote history and can permanently
destroy your collaborators' work. **Never force push to main.**

The only situation where overwriting remote history may be acceptable is on your own
feature branch after a local rebase. In that case, use ``--force-with-lease`` instead::

  git push --force-with-lease

Unlike plain ``-f``, this will refuse to push if someone else has pushed to the branch
since you last fetched a useful safety net.
