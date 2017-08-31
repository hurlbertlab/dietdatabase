# Generating a new ssh key on a Windows machine

1. In a git bash window, type:

 ```
 $ ssh-keygen -t rsa -C "your_email@example.com"
 ```

2. You'll be asked to enter your ssh directory and a passphrase. Just leave these blank and hit enter for each selection. The location of your ssh key and the key fingerprint are printed. The location should be in your home directory.
3. Type `ls .ssh` to be shown the ssh files. _Note: You can type_ `pwd` _to print the working directory location.
4. Navigate to the location of the ssh key in **Windows Explorer** (should be in the home folder of your user name).
5. Open the ssh file, *id_rsa.pub* (There will be two id_rsa files, if you cannot see the extension, it is the one listed as a Microsoft Publisher Document), in **notepad**.
6. Copy the *entire* contents of the file (Ctrl+A, Ctrl+C)
7. In your **web browser**, navigate to your GitHub account online.
  * Click the settings button (upper right-hand corner of your screen, looks like a bicycle sprocket).
  * Click the SSH keys menu option (under the personal settings).
  * Click the "Add SSH key".
  * Provide a title for the key (e.g., "Allens laptop").
  * Paste the **entire** contents of your clipboard in the "key" field and click the "Add key" button.
8. Navigate back to your **git bash** window. 
9. Test out whether you've successfully connected the key by typing (don't worry if there's a warning):

 ```ssh -T git@github.com```

10. Clone the dietdatabase repository by typing:
 
 ```git clone git@github.com:hurlbertlab/dietdatabase.git```
