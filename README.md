# Step to reproduce the bug

Step 1: Run this `bash` command to create invalid UTF-8 folder: 
```bash
mkdir $'\xED\xBD\xB7\xED\xBC\xB2'
```
Step 2: Start yazi: `YAZI_LOG=debug yazi`.

Step 3: Hover over the invalid UTF-8 folder, then cut and move it to away from current cwd.
Step 4: Check the log file.



https://github.com/user-attachments/assets/cead63c6-a824-445d-893c-8eb6fde531cd

