DM2 Portable Launcher
=====================
Copyright 2004-2010 John T. Haller
Copyright 2008-2010 Vic Saville

Website: http://portableapps.com/apps/utilities/dm2_portable

This software is OSI Certified Open Source Software.
OSI Certified is a certification mark of the Open Source Initiative.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.

ABOUT DM2 PORTABLE
==================
The DM2 Portable Launcher allows you to run DM2 from a removable drive whose 
letter changes as you move it to another computer. The application can be 
entirely self-contained on the drive and then used on any Windows computer.

LICENSE
=======
This code is released under the GPL. The source is included with this package as 
DM2Portable.nsi.

INSTALLATION / DIRECTORY STRUCTURE
==================================
By default, the program expects the following directory structure:

-\ <--- Directory with DM2Portable.exe
	+\App\
		+\DM2\
	+\Data\
		+\settings\

It can be used in other directory configurations by including the 
DM2Portable.ini file in the same directory as DM2Portable.exe and configuring it 
as detailed in the INI file section below.

DM2PORTABLE.INI CONFIGURATION
=============================
The DM2 Portable Launcher will look for an INI file called DM2Portable.ini (read 
the previous section for details on placement). If you are happy with the 
default options, it is not necessary, though. The INI file is formatted as 
follows:

[DM2Portable]
DM2Directory=App\DM2
SettingsDirectory=Data\settings
DM2Executable=DM2.exe
AdditionalParameters=
DisableSplashScreen=false

The DM2Directory and SettingsDirectory entries should be set to the *relative* 
path to the appropriate directories from the current directory. All must be a 
subdirectory (or multiple subdirectories) of the directory containing 
DM2Portable.exe. The default entries for these are described in the installation 
section above.

The DM2Executable entry allows you to set the DM2 Portable Launcher to use an 
alternate EXE call to launch DM2. This is helpful if you are using a machine 
that is set to deny DM2.exe from running. You'll need to rename the DM2.exe file 
and then enter the name you gave it on the DM2Executable= line of the INI.

The AdditionalParameters entry allows you to pass additional commandline 
parameter entries to DM2.exe. Whatever you enter here will be appended to the 
call to DM2.exe.

The DisableSplashScreen entry allows you to run the DM2 Portable Launcher 
without the splash screen showing up. The default is false.