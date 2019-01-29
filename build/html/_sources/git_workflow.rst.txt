Git workflow aka git gud
========================

The steps below describe going from an idea, implementing it and then adding it to the live website. If you're new to Github I would recommend heading here for a more general description of the workflow. It's important to understand the purpose of the steps below before you learn the actual commands.

--------------------------------------------------
1. Create a new branch: git checkout -b new-branch
--------------------------------------------------

This step ensures your changes won't interfere with the main branch of the website. When on your own branch you can change stuff without worrying about accidentally affecting the website.

--------------------
2. Make some changes
--------------------

--------------------------------------------------------
3. Prepare to upload changes: git add [FILENAME] [-FLAG]
--------------------------------------------------------

This command tells git that you are finished editing your files. The FLAG is optional and is useful if you want to add all changed files. If that is the case omit FILENAME and use A as flag.

-------------------------------------------------------------
4. Group changes and describe them: git commit [-m "message"]
-------------------------------------------------------------

Try to write a descriptive message to ensure changes make sense to any collaborator. If you write only git commit git will use a text editor where you can write your commit message. This allows multiline messages which can be useful.

------------------------------------------------------------------------------------------------------
5. Head to the master branch to ensure you have the latest version of the website: git checkout master
------------------------------------------------------------------------------------------------------

It's important to get the latest version to check if your changes interfere with any other changes.

--------------------------
6. Fetch changes: git pull
--------------------------

Downloads the latest version from GitHub. If no changes were downloaded go to step 11.

----------------------------------------------------
7. Return to your branch: git checkout [YOUR BRANCH]
----------------------------------------------------

--------------------------------------------------------------
8. Combine the changes to master with yours: git rebase master
--------------------------------------------------------------

Before adding the changes to the live website it's important to combine them with other changes. Doing this ensures no complication arises when later adding your changes. You will most likely get an "error" message saying your changes could not automatically be merged. If that is not the case then go to step 11.

--------------------------------------------------
9. Solve conflicts by doing any of the steps below
--------------------------------------------------

Edit each conflicting file and choose the changes you want to keep
You can choose an entire file from either master or your branch by running: git checkout [OURS/THEIRS] - [FILE NAME]
Note: THIS IS HIGHLY UNINTUITIVE
OURS: This will use the file from master
THEIRS: This will keep the file from your branch
Yes this is unintuitive but ours and theirs are from the master branch point of view.

----------------------------------------------------------------------------------------------------------------------------------
10. When you feel that you have solved all conflicts run (if this fails, keep fixing conflicts with step 9): git rebase --continue
----------------------------------------------------------------------------------------------------------------------------------

------------------------------------------
11. Push changes to GitHub: git push (-fu)
------------------------------------------

If you get an error about being behind the remote branch and still know you want to push run the command with the flag -fu.

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
12. Head over to GitHub and change to your branch. Create a pull request and describe your changes to potential reviewers. Make changes after suggestions from collaborators and bots.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
13. If you have several commits which can be logically grouped squash them with git rebase -i HEAD~x where x is the number of commits you wish to change. You are not required to change x commits, you simply have the possibility.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------
14. When you and your collaborators feel satisfied with the changes rebase them into master.
--------------------------------------------------------------------------------------------
