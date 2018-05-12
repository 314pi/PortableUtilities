================================================================================
WHAT IS FreeCommander
================================================================================
FreeCommander is an easy-to-use alternative to the standard Windows file manager. 
You can configure almost everything. Supported Windows versions: Windows XP and above.
FreeCommander XE is in two versions 32 and 64 bit. 
Please check the info about using FreeCommander XE 32 bit on 64 bit Windows http://freecommander.com/en/version-summary/    



================================================================================
AFTER YOU HAVE INSTALLED FreeCommander XE
================================================================================

If you have worked with the FreeCommander 2009.02b:
- the settings of the FreeCommander 2009.02b are not compatible with the settings of the FreeCommander XE
- do not copy the old settings to the new settings folder

If you have worked with the FreeCommander XE 32 bit version and now you want use 64 bit version
- the settings are compatible; you can use the settings from the 32 bit version in the 64 bit version
- for moving the settings you can use Tools->Backup all settings, Tools->Restore all settings


The available help files you can download from the site http://freecommander.com/en/languages/  

Trouble with the help file
==========================
When viewing your CHM documentation, Microsoft's HTML Help Viewer is showing an error page saying either that:
 - The action has been canceled 
 - The page cannot be displayed
 
Solutions
 - Launch help file from local drive and not from a network path or via a mapped networked drive.  
 - Make sure your help file isn't in a path with symbols such as "#" (sharp).  
 - In some cases, you can have access to an "unblock" button in the properties page of the help file. Right click on the file then go to its properties and click the "unblock" button. This button is not available in all systems though. 
 - Try the HHReg utility http://www.ec-software.com/products_hhreg.html or read this technical note from the Microsoft Knowledge Base http://support.microsoft.com/kb/896054/.

================================================================================
FEEDBACK & SUGGESTIONS
================================================================================

Direct your feedback, suggestions and bug reports to the FreeCommander forum http://www.forum.freecommander.com
or directly to me marek@freecommander.com but please do not expect that you get an answer immediately :). 


I hope you will enjoy FreeCommander 

MAREK JASINSKI


================================================================================
Important changes and bug fixes in the release 770 compared to 740
================================================================================

