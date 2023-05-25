# Automated Speed Test
This powershell script leverages the Speedtest.net command line program to automate speed tests for your PC each time you turn it on. 

Why would you want this? Because you're bored, and you want to know what your speeds were, and what your public/private IP was, for a given day. 

1. Download/install the command line tool from https://www.speedtest.net/apps/cli
2. Move your extracted speedtest folder with it's execuatble to a desired location. You will reference its path for the `$SpeedtestExePath` variable.
3. Tracking connection type is useful for understanding why your connection speed might differ (if like me, you alternate between Wi-Fi and Ethernet). If you don't know your adapter's ProductName, just debug this script and check the `$adapter` variable when it enters the foreach loop. 
4. Choose a path for your `$CsvFilePath` to save your speed test file.

## Optional
5. If you want to automate this task to run 15min after start up do the following:
    1. Open Task Scheduler by searching for it in the Start menu.
    2. Click on "Create Basic Task" or "Create Task" in the Actions pane on the right.
    3. Provide a name and description for the task, then click Next.
    4. Choose "When the computer starts" as the trigger, then click Next.
    5. Select "Start a program" as the action, then click Next.
    6. In the "Program/script" field, enter the path to the batch script you created.
    7. Click Next, review the task settings, and click Finish.