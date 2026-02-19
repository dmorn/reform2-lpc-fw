### 2025-07-01

 - no changes

### 2025-06-09

 - motherboard 3.0 support
 - updated build.sh and download-fw.sh convenience scripts
 - wake command: pulse wake GPIO and output to UART
 - simplify SPI commands handling, add uart passthrough command for Desktop Reform
 - disable LPC deep sleep to avoid long wakeup times on the keyboard

### 2024-10-15

 - add charger soft-start for motherboard 2.5; alleviates charger brick shutdown issue in most situations

### 2024-07-26

 - new LPC commands: f, 1f, 2f, 3f, and U to report version strings and uptime
 - write out descriptive error if `REFORM_MOTHERBOARD_REV` is missing (during build)

### 2023-11-24

 - disable brownout reset during sleep to keep battery status

### 2023-07-03

 - first tagged version
