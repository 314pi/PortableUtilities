#cs

    Xenon File Manager - Open source, portable file manager
    Copyright (C) 2007-2008 www.mi3soft.info
	
	Xenon File Manager is free software: you can redistribute it and/or modify
	it under the terms of the GNU Lesser General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU Lesser General Public License for more details.

	You should have received a copy of the GNU Lesser General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
	
	One Exeception:
		Small snippets of code may be used from Xenon withouth subjecting
		your code to the GNU Lesser General Public License if
			a) The code borrowed does not include more than four (4) functions.
			and
			b) The application that this code will be used in is not a file browser.
	
#ce

Const $LANG_INI_FULL = $LANG_DIR & "\" & $LANG_INI;


Const $LANG_FILEMANAGER = IniRead($LANG_INI_FULL, "TRANSLATION", "FILEMANAGER", "File Manager");

Const $LANG_FILE = IniRead($LANG_INI_FULL, "TRANSLATION", "FILE", "&File");
Const $LANG_NEWTAB = IniRead($LANG_INI_FULL, "TRANSLATION", "NEWTAB", "New &Tab");
Const $LANG_CLOSETAB = IniRead($LANG_INI_FULL, "TRANSLATION", "CLOSETAB", "&Close Tab");
Const $LANG_NEWFOLDER = IniRead($LANG_INI_FULL, "TRANSLATION", "NEWFOLDER", "New &Folder");
Const $LANG_NEW = IniRead($LANG_INI_FULL, "TRANSLATION", "NEW", "&New");
Const $LANG_ADDTEMPLATE = IniRead($LANG_INI_FULL, "TRANSLATION", "ADDTEMPLATE", "Add &Template");
Const $LANG_SEARCH = IniRead($LANG_INI_FULL, "TRANSLATION", "SEARCH", "&Search");
Const $LANG_RENAME = IniRead($LANG_INI_FULL, "TRANSLATION", "RENAME", "&Rename");
Const $LANG_DELETE = IniRead($LANG_INI_FULL, "TRANSLATION", "DELETE", "&Delete");
Const $LANG_EXIT = IniRead($LANG_INI_FULL, "TRANSLATION", "EXIT", "&Exit");

Const $LANG_EDIT = IniRead($LANG_INI_FULL, "TRANSLATION", "EDIT", "&Edit");
Const $LANG_COPY = IniRead($LANG_INI_FULL, "TRANSLATION", "COPY", "&Copy");
Const $LANG_CUT = IniRead($LANG_INI_FULL, "TRANSLATION", "CUT", "C&ut");
Const $LANG_PASTE = IniRead($LANG_INI_FULL, "TRANSLATION", "PASTE", "&Paste");
Const $LANG_SELECTALL = IniRead($LANG_INI_FULL, "TRANSLATION", "SELECTALL", "Select &All");
Const $LANG_SELECTNONE = IniRead($LANG_INI_FULL, "TRANSLATION", "SELECTNONE", "Select &None");


Const $LANG_VIEW = IniRead($LANG_INI_FULL, "TRANSLATION", "VIEW", "&View");
Const $LANG_TREEVIEW = IniRead($LANG_INI_FULL, "TRANSLATION", "TREEVIEW", "Show &Folders");
Const $LANG_STYLE = IniRead($LANG_INI_FULL, "TRANSLATION", "STYLE", "&Style");
Const $LANG_REFRESH = IniRead($LANG_INI_FULL, "TRANSLATION", "REFRESH", "&Refresh");
Const $LANG_DETAILS = IniRead($LANG_INI_FULL, "TRANSLATION", "DETAILS", "&Details");
Const $LANG_ICONS = IniRead($LANG_INI_FULL, "TRANSLATION", "ICONS", "&Icons");
Const $LANG_LIST = IniRead($LANG_INI_FULL, "TRANSLATION", "LIST", "&List");
Const $LANG_TILE = IniRead($LANG_INI_FULL, "TRANSLATION", "TILE", "&Tile");

