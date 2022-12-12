### Restarts and Cleans the Printer Spooler Service
**Requirements:**
- Windows XP or newer
- Elevated privileges (Run as Administrator)

**What it does:**
1. Stops Printer Spooler Service (spooler)
2. Clears jobs inside the Pool from %SYSTEMROOT%\System32\Spool\Printers\
3. Starts Printer Spooler Service

**Result:**

Any job that was stuck should be gone, if printing is still not possible then the spooler service is not at fault, you might have to Power Cycle your printer instead.
