# Raspberry Pi 4 RTSP Camera Stream Setup
This project installs MediaMTX onto a raspberry pi 4 to run an RTSP server. The project uses a USB camera *(obsbot tiny se specifically)* and has not been tested with any other devices. MediaMTX is used to run an RTSP server on the LAN while FFmpeg is used to stream the camera feed from `/dev/video0` to the server. The purpose of this project is to automate the installation and startup of these tools so that they automatically start on boot.

## Installation

### 1. Prerequisties
This project requires the following tools.
Most of these should either be pre-installed with the os or will be installed through [setup.sh](setup.sh).
- Raspberry Pi 4 with a **64-bit** OS
- curl *(installed by setup.sh)*
- FFmpeg *(installed by setup.sh)*
- MediaMTX *(installed by setup.sh)*
- Git

The version of MediaMTX that will be installed is specific for 64-bit ARM (aarch64) systems

### 2. Setup
1. Clone or download this repo
2. run [setup.sh](setup.sh)
3. Follow prompts given during setup
- The first prompt will ask if you want to launch the RTSP server and FFmpeg stream on startup.
- The second will ask if you want to launch the RTSP server and FFmpeg stream. If you don't, you can manually start it using `~/Pi-RTSP/runRtsp.sh`. If you chose for it to start on boot, then you can simply reboot your system and it will run in the background.

```bash
git clone https://github.com/KieranSISherman/Pi-RTSP-Setup.git
chmod +x setup.sh
./setup.sh
```

## General Installation Info
### Setup.sh
- If curl or FFmpeg are not installed when setup.sh is run, it will try to install them for you.
- If you chose to start the RTSP Server and FFmpeg stream on startup, it will create the file `/etc/systemd/system/rtspStartup.service` which runs `~/Pi-RTSP/runRtsp.sh`.

### MediaMTX
- MediaMTX is put in the `~/Pi-RTSP` directory.
- MediaMTX will use the [mediamtx-rtsp.yml](mediamtx-rtsp.yml) config file when starting with [runRtsp.sh](runRtsp.sh). Running MediaMTX manually will run it with the default mediamtx.yml config.
- The [mediamtx-rtsp.yml](mediamtx-rtsp.yml) config file disables all protocols besides rtsp.
- The camera feed streamed through FFmpeg comes from `/dev/video0`.