Const $LANG_SETTINGS = IniRead($LANG_INI_FULL, "TRANSLATION", "SETTINGS", "&Settings");
Const $LANG_SHOWHIDDENFILES = IniRead($LANG_INI_FULL, "TRANSLATION", "SHOWHIDDENFILES", "Show &Hidden Files");
Const $LANG_GETFOLDERSIZES = IniRead($LANG_INI_FULL, "TRANSLATION", "GETFOLDERSIZES", "Get Folder &Sizes");
Const $LANG_SHOWDDMENUITEM = IniRead($LANG_INI_FULL, "TRANSLATION", "SHOWDDMENUITEM", "S&how .. Item");
Const $LANG_LANGUAGE = IniRead($LANG_INI_FULL, "TRANSLATION", "LANGUAGE", "&Language");
Const $LANG_FILEASSOCATIONEDITOR = IniRead($LANG_INI_FULL, "TRANSLATION", "FILEASSOCATIONEDITOR", "File &Association Editor");
Const $LANG_PROMPTONDELETE = IniRead($LANG_INI_FULL, "TRANSLATION", "PROMPTONDELETE", "&Prompt on Delete")

Const $LANG_BOOKMARKS = IniRead($LANG_INI_FULL, "TRANSLATION", "BOOKMARKS", "&Bookmarks");

Const $LANG_HELP = IniRead($LANG_INI_FULL, "TRANSLATION", "HELP", "&Help");
Const $LANG_ABOUT = IniRead($LANG_INI_FULL, "TRANSLATION", "ABOUT", "&About");

Const $LANG_FILENAME = IniRead($LANG_INI_FULL, "TRANSLATION", "FILENAME", "Filename");
Const $LANG_FILESIZE = IniRead($LANG_INI_FULL, "TRANSLATION", "FILESIZE", "File Size");
Const $LANG_DATEMODIFIED = IniRead($LANG_INI_FULL, "TRANSLATION", "DATEMODIFIED", "Date Modified")

Const $LANG_OPEN = IniRead($LANG_INI_FULL, "TRANSLATION", "OPEN", "&Open");
Const $LANG_START = IniRead($LANG_INI_FULL, "TRANSLATION", "START", "Open (&Alternate)");
Const $LANG_PROPERTIES = IniRead($LANG_INI_FULL, "TRANSLATION", "PROPERTIES", "Prop&erties");

Const $LANG_COMPUTER = IniRead($LANG_INI_FULL, "TRANSLATION", "COMPUTER", "Computer");

Const $LANG_ERROROPENINGFILE = IniRead($LANG_INI_FULL, "TRANSLATION", "ERROROPENINGFILE", "Error Opening File");
Const $LANG_THEFILECOULDNOTBEOPENED = IniRead($LANG_INI_FULL, "TRANSLATION", "THEFILECOULDNOTBEOPENED", "The file could not be opened.");

Const $LANG_NEWFOLDER_DIRNAME = IniRead($LANG_INI_FULL, "TRANSLATION", "NEWFOLDER_DIRNAME", "New Folder");

Const $LANG_RENAMEFILEFOLDER = IniRead($LANG_INI_FULL, "TRANSLATION", "RENAMEFILEFOLDER", "Rename File/Folder");
Const $LANG_ENTERTHENEWFILENAME = IniRead($LANG_INI_FULL, "TRANSLATION", "ENTERTHENEWFILENAME", "Enter the new filename:");

Const $LANG_ERRORRENAMING = IniRead($LANG_INI_FULL, "TRANSLATION", "ERRORRENAMING", "Error Renaming");
Const $LANG_THEFILEFOLDERCOULDNOTBERENAMED = IniRead($LANG_INI_FULL, "TRANSLATION", "THEFILEFOLDERCOULDNOTBERENAMED", "The file/folder could not be renamed.");

Const $LANG_ERRORDELETING = IniRead($LANG_INI_FULL, "TRANSLATION", "ERRORDELETING", "Error Deleting");
Const $LANG_THEFILEFOLDERCOULDNOTBEDELETED = IniRead($LANG_INI_FULL, "TRANSLATION", "THEFILEFOLDERCOULDNOTBEDELETED", "The file/folder could not be deleted.");

Const $LANG_REPLACEFILE = IniRead($LANG_INI_FULL, "TRANSLATION", "REPLACEFILE", "Replace File");
Const $LANG_WOULDYOULIKETOREPLACETHEFILE = IniRead($LANG_INI_FULL, "TRANSLATION", "WOULDYOULIKETOREPLACETHEFILE", "Would you like to replace the file %s?");

Const $LANG_ALLFILES = IniRead($LANG_INI_FULL, "TRANSLATION", "ALLFILES", "All Files");
Const $LANG_OVERWRITEFILE = IniRead($LANG_INI_FULL, "TRANSLATION", "OVERWRITEFILE", "Would you like to overwrite the file %s?");

Const $LANG_TIPGOTOPREV = IniRead($LANG_INI_FULL, "TRANSLATION", "TIPGOTOPREV", "Go to the Previous directory.");
Const $LANG_TIPGOTONEXT = IniRead($LANG_INI_FULL, "TRANSLATION", "TIPGOTONEXT", "Go to the Next directory.");
Const $LANG_TIPGOUP = IniRead($LANG_INI_FULL, "TRANSLATION", "TIPGOUP", "Go to the Parent directory.");
Const $LANG_TIPGOTOCOMPUTER = IniRead($LANG_INI_FULL, "TRANSLATION", "TIPGOTOCOMPUTER", "Go to the Computer root.");
Const $LANG_TIPGOTOHOMEDRIVE = IniRead($LANG_INI_FULL, "TRANSLATION", "TIPGOTOHOMEDRIVE", "Go to the Home drive.");
Const $LANG_TIPREFRSH = IniRead($LANG_INI_FULL, "TRANSLATION", "TIPREFRESH", "Refresh the current directory.");
Const $LANG_TIPCOPY = IniRead($LANG_INI_FULL, "TRANSLATION", "TIPCOPY", "Copy selected files.");
Const $LANG_TIPCUT = IniRead($LANG_INI_FULL, "TRANSLATION", "TIPCUT", "Cut selected files.");
Const $LANG_TIPPASTE = IniRead($LANG_INI_FULL, "TRANSLATION", "TIPPASTE", "Paste files in the current directory.");
Const $LANG_TIPSEARCH = IniRead($LANG_INI_FULL, "TRANSLATION", "TIPSEARCH", "Search");

Const $LANG_CHOOSEICONSET = IniRead($LANG_INI_FULL, "TRANSLATION", "CHOOSEICONSET", "Choose &Icon Set");
Const $LANG_BOOKMARKEDITOR = IniRead($LANG_INI_FULL, "TRANSLATION", "BOOKMARKEDITOR", "&Bookmark Editor");
Const $LANG_BOOKMARKCAPTION = IniRead($LANG_INI_FULL, "TRANSLATION", "BOOKMARKCAPTION", "Set Caption");
Const $LANG_BOOKMARKCAPTIONMSG = IniRead($LANG_INI_FULL, "TRANSLATION", "BOOKMARKCAPTIONMSG", "Please enter the caption.");

Const $LANG_DUPLICATETAB = IniRead($LANG_INI_FULL, "TRANSLATION", "DUPLICATETAB", "&Duplicate Tab");

Const $LANG_OK = IniRead($LANG_INI_FULL, "TRANSLATION", "OK", "&OK");
Const $LANG_CANCEL = IniRead($LANG_INI_FULL, "TRANSLATION", "CANCEL", "&Cancel");
Const $LANG_ADD = IniRead($LANG_INI_FULL, "TRANSLATION", "ADD", "&Add");
Const $LANG_REMOVE = IniRead($LANG_INI_FULL, "TRANSLATION", "REMOVE", "&Remove");
Const $LANG_UP = IniRead($LANG_INI_FULL, "TRANSLATION", "UP", "&Up");
Const $LANG_DOWN = IniRead($LANG_INI_FULL, "TRANSLATION", "DOWN", "&Down");

Const $LANG_HOMEPAGE = IniRead($LANG_INI_FULL, "TRANSLATION", "HOMEPAGE", "Home&page");
Const $LANG_HOMEPAGE2 = IniRead($LANG_INI_FULL, "TRANSLATION", "HOMEPAGE2", "Homepage");

Const $LANG_ERRORDIRNOTEXIST = IniRead($LANG_INI_FULL, "TRANSLATION", "ERRORDIRNOTEXIST", "The directory specified does not exist.");
Const $LANG_ERRORDRIVENOTREADY = IniRead($LANG_INI_FULL, "TRANSLATION", "ERRORDRIVENOTREADY", "The drive is not ready.");
