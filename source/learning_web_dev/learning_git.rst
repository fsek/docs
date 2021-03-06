.. _learning-git:

Learning git
============

Git is a version control system that makes it possible for a team of developers to work on the same project and edit the same files simultaneously. We do this by having a *master version*, i.e. the current state of the project, online in a *repository* or *repo* on Github's website. Then, everyone downloads or *clones* the repo and edit their files locally. Note that the changes you make locally will not affect the live master version. Before you make changes though, you need to create a new version of the project or a *branch* that diverges from the master version. That is, we take the project in its current state (master version) and edit it, but we do not save the changes directly to the master branch and update the current state of the project. Rather, we only update our own version on our own branch.

When you're finished and happy with your changes you want to apply them to the master version and update the project. You do this by first updating our version of the master branch by *pulling* the latest version from the repo. We do this in case someone has updated it while we were making our changes. Then, we apply the master branch on our branch or *rebase* it and see if we have any conflicts with our changes. A conflict appears when the same file is edited in different ways. Github will show us these exact conflicts in the actual files and we can fix them. After that, we upload or *push* our changes to the repo and update our branch online. Now, the last thing we want to do is to apply our changes from our branch to the master branch. We do this by creating a *pull request* that tells the other developers that you want to update the master branch. They can then look at your changes and after they approve, you merge the branches i.e update the master branch with your changes. How all of this is actually done with commands and how you'll be working with Github is explained in Git workflow.

Codeacademy
-----------

- Workflow - https://www.codecademy.com/courses/learn-git/lessons/git-workflow
- Branching - https://www.codecademy.com/courses/learn-git/lessons/git-branching

Questions
---------

- What is a branch?
- Which three commands are used for saving your local changes and putting them on GitHub?
- What is a pull request?
- How does one resolve conflicts with some others changes when rebasing?