- Bug fix: Some russian chars does not work in quick search http://www.forum.freecommander.com/viewtopic.php?f=7&t=7750
- Bug fix: '\&' operator in quick filter does not work 
- Bug fix: Using ENTER while editing the options in "Settings -> Programs" closes the entire dialog http://www.forum.freecommander.com/viewtopic.php?f=19&t=7740
- Bug fix: View->Swap function may cause exception
- Bug fix: Favorite tool icon is not visible if favorite tool is integrated in splitter toolbar
- Bug fix: "Windows preview" icon is not created in the default viewer toolbar
- Bug fix: Using ENTER while editing the options in "Column Profiles" or "Status Bar" closes the entire dialog  http://www.forum.freecommander.com/viewtopic.php?p=25041#p25041
- Bug fix: Selection problem if extension not showed in the Name column http://www.forum.freecommander.com/viewtopic.php?f=19&t=7231
- Bug fix: Wrong file highlighting when NC-style selection is enabled http://www.forum.freecommander.com/viewtopic.php?f=19&t=7810
- Bug fix: Selection duplicated in other tabs http://www.forum.freecommander.com/viewtopic.php?f=19&t=7809
- Bug fix: Favorites command "Open all in tabs" may fail http://www.forum.freecommander.com/viewtopic.php?f=19&t=7797
- Bug fix: Plain view - Opening multiple selected files does not always work http://www.forum.freecommander.com/viewtopic.php?f=7&t=5887 
- Bug fix: Program may crash if base folder tree is set to drive and a DVD drive without disk will be selected
- Bug fix: Column profiles "File container <cart>" issue http://www.forum.freecommander.com/viewtopic.php?f=7&t=7848
- Bug fix: Open default program broken http://www.forum.freecommander.com/viewtopic.php?f=7&t=7859
- Bug fix: Copy files from nested archive broken 
- Bug fix: Loading the toolbar icons at the program start can lead to the endless loop.
- Bug fix: Searching for Zero Byte Files does not work http://www.forum.freecommander.com/viewtopic.php?f=18&t=7869
- Bug fix: After deleting the last element in the list, the cursor jumps to the first element http://www.forum.freecommander.com/viewtopic.php?f=7&t=7851
- Bug fix: Current folder is not used if perform default action http://www.forum.freecommander.com/viewtopic.php?f=7&t=7882
- Bug fix: Prefered sort direction (column definition in the detail view) is not used if sorting started with toolbar button or shortcut http://www.forum.freecommander.com/viewtopic.php?f=7&t=7899
- Bug fix: Quick viewer - wrong panel focused http://www.forum.freecommander.com/viewtopic.php?f=7&t=7894
- Bug fix: Quick viewer zoom state lost http://www.forum.freecommander.com/viewtopic.php?f=7&t=7893
- Bug fix: Quick viewer does not show file if already open on program start 
- Bug fix: Font color for quick starter is not used
- Bug fix: Maximized start is not possible if the option "Handle closing as minimization" is active
- Bug fix: File container favorite does not open at container contents http://www.forum.freecommander.com/viewtopic.php?f=19&t=7979  
- Bug fix: Locked path of MTP device is lost when device is not connected http://www.forum.freecommander.com/viewtopic.php?f=19&t=7968
- Bug fix: Second favorites sets' items cannot be opened from pulldown http://www.forum.freecommander.com/viewtopic.php?f=7&t=7986
- Bug fix: It is possible to define duplicate keyboard shortcut http://www.forum.freecommander.com/viewtopic.php?f=7&t=7966
- Bug fix: Tree option "Show Windows archive files" broken 
- Bug fix: Search history is not always saved http://www.forum.freecommander.com/viewtopic.php?f=19&t=7995
- Bug fix: Exception in Folder Synchronize dialog if 'Empty folders' option is active
- Bug fix: FTP is not case sensitive
- Bug fix: "Use Vista+ delete method" option broken on Windows 10 http://www.forum.freecommander.com/viewtopic.php?f=7&t=8101
- Bug fix: Using of the large icons in the favorite toolbar broken http://www.forum.freecommander.com/viewtopic.php?f=6&t=8116
- Bug fix: "Go To Folder" history always empty http://www.forum.freecommander.com/viewtopic.php?f=7&t=8114
- Bug fix: The width of the tree pane is not correctly restored on start
- Bug fix: Folder size can be not correctly if contains files > 4 GB
- Bug fix: Multirename not working when making consecutive rename operations http://www.forum.freecommander.com/viewtopic.php?f=7&t=8019
- Bug fix: Synchronize folder dialog - filter fields does not accept space character
- Bug fix: Renaming operation may fail for some languages http://www.forum.freecommander.com/viewtopic.php?f=7&t=8204
- Bug fix: Exception on program start if last used view was "Thumbnails"
- Bug fix: Favorite tool shortcut for changing location fail in some cases http://forum.freecommander.com/viewtopic.php?f=19&t=8318
- Bug fix: Switching from layout with one pane to layout with two panes fail http://forum.freecommander.com/viewtopic.php?f=7&t=8348
- Bug fix: Copy file from the disk folder to the smartphone card with Shift+F5 fail - copied file ends up in desktop folder. 
- Bug fix: Possible exception in the search dialog when quick view is switched off.
- Bug fix: Quick filter option (only in freecommander.ini) "QuickFilterFolderNamesToo" broken if set to "0"
- Bug fix: Possible exception in the search dialog when quick view is switched off.
- Bug fix: "Folder - > Synchronize..." same files can be marked as unresolved
- Bug fix: Filter in the plain view can fail 

- Changed: Multirename - negative value for counter "Start at" allowed again   
- Changed: Select item options: "By click on extension..." and "By click on item icon" now separated for Windows-mode and NC-mode
- Changed: Color by attributes - now any set of attributes is possible
- Changed: Copy/Paste operation is now performed asynchronously (set CopyPasteInThread=0 for old behavior)
- Changed: Font color is not changed now if "Only border" for focused item is active in NC-Mode http://www.forum.freecommander.com/viewtopic.php?f=6&t=7853
- Changed: "Define filter" dialog - option for "Older than" added 
- Changed: Temporary filter in "Set filter" dialog extended by condition for date modified 
- Changed: Due to a bug in Windows 10 1607 the operations on portable devices was broken. 
	 The internal treatment of these devices has been revised. Now the basic functions works with the portable devices (from Windows 7). 
- Changed: Better performace for copy operation in network (FreeCommander method)
- Changed: Menu "Tools -> View style" moved to "View -> View style" 

