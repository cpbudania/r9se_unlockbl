#prepration and precautionary steps

1. downgrade your phone to rui 3.0
2. then update to XXXX
3. remove realme/oppo account (You also need to unlink the phone from the HeyTap cloud, unlink it from Find My as well)
4. remove screen lock
basically resetting phone to factory settings is recommended.
5. enable Oem Unlocking and Usb Debugging
6. dock usb debugging to the pc and do adb reboot edl command
7. You need to translate the format in Windows to Chinese, without this nothing will work, because there are calculations inside the scripts and they expect to receive a number with a comma separating the digits. (go to the control panel - select regional standards - select Chinese simplified writing (China) in the format field)

# now the tool work starts.

firstly open drv.exe which will install all the drivers required throughout the process

#folder 1

now open the folder 1 and create two folders named as Backup1 and Backup2

now open the script named 欧加真9008工具.bat and press "A" on the Keyboard and then select Backup1 as the backup folder and then press 3 on the keyboard
then translate the output given by the script and it will tell you whether to back up slot a or slot b. Once you've figured out which slot to backup to, 
go back to the program, and select 1 or 2 on your keyboard. (1 for slot a, 2 for slot b). Put your phone into edl mode, either via what I said above, or adb reboot edl. Let the script run until FULLY complete, script will ask you whether to return to main menu or reboot phone once it's completed (in chinese).
Now after the tool has returned to main menu, Press "B" on the keyboard and choose Backup2 Folder this time and select the slot which you used in the previous method and let the script run and do the backup.

Now our Backup part is done

Explaination for these A & B backups: so in first when select A in that case we actually read the whole package of the phone and backups the whole edl package of the phone
and in the second case (B) we actually do the full partition backup (Restore NAND) 
so in general both the backups are taken in case any problem occurs during unlocking process so we can restore our device using that backup

# folder 2

Now After we're done with folder 1
now open folder 2 and run "OPPOFindX6Pro刷机工具箱by某贼.bat"

now press 1 on the keyboard, now it will give you warnings while proceeding,
now connect your phone in edl mode through pressing vol + and - together when phone is in switched off condition.
now after connecting it will start unlocking and if two choices appear as below select 1

 1. Check Fastboot connection   2. Still cannot detect after multiple checks

now once a screen with bootloader mode appears it will ask to unlock bootloader or not then select yes 
and then your bootloader will be probably unlocked