## basic custom files for Rime
* simp(明月- 简体) only

Path should be `~/Library/Rime/` in MacOS.
In the options, `Sync user data` then `Deploy`.

Log is under `$TMPDIR/` with name like `rime.squirrel.INFO/ERROR/WARNING`.

[install in different devices/systems](https://blog.csdn.net/weixin_34238642/article/details/94523592)

## sync
* to sync between devices, just need to cp these files to `~/Library/Rime`. Tweak or comment-out the `sync_dir` field in `installation.yaml`.
  * if `sync_dir` is not specified, it will sync data to the `~/Library/Rime/sync/`,  otherwise the data wil go to the `sync_dir` directory
  * when there are multiple folders under `sync_dir`, it will auto merge `xxx.userdb.txt` which contains the user custom dictionary.
