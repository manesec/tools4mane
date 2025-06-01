import zipfile

with zipfile.ZipFile("shell.zip", 'r') as zin:
    with zipfile.ZipFile("shell_new.zip", 'w' ) as zout:
        for item in zin.infolist():
            content = zin.read(item.filename)
            item.filename = item.filename + '\x00.pdf'
            zout.writestr( item, content)
            print(item.filename)
