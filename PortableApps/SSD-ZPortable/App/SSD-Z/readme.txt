Program Description
-------------------
SSD-Z is an information tool for Solid State Drives and other disk devices.

Using a database, it will show information about your SSD, such as the controller, processing tech, NAND type etc.

Other useful information related to disk devices are also shown, such as S.M.A.R.T. status and partition layout.

Main Features
-------------
- Details of the controller and processing tech of NAND chips (for known devices).
- Verify that TRIM is enabled for your system and SSDs.
- S.M.A.R.T. status and full list of all the device's available attributes.
- List of all partitions. Including hidden, unmapped and boot partitions.
- Benchmark IOPS, transfer speed and random access time (work in progress)
- View the raw device identify data words.

Missing Features & Issues in Beta
---------------------------------
- Some formatted SMART values may display incorrectly. Bytes written/read especially.
- No individual details for each drive in a RAID array.
- No SMART attributes for certain external USB drives.
- Benchmark not fully implemented.
- Support for NVMe devices is incomplete.

Contribute
----------
Are the details for your SSD not being shown, or are they incorrect, then please help out.

Within SSD-Z, make sure the SSD in question is selected, then go to the Submit tab. Now fill in
any comments you may have, and add your email if you wish. Then submit the data to the online database.

Frequently Asked Questions
--------------------------
Q: SSD-Z does not seem to know my SSD.
A: Please use the submission feature for your SSD.

Q: Certain SMART attributes does not show a formatted or raw value.
A: This is because the raw value is zero. Zeros are not shown by design.

Q: Why is the benchmark feature so bad?
A: This area of SSD-Z is incomplete, and is still work in progress.

Keyboard Shortcuts
------------------
Alt + Q					Quits the program.
1, 2, 3...				Selects the drive with this index.
Alt + Left / Right		Select previous / next device.
Ctrl + 1, 2, 3...		Changes the active tab.
Ctrl + PgUp / PgDn		Activate previous / next tab.
Ctrl + D				Activates the previously selected tab.
F2						Opens the configurations tab.
F5, Ctrl+R				Refresh active device.
Ctrl+F5, Ctrl+Shift+R	Do a full refresh, enumerating new devices.
F9						Toggle serial number visibility.
F12						Spawn a new instance with the same command line parameters.
Ctrl + T / Ins			Duplicates the current tab page.
Ctrl + W / Del			Removes the current tab page.
Alt + 1, 2, 3, 4		Resize window, 100%, 150%, 250%, 300%. Last two are width only.
Alt + Enter				Toggles window being maximized

Device Color Coding
-------------------
Green for SSD
Orange for HDD and other devices
Purple for NVMe
Pink for Removable
Teal for Optical Drives

Command Line Parameters
-----------------------
-page		<index>		Sets the initial starting tab page.
-device		<index>		Starts up showing this device index.
-size		<w> <h>		Resizes the main window to the specified width and height.
-pos		<x> <y>		Places the window at the given x and y coordinates.

Terminology
-----------
Device/Disk			The physical unit itself. Disk refering to old style HDDs.
Partition			The regions which the disk has been devided into.
Volume				Partitions properly formatted with an assigned drive letters.
Drive				Interchangeably used as both the physical unit, as well as a partition with an assigned letter.

Manufacturer Logos
------------------
Dimension: 88 x 88 px
Preferably 8-bit colors, if the logo colors allows it. Otherwise 24-bit.
Note for images less than 88 pixels, the image will be centered on a white background.

Credits
-------
- Mark James for the famfamfam silk icon set.		http://www.famfamfam.com/lab/icons/silk/
- People who have submitted their unrecognized SSD to the SSD-Z database.
- Everyone who have posted feedback on the TechPowerUp forum.