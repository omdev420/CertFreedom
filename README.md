# How to disable SSL pinning device-wide on emulator

1. Create a new non-production emulator using Android Studio
    - Open Android Studio and Virtual device manager
        
        ![Untitled](screenshots/Untitled.png)
        
    - Create a new emulator
        
        ![Untitled](screenshots/Untitled%201.png)
        
    - Select any hardware profile which doesn’t have Play Store in it
        
        ![Untitled](screenshots/Untitled%202.png)
        
    - Select the system image you wanna install
        
        ![Untitled](screenshots/Untitled%203.png)
        
        > Chose system image with API ≤ 33. This method doesn’t support images with API ≥34.
        > 
    - Name the AVD and finish the process
        
        ![Untitled](screenshots/Untitled%204.png)
        
2. Run the emulator with writable system using **Terminal**
    - Run the command to list the all avds and copy the name of avd which you created in the last steps
        
        ```bash
        emulator -list-avds
        ```
        
        ![Untitled](screenshots/Untitled%205.png)
        
    - Run this command to start the emulator with writable system flag
        
        ```bash
        emulator -avd <YOUR_AVD_NAME_HERE> -writable-system
        ```
        
        ![Untitled](screenshots/Untitled%206.png)
        
    - The emulator will boot up
        
        ![https://i.imgur.com/sL27TDj.jpeg](https://i.imgur.com/sL27TDj.jpeg)
        
        > Don’t close the emulator or the terminal which is running it.
        > 
        
3. Generate Charles CA cert
    - Open Charles and go to **Help menu**
        
        ![Untitled](screenshots/Untitled%207.png)
        
    - Save the Charles ca cert in the repo with .PEM format
        
        ![Untitled](screenshots/Untitled%208.png)
        
        ![Untitled](screenshots/Untitled%209.png)
        
    - In the terminal, CD into the repo directory and run these commands
        
        ```bash
        chmod +x generateCertificate.sh
        ./generateCertificate.sh
        ```
        
        ![Untitled](screenshots/Untitled%2010.png)
        
        > The `cert.pem` file should be in the same directory as the script for it run successfully.
        > 
        
4. Run the setup script to patch the running writable system emulator
    - Run the following commands to initiate the setup script
        
        ```bash
        chmod +x setup.sh
        ./setup.sh
        ```
        
        ![Untitled](screenshots/Untitled%2011.png)
        
    - Check in trusted credentials, your CA cert would be installed in System
        
        ![Untitled](screenshots/Untitled%2012.png)
        
    
5. Configure the proxy in the emulator
    - Go to the Wifi settings and click on edit
        
        ![Untitled](screenshots/Untitled%2013.png)
        
    - Toggle the advanced options and set the proxy to `Manual`
        
        ![Untitled](screenshots/Untitled%2014.png)
        
    - Fill in your Charles proxy IP address and port here and save
        
        ![Untitled](screenshots/Untitled%2015.png)
        
    - Now you’ll start receiving requests in your Charles
        
        ![Untitled](screenshots/Untitled%2016.png)
        
    - Install the app and start testing!

This was a one time process, and you won’t need to do this again for the same emulator. You can start the emulator by using this command whenever you want to debug the API request for a release build

```bash
emulator -avd <YOUR_AVD_NAME_HERE> -writable-system
```
> Dont forget to start the emulator with writable system flag everytime you wanna use it else you would have to redo the process again.