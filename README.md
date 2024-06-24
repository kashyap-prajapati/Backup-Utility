# Backup-Utility

# Icbackup.sh

`Icbackup.sh` is a Bash script designed to run continuously in the background, creating complete and incremental backups of a specified directory. The script follows a structured sequence of backup operations with specific intervals and conditions.

## Features

- **Complete Backup**: Creates a full backup of the entire directory tree rooted at `/home/username` every 10 minutes.
- **Incremental Backup**: Creates incremental backups of newly created or modified files at 2-minute intervals after each complete backup.
- **Differential Backup**: Creates a differential backup of all files modified since the last complete backup every 10 minutes.
- **Logging**: Updates a log file (`backup.log`) with timestamps and the names of the created backup files.

## Backup Steps

1. **Complete Backup**: 
   - Creates a tarball (`cb****.tar`) of all files in `/home/username` and stores it in `~/home/backup/cbw24`.
   - Logs the creation time and tarball name in `backup.log`.
   - Runs every 10 minutes.

2. **Incremental Backup (STEP 2)**:
   - Creates a tarball (`ib****.tar`) of files modified after the complete backup and stores it in `~/home/backup/ib24`.
   - If no files are modified, logs the timestamp and a message indicating no changes.
   - Runs 2 minutes after the complete backup.

3. **Incremental Backup (STEP 3)**:
   - Similar to STEP 2, creates a tarball of files modified after STEP 2.
   - Runs 2 minutes after STEP 2.

4. **Differential Backup**:
   - Creates a tarball (`db****.tar`) of files modified after the complete backup and stores it in `~/home/backup/db24`.
   - If no files are modified, logs the timestamp and a message indicating no changes.
   - Runs 2 minutes after STEP 3.

5. **Incremental Backup (STEP 5)**:
   - Similar to STEP 3, creates a tarball of files modified after STEP 4.
   - Runs 2 minutes after STEP 4.

6. **Repeat**: The script returns to STEP 1 and repeats the process.

## Usage

1. **Clone the Repository**:

    ```sh
    git clone https://github.com/your-username/Icbackup.git
    cd Icbackup
    ```

2. **Make the Script Executable**:

    ```sh
    chmod +x Icbackup.sh
    ```

3. **Run the Script**:

    ```sh
    ./Icbackup.sh &
    ```

    The script will run continuously in the background.

## Log File Format

The `backup.log` file records the operations performed by the script with timestamps. Example log entries:

```
Wed 20 Mar 2024 06:16:08 PM EDT cbw24-1.tar was created
Wed 20 Mar 2024 06:18:08 PM EDT ibw24-1.tar was created
Wed 20 Mar 2024 06:20:08 PM EDT No changes - Incremental backup was not created
Wed 20 Mar 2024 06:22:08 PM EDT dbw24-1.tar was created
Wed 20 Mar 2024 06:24:08 PM EDT ibw24-2.tar was created
```

## Directory Structure

- `/home/username`: Directory to be backed up.
- `~/home/backup/cbw24`: Directory to store complete backups.
- `~/home/backup/ib24`: Directory to store incremental backups.
- `~/home/backup/db24`: Directory to store differential backups.
- `backup.log`: Log file to record backup operations.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements

This project is inspired by the need for automated backup solutions that run in the background and ensure data safety with minimal manual intervention.

