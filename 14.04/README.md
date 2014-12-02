Honeypot Auto-Install Script
=====================

This script is an automated installation script that install and deploy multiple variant of honeypot automatically with minimal of user interaction. 

Currently installs and sets up:

* p0f
* dionaea
* kippo
* glastopf

All of these will be installed as system services so running this script once should turn a vanilla install in to a robust honeypot.

Currently this script is tested on **Ubuntu Server 14.04 LTS**.  /!\ **Use with caution!** /!\

Usage
---------------------
**This can script can cause damage to your system.** (If you know what I mean ;D)

    chmod +x dionaea.sh
    ./dionaea.sh
    
    chmod +x kippo.sh
    ./kippo.sh
    
    chmod +x glastopf.sh
    ./glastopf.sh

The script will promt you to enter your network interface and IP address before it begin installation. Also please ensure that you have a nice and steady internet connection or else the installation will corrupt.

Effects
---------------------

* Moves SSH server from port 22 to 65534
* Installs [Dionaea](http://dionaea.carnivore.it/), [Kippo](http://code.google.com/p/kippo/), [Glastopf](https://github.com/glastopf/glastopf), [p0f](http://lcamtuf.coredump.cx/p0f3/)
* Sets up Dionaea, Kippo, Glastopf and p0f as system services that run on startup

Directory Structure
---------------------
**Start-up Script**
* p0f: `/etc/init.d/p0f start|stop|status|restart`
* Dionaea: `/etc/init.d/dionaea start|stop|status|restart`
* Kippo: `/etc/init.d/kippo start|stop|status|restart`
* Glastopf: `/etc/init.d/glastopf start|stop|status|restart`
* 
* **Configuration**
* Dionaea: `/opt/dionaea/etc/dionaea/`
* Kippo: `/opt/kippo/`
* Glastopf: `/opt/glaspot/`

**Logging**
* Dionaea: `/opt/dionaea/var/dionaea/`
* Kippo: `/var/kippo/`
* Glastopf: `/opt/glaspot/`
* p0f: `/var/p0f/`
