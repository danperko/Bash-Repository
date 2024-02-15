Here's the translation of the provided script explanation:

1. **Set the source directory and target directory**:
   - `sourceDir=$(pwd)`: Assigns the current directory (where the script is executed) to the variable `sourceDir`.
   - `targetDir="../fotoExtract"`: Sets the relative target directory as "../fotoExtract" in relation to the current directory.

2. **Initialize counters**:
   - `totalFiles=0`, `copiedFiles=0`, `noDateFiles=0`: Initializes counters for the total number of files, copied files, and files without a date, respectively.

3. **Create the target directory if it doesn't exist**:
   - `if [ ! -d "$targetDir" ]; then ... fi`: Checks if the target directory does not exist (`! -d "$targetDir"`) and, if true, creates the directory using the `mkdir` command.

4. **Enable case-insensitive globbing**:
   - `shopt -s nocaseglob`: Activates the `nocaseglob` option, allowing file searches to be case-insensitive.
   - `shopt -s globstar`: Activates the `globstar` option, allowing the use of `**` to match all files and subdirectories.

5. **Declare an associative array**:
   - `declare -A copiedFileNames`: Creates an associative array named `copiedFileNames` to track copied file names.

6. **Iterate over specified file types**:
   - A `for` loop iterates through the specified file extensions: `jpeg`, `jpg`, `png`, `gif`, `bmp`, `avi`, `mp4`, `mov`.

7. **Iterate over files in the current directory and subdirectories**:
   - Another `for` loop iterates through all files with the current extension in the current directory and its subdirectories using `**/*."$ext"`.

8. **Count files**:
   - Checks if the file is a regular file (`-f "$file"`) and, if true, increments the `totalFiles` counter.

9. **Display the total number of files found**.

10. **Iterate over specified file types again**:
    - A similar loop to step 6 is performed to iterate over the same file extensions.

11. **Process individual files**:
    - Checks if the file is a regular file.
    - Gets the file name (`filename`) and its part without an extension (`filename_noext`).

12. **Search for a year in the file name**:
    - A `for` loop iterates through the first four characters of the file name (`filename_noext`) in search of a four-digit number within the desired range. If found, it is assigned to the `year` variable.

13. **Search for a month in the file name**:
    - If a valid year is found, another `for` loop iterates through the next two characters of the file name in search of a two-digit number representing a valid month (01-12). If found, it is assigned to the `month` variable.

14. **Create target directory and copy files**:
    - If a valid year and month are found, a subdirectory path based on the year and month is created in `targetSubDir`. If it doesn't exist, the directory is created.
    - Checks if the file has already been copied to avoid duplicates using the associative array `copiedFileNames`.
    - If a valid year and month are not found, the file is copied to the `sinFecha` subdirectory.

15. **Finish the process**:
    - Displays a "Process completed" message.