- Implemented: Report missing files for "Verify MD5-checksums"  http://www.forum.freecommander.com/viewtopic.php?f=19&t=7755   
- Implemented: New system tree option for excluding some nodes from the tree 
- Implemented: Status bar - File Container filter http://www.forum.freecommander.com/viewtopic.php?f=20&t=7847
- Implemented: Split file command
- Implemented: Combine files command
- Implemented: Action toolbar for the left and right border of the main window
- Implemented: New thumbnail option "No thumbnails for the files:"
- Implemented: Option "Color by attributes" extended to "Color by attributes and timestamp"
- Implemented: New property "Font color" added for favorite folder 
- Implemented: In viewer: Multiframe images (tiff, ico, avi), EXIF info can be showed, Saving images in many formats (popup menu), Print preview for images (popup menu)
- Implemented: Search dialog - time interval filter accept multiplier now; e.g. |day*4, |hour*2, |month*3, -|week*5, -|year*2
- Implemented: The width of the input dialog (e.g. for new folder F7) is changeable now
- Implemented: VLC media player (videolan.org) integrated in viewer and quick viewer 
- Implemented: Checksum dialog - new sum methods added (SHA1, SHA2)
- Implemented: Completion of renaming operation with TAB key opens the next item ready for renaming 
- Implemented: Color schema can be saved and restored View->Color schemas
- Implemented: Color schema can be saved with layout too
- Implemented: Loading drive icons in background - program start may be faster
- Implemented: Custom style dialog - definition for menu added
- Implemented: "Settings -> Folder Tabs" more colors for tabs added
- Implemented: Font color for quick filter
- Implemented: "Only border" option added for "Focused item inactive list"
- Implemented: Restore last used color schema
- Implemented: Color schemas saved in settings backup 
- Implemented: "Exposure time" added to EXIF info (multirename and status row)
- Implemented: New options for the tree added: "Full rows select", "Theme off"
- Implemented: Option to define in the [Form] section of the freecommander.ini: LayoutsIgnoreMainWindowSize; 1 - in layout saved window size is ignored; 0 - in layout saved window size is used 
- Implemented: "Check for update" option defined under Tools->Settings->General





