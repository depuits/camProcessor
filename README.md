# CamProcessor (WIP)
Bash scripts for maintaining and processing camera image file output. 

## Setup
The cameras should be set to save in the a tmp folder under a camera folder (`/cameras/cam01/tmp/`). These are then timestamped and move to a folder of that date. At the end of the day all images are processed into a single movie and deleted.

### Example:
```
+-- **cam01**
|   +-- **tmp** (folder with unprocessed files since last preproccess)
|   +-- **24012018** (folder with unprocessed files of today)
|   +-- **24012017** (folder with unprocessed files of yesterday)
|   +-- **24012016.mkv** (processed output file)
|   +-- **24012015.mkv** (processed output file)
|   +-- **24012014.mkv** (processed output file)
|   +-- **...**
+-- **cam02**
|   +-- **tmp**
|   +-- **24012018**
|   +-- **24012017**
|   +-- **24012016.mkv**
|   +-- **24012015.mkv**
|   +-- **24012014.mkv**
|   +-- **...**
+-- **cam03**
|   +-- **tmp**
|   +-- **24012018**
|   +-- **24012017**
|   +-- **24012016.mkv**
|   +-- **24012015.mkv**
|   +-- **24012014.mkv**
|   +-- **...**
+-- **...**
+
+
```

### Scripts description

#### 01_preprocess
Timestamp the day and time and then move the image file to its destination.

#### 02_process
Combine all images into the final output.

#### 03_cleanup
When the final file is created remove the source image files and remove final file after the defined ammount of time to free space.

#### dskspc
Check the remaining space on the disk.

#### config
Shared script variables.

### Run automaticly

Add the scipts to crontab with `contab -e`.
```
 */5 * * * * 01_preprocess.sh
   0 1 * * * 02_process.sh
   0 2 * * * 03_cleanup.sh
  30 2 * * * dskspc.sh
```
