## Data Entry and Versioning using Git

The database is under version control using Git so that we can easily go back to previous states, it's automatically
backed up, and many people can access it and add records simultaneously from different computers.

This means that you will need to learn some basic Git commands for working with it. 

### Getting a ssh key
It may be useful to get a ssh key which helps Git know that you and the machine you are working on are both valid. This
is something you only need to do once (per machine that you work on), probably when you first get set up. Follow the
instructions [here](ssh_instructions.md).


### pull, add, commit, push
From your local machine, open Git (e.g. using Git Bash from a Windows machine), and 'pull' down the most up-to-date
version of the database after making sure you're in the right directory housing the repository.

```
$ cd /c/git/dietdatabase
$ git pull origin master
```

Once you've encountered a study with quantitative diet data to enter, you want to open the file 'AvianDietDatabase_template.txt' in Excel and re-save it, replacing the word 'template' with the study author and year, e.g. 'AvianDietDatabase_Beaver_and_Baldwin_1975.txt'. Now you need to tell Git that this is a file you want to keep track of. We do
this using `git add` like this:

```
$ git add AvianDietDatabase_Beaver_and_Baldwin_1975.txt
```

You can now begin entering data as described on the [main page](README.md). When you are finished with data entry for the day, be sure to Save As a tab-delimited .txt file (with the same name, in the same folder).

Now you need to stage your committed changes, add a descriptive message of what you've added, and 'push' the new version
to the master repository.

```
$ git commit -am "added 3 diet records for red-eyed vireo and 2 for white-eyed vireo"
$ git push origin master
```

Enter your github userid and password if prompted. Now your up-to-date files are available for incorporation into GloBI and
for others to add to!

## Potential Problems
Occasionally, when you try to push your latest changes, you will get an error like this:

```
error: failed to push some refs to 'https://github.com/hurlbertlab/dietdatabase.git'
hint: Updates were rejected because the remote contains work that you do
hint: not have locally. This is usually caused by another repository pushing
hint: to the same ref. You may want to first integrate the remote changes
hint: (e.g., 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
```

This comes up when two people both download the latest version of the database, and each
person makes some changes (i.e., adds some data) independent of the other. The second
person to try to push their changes doesn't have the changes made by the first, and so
Git points out the potential problem.

As the hint message suggests, try re-pulling the repository with a `$ git pull origin master`.
(Note that you need to have closed the database file on your machine before pulling,
or you will get a message that your file is "unlinked". In that case, just close the file
and try again.) Usually, this will take care of the problem and you will see a message like this:

```
Auto-merging AvianDietDatabase.txt
Merge made by the 'recursive' strategy.
```

In that case, Git figured out that you both were making changes to different parts of the 
database, and incorporated both sets of changes to the most up to date version.

However, if you were both editing the same part of the database (and this 
includes a scenario where both people are simply adding different data to the 
bottom of the file), you might see this message after you try to pull.

```
Auto-merging AvianDietDatabase.txt
CONFLICT (content): Merge conflict in AvianDietDatabase.txt
Automatic merge failed; fix conflicts and then commit the result.
```

In this case, Git couldn't figure out what to do, so you will have to resolve the problem
manually. Open the file that has the merge conflict like you normally would. Git 
has flagged the conflict within the region, so search (Ctrl-F) for the following
text: "<<<<<<< HEAD" (without the quotes). Now let's say you just added a row of data
for American Robin as the last line in the database, and someone else added a row of
data for Red-winged Blackbird. Then you will see something like this:

```
<<<<<<< HEAD
American Robin	(and whatever other data is in this line)
========
Red-winged Blackbird (and whatever other data is in THIS line)
>>>>>>>dca3kdjs33jdj3
```

Everything above the ======= line is one version, and everything below is the other
version. In this case, you want both of the edits to be saved in the final version,
so simply delete the entire lines starting with <<<<<<<, ========, and >>>>>>>.

```
American Robin	(and whatever other data)
Red-winged Blackbird (and whatever other data)
```

Then save the file, commit the change with a short message, and push it as you 
normally would. There should be no error messages!

In the event that both of you actually edited the same line in the database, and
one of the versions is out of date or incorrect, then you would simply delete
the edits you did not want to keep in addition to the <<<<<<, =======, and >>>>>>> lines.

```
<<<<<<< HEAD
American Robin	some wrong data on this line
=======
American Robin 	some correct data, or edits that you want to keep
>>>>>>>dca83kd9sfas933ks33
```

gets edited down to just

```
American Robin	some correct data, or edits that you want to keep
```

Save. Commit. Push.


