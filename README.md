# Auto Enum Script

## [Faraday](https://github.com/infobyte/faraday)

### Start server

``` bash
sudo systemctl start postgresql
```

``` bash
sudo systemctl start faraday-server
```

### Client

``` bash
faraday-cli auth
```

``` bash
faraday-cli select_ws demo
```

## Usage

``` bash
./auto_enum.sh <HOST>
```

Example

``` bash
┌──(Hades㉿192.168.11.130)-[1.7:36.5]~/bash_script
└─$ ./faraday_auto_enum.sh 192.168.11.139
nmap -p- --min-rate 1000 192.168.11.139 | grep ^[0-9] | cut -d '/' -f1 | tr '\n' ',' | sed s/,$//
[+] 22,80,3306
nmap -sC -sV -p22,80,3306 192.168.11.139
💻 Processing Nmap command
Starting Nmap 7.91 ( https://nmap.org ) at 2021-03-12 03:47 EST
Nmap scan report for 192.168.11.139
Host is up (0.00055s latency).

PORT     STATE SERVICE VERSION
22/tcp   open  ssh     OpenSSH 6.0 (protocol 2.0)
| ssh-hostkey: 
|   1024 8b:4c:a0:14:1c:3c:8c:29:3a:16:1c:f8:1a:70:2a:f3 (DSA)
|   2048 d9:91:5d:c3:ed:78:b5:8c:9a:22:34:69:d5:68:6d:4e (RSA)
|_  256 b2:23:9a:fa:a7:7a:cb:cd:30:85:f9:cb:b8:17:ae:05 (ECDSA)
80/tcp   open  http    Apache httpd 2.2.21 ((Unix) DAV/2 PHP/5.4.3)
|_http-server-header: Apache/2.2.21 (Unix) DAV/2 PHP/5.4.3
|_http-title: [PentesterLab] Padding Oracle
3306/tcp open  mysql   MySQL (unauthorized)

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 6.52 seconds
⬆ Sending data to workspace: demo
✔ Done
===============================================================
===============================================================
80
dirb http://192.168.11.139:80/ /usr/share/wordlists/dirb/common.txt
💻 Processing dirb command

-----------------
DIRB v2.22    
By The Dark Raver
-----------------

START_TIME: Fri Mar 12 03:47:38 2021
URL_BASE: http://192.168.11.139:80/
WORDLIST_FILES: /usr/share/wordlists/dirb/common.txt
OPTION: Silent Mode
OPTION: Not Stopping on warning messages

-----------------

GENERATED WORDS: 4612

---- Scanning URL: http://192.168.11.139:80/ ----
+ http://192.168.11.139:80/cgi-bin/ (CODE:403|SIZE:210)
==> DIRECTORY: http://192.168.11.139:80/classes/
==> DIRECTORY: http://192.168.11.139:80/css/
+ http://192.168.11.139:80/favicon.ico (CODE:200|SIZE:14634)
==> DIRECTORY: http://192.168.11.139:80/images/
+ http://192.168.11.139:80/index.php (CODE:200|SIZE:1303)

---- Entering directory: http://192.168.11.139:80/classes/ ----
(!) WARNING: Directory IS LISTABLE. No need to scan it.
    (Use mode '-w' if you want to scan it anyway)

---- Entering directory: http://192.168.11.139:80/css/ ----
(!) WARNING: Directory IS LISTABLE. No need to scan it.
    (Use mode '-w' if you want to scan it anyway)

---- Entering directory: http://192.168.11.139:80/images/ ----
(!) WARNING: Directory IS LISTABLE. No need to scan it.
    (Use mode '-w' if you want to scan it anyway)

-----------------
END_TIME: Fri Mar 12 03:47:56 2021
DOWNLOADED: 18448 - FOUND: 3
⬆ Sending data to workspace: demo
✔ Done
===============================================================
```