================================================================================
Important changes and bug fixes in the release 740 compared to 715
================================================================================
    - Bug fix: Search profile doesn't retain Timestamp "Not older option" forum.freecommander.com/viewtopic.php?f=7&t=7108
    - Bug fix: Main window is always hidden if starting FreeCommander with the options "Minimize to system tray" and "Start minimized"
    - Bug fix: '[' and ']' does not works in quick filter
    - Bug fix: Invert selection - the first element of the list is not selected if no parent folder '..' is visible in the file list
    - Bug fix: The column titles may be not translated if the option "Start minimized" is active
    - Bug fix: Locked tab "D:\My Folder" with "Navigation to subfolders" - navigation is possible to "D:\My Folder is locked"
    - Bug fix: "Save container to file..." broken forum.freecommander.com/viewtopic.php?f=7&t=7160
    - Bug fix: On some PCs all timestamps shows as 1899.12.30 00:00 forum.freecommander.com/viewtopic.php?f=7&t=7197#p23091
    - Bug fix: Active layout is not checked in menu if more as 10 layouts defined
    - Bug fix: Settings->General "Start minimized" option broken
    - Bug fix: Selection problem fixed forum.freecommander.com/viewtopic.php?f=7&t=7073
    - Bug fix: Checked state is initial not visible on splitter button forum.freecommander.com/viewtopic.php?f=19&t=7249
    - Bug fix: FTP connections are not listed if connection name has special chacter (e.g. German ö,ä,ü,...)
    - Bug fix: When changing folders in network shares, when you go back one level up, the cursor jumps to the top forum.freecommander.com/viewtopic.php?f=19&t=7270
    - Bug fix: Drop folder to Deskop button - the content of the folder is dropped but not the folder self
    - Bug fix: Customized button caption (toolbar buttons) is ignored for layouts and favorites forum.freecommander.com/viewtopic.php?f=6&t=7282
    - Bug fix: Splitter position is not restored after hiding/opening inactive panel (F10) forum.freecommander.com/viewtopic.php?f=19&t=7292
    - Bug fix: The state of "go to the next history item" toolbar botton is not changed forum.freecommander.com/viewtopic.php?f=19&t=7291
    - Bug fix: Item list Icons do not follow Item list Names upon change of sort type forum.freecommander.com/viewtopic.php?f=19&t=7317
    - Bug fix: Actions "Set active panel to X%" broken
    - Bug fix: Plain views icons do not toggle when in address bar forum.freecommander.com/viewtopic.php?f=7&t=7345
    - Bug fix: Selection in NC-Mode broken forum.freecommander.com/viewtopic.php?f=6&t=7390
    - Bug fix: Folder size consolidation toggle ("KB") unpredictable state forum.freecommander.com/viewtopic.php?f=19&t=7080
    - Bug fix: Del key issue with rename in "Favorites - edit..." forum.freecommander.com/viewtopic.php?f=7&t=7408
    - Bug fix: Search result: Open location shortcut changed to original value - Space (Shift+Space supported too) forum.freecommander.com/viewtopic.php?f=6&t=7400
    - Bug fix: Linked browsing broken on the way "up" forum.freecommander.com/viewtopic.php?f=7&t=7410
    - Bug fix: The main window opens on the primary monitor although closed on the second monitor - only if maximized
    - Bug fix: Folder synchronize problems forum.freecommander.com/viewtopic.php?f=7&t=7445
    - Bug fix: Unwanted selection in NC-Mode forum.freecommander.com/viewtopic.php?f=7&t=7362
    - Bug fix: "Auto add wildcards" option in quick filter is broken forum.freecommander.com/viewtopic.php?f=7&t=7360
    - Bug fix: New folder should allow path with more than one directory forum.freecommander.com/viewtopic.php?f=20&t=6969
    - Bug fix: "Quick viewer size by file type" option broken for jpg files
    - Bug fix: Thumbnails may be false if using refresh function or if switching tabs with thumbnails view
    - Bug fix: Multirename dialog - not correctly displayed for bigger fonts (150%) if profiles defined
    - Bug fix: Compare folders is broken if UNC path is used
    - Bug fix: Toolbar position is not saved if using "Tools->Save settings"
    - Bug fix: Wrong tab order in "Define favorite toolbars" dialog forum.freecommander.com/viewtopic.php?f=7&t=7499
    - Bug fix: Delete button not working in Laouts edit dialog forum.freecommander.com/viewtopic.php?f=7&t=7500
    - Bug fix: Maximized/normal state of the main window not correctly restored in layouts forum.freecommander.com/viewtopic.php?f=7&t=7496
    - Bug fix: Popup menu is not showing by drop on address bar although the setting for showing popup menu is active forum.freecommander.com/viewtopic.php?f=19&t=7507
    - Bug fix: Show/hide main menu in the status bar context menu doesn't work always forum.freecommander.com/viewtopic.php?f=7&t=7518
    - Bug fix: Exception on closing of the layout dialog forum.freecommander.com/viewtopic.php?f=7&t=7497
    - Bug fix: Incorrect file name suggested in Pack files dialog forum.freecommander.com/viewtopic.php?f=7&t=7204
    - Bug fix: Favorites set dialog - rename does not work
    - Bug fix: FTP - set timestamp for the uploaded file does not work
    - Bug fix: File container - many problems solved forum.freecommander.com/viewtopic.php?f=6&t=7549
    - Bug fix: Tree position is not correct restored when "Show menu as toolbar" active is (only if main window is maximized)
    - Bug fix: Tree is not refreshed if context menu delete command is used
    - Bug fix: View option for favorite folder does not work always http://www.forum.freecommander.com/viewtopic.php?p=24465#p24465 
    - Bug fix: Toggle betwwen current and thumbnail view (Ctrl+I) does not work properly if folder was changed http://www.forum.freecommander.com/viewtopic.php?f=7&t=7609
    - Bug fix: Exception if you try to open folder in the file container but the folder does not exist http://www.forum.freecommander.com/viewtopic.php?p=24456#p24456
    - Bug fix: Quick viewer resize problem if "top" is used for "Align in panel"  http://www.forum.freecommander.com/viewtopic.php?f=7&t=7641
    - Bug fix: Exception on some PCs, e.g. on usb drive add/remove (introduced in 731)
    - Bug fix: Deleting the folder in the tree causes error messages http://www.forum.freecommander.com/viewtopic.php?p=24730#p24730 
    - Bug fix: File names may be not fully visible on high DPI screen http://www.forum.freecommander.com/viewtopic.php?f=7&t=7622
    - Bug fix: Command line option "-Layout=" does not work if one instance option is active
    - Bug fix: Color items by predefined filter does not work properly http://www.forum.freecommander.com/viewtopic.php?f=19&t=7727

    - Implemented: It is possible now to add: Layouts, Favorite tools, Favorites and Drives to action toolbars. Only items with assigned shortcut works in action toolbar.
    - Implemented: New method Copy/Move operation performed by FC added (Vista+ only)
    - Implemeneted: New tree option "Keep expanded nodes if tree per Tab"
    - Implemented: Sorting by Windows columns improved ("Data type" added to the column definition )
    - Implemented: Elevation prompt (admin rights) will be showed for unpack operation if needed
    - Implemented: New Option in search dialog - Run in external process
    - Implemented: Middle button click on favorite item in toolbar opens favorite target folder in new tab forum.freecommander.com/viewtopic.php?f=20&t=7174
    - Implemented: Delete operation improved; option "Use Vista+ delete method" added
    - Implemented: Loading of network shares improved forum.freecommander.com/viewtopic.php?f=6&t=6288
    - Implemented: New command line option added -StartMinimized
    - Implemented: Address bar edit field - accept button added
    - Implemented: FTP - unicode support added forum.freecommander.com/viewtopic.php?f=7&t=7041
    - Implemented: New option in the search form - Use left/right for "Open location"
    - Implemented: Attributes/Timestamp dialog - new options for "Set timestamp as in target folder" added: "Created from Modified" and "Modified from Created"
    - Implemented: Favorite items edit dialog - shortcuts for rename, delete, up, down added
    - Implemented: Icons for favorite tools now loaded in background (important for not existend or slow network paths )
    - Implemented: Click on button with the folder in the favorite tools toolbar - added Ctrl+Click (open folder in new tab), Alt+Click (open folder in the opposite pane), Ctrl+Alt+Click (open folder in new tab in the opposite pane)
    - Implemented: Click on folder in the favorite folders tree - added Ctrl+Click (open folder in new tab), Alt+Click (open folder in the opposite pane), Ctrl+Alt+Click (open folder in new tab in the opposite pane)
    - Implemented: Click on folder in system folder popup menu - added Ctrl+Click (open folder in new tab) forum.freecommander.com/viewtopic.php?f=6&t=7283
    - Implemented: New options for "Select with mouse pointer" added - Action by click on free space in label, action by click on item icon (these options was till now available only in freecommander.ini )
    - Implemented: Left click in the free area of the address bar start the editing if the option "Show history popup menu on free area click" is not set
    - Implemented: Additional option for auto size of the 'Name' column - Fill remaining space
    - Implemented: Operations queue for operations ("Use FreeCommander" operations)
    - Implemented: New action added "Paste address from clipboard and reload" Shift+Alt+G
    - Implemented: Main menu item added Edit->Address bar
    - Implemented: Mouse "Snap to" implemented
    - Implemented: Searching in the office files (docx, xlsx, odt)
    - Implemented: Option to set in the freecommander.ini: CopyFullPath_AddLastDelimiter=0 - set the value to 1 if you want to add trailing backslash if copy folder paths to clipboard
    - Implemented: New action added "Toggle toolbars visibility"
    - Implemented: Favorite folder sets
    - Implemented: New option added "Always perform copy operation for left button drag&drop"
    - Implemented: Last position of the layout dialog will be saved
    - Implemented: Doubleclick on the line in the layout dialog perform "Apply" command
    - Implemented: 'Settings->Shell Menu' - options for adding "Open with Freecommander" item to shell context menu
    - Implemented: New option "Show basket icon" for splitter toolbar added 
    - Implemented: New command line option added (set active panel to left/top or right/bottom) "-Panel=L" or "-Panel=R"
    - Implemented: New thumbnail size added (512)
    

    - Changed: Last selected layout is marked as checked (till now - only if "Auto save current layot" was active)
    - Changed: Deley befor opening of the rename dialog removed forum.freecommander.com/viewtopic.php?f=6&t=7287
    - Changed: Multirename - mouse scrolling in the fields is allowed now only if the mouse cursor is in the filed forum.freecommander.com/viewtopic.php?f=19&t=7301
    - Changed: Settings dialog - OK, Cancel, Apply buttons moved to the right site of the dialog forum.freecommander.com/viewtopic.php?f=20&t=7421
    - Changed: Quick search support special characters forum.freecommander.com/viewtopic.php?f=7&t=7414
    - Changed: Splitter toolbar should be visible if hot spot buttons are used forum.freecommander.com/viewtopic.php?f=20&t=7516
    - Changed: Mouse wheel scroll for details view follows now Windows settings
    - Changed: Click on basket icon in splitter loads the Bin Tray in the active panel
    - Changed: Subfolder filter in search dialog simplified
    - Changed: Modifications for high resolution screens
    - Changed: Suppress message when global shortcut can not be registered (only if second or further program instance is started)   
    - Changed: Redirect Win+E to FreeCommander now permanent and not only per sesion

Full history you can find here http://www.forum.freecommander.com/viewtopic.php?f=6&t=775&start=165


            