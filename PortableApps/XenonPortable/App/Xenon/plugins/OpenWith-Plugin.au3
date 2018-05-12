#NoTrayIcon
Dim $files = StringSplit(EnvGet("XENON_FILES_SEL"), "|");
If $files[0] = 1 And $files[1] == "" Then Exit;

Dim $fileName = FileOpenDialog("Open With", StringLeft(@ScriptDir, 2), "Executable Files (*.exe;*.bat)", 1);
If @error Then Exit;

Dim $i;
For $i = 1 To $files[0]
	ShellExecute($fileName, """" & StringReplace(EnvGet("XENON_CURRENT_DIR") & $files[$i], """", """""") & """");
Next