# Bonjour Demo
The workspace contains two projects: a simple connection listener (BonjourServer) and a simple service browser (BonjourServer) that resolves Bonjour services and it's' IP addresses

## Installing ZeroConfig implementation (Avahi) on Raspberry Pi

First run `sudo apt-get install avahi-daemon`.

Next, make sure it runs at startup, enter `sudo update-rc.d avahi-daemon defaults`.

Create a configuration file containing information about the server.
`sudo nano /etc/avahi/services/demoapp.service`

Enter (or copy/paste) the following:
```
<?xml version="1.0" standalone='no'?><!--*-nxml-*-->
  <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
  <service-group>
      <name replace-wildcards="yes">%h</name>
      <service>
          <type>_demoapp._tcp</type>
          <port>12345</port>
      </service>
  </service-group>
```

Press `Ctrl+x` to exit, then press `y` to to save changes and return after confirming the location.
Restart Avahi
`sudo /etc/init.d/avahi-daemon restart`

Download `demo.service` config file from GitHub using `wget` 
`wget https://raw.githubusercontent.com/mathsatan/bonjour-demo-app/main/demo.xml -O /etc/avahi/services/demo.service`
