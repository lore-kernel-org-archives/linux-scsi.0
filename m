From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Problems with a CD/DVD combo connected over ieee1394
Date: Mon, 24 Apr 2006 20:43:06 +0200
Message-ID: <444D1C3A.2000400@s5r6.in-berlin.de>
References: <courier.44437289.00004F6C@mail.die-welt.net>	<44442C63.6060901@s5r6.in-berlin.de> <courier.4444B842.00007F87@mail.die-welt.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:28591 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1751072AbWDXSpO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Apr 2006 14:45:14 -0400
In-Reply-To: <courier.4444B842.00007F87@mail.die-welt.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Evgeni Golov <sargentd@die-welt.net>
Cc: linux1394-user@lists.sourceforge.net, linux-scsi@vger.kernel.org

On 2006-04-18 Evgeni Golov wrote to linux1394-user:
[encrypted video DVDs cannot be read]
>>>When I insert a CSS DVD I can watch the intro (ads etc) but not the
>>>movie. libdvdcss2 says it could not crack the key. I even cannot
>>>copy the VOB to my hdd when I mount the dvd.
>>
>>Did you get the proper de-CSS capable package?
...
> Yeah. There is no libdvdcss2 in Debian but C. Marillat offers a great
> Debian Multimedia archive, where I have the package from. And yes, the
> package is okay, because it plays crypted DVDs on an other system with
> IDE DVD without problems.
> 
>>>Does someone know how to fix that issues (the second is more
>>>important than the first)? I have to add, that under Windows 2000 I
>>>can play the DVD without problems.
...
> I'll attach output from mplayer, vlc and dmesg, maybe there is something
> interesting for you. It's very annoying to boot Windows just to watch a
> DVD I've legaly bougth :(

I can't reproduce any of those errors here with a Plextor DVD-R/W built 
into a slightly crappy Prolific bridge based enclosure. I tested 
MPlayer, VLC, and Xine; at least the latter two on top of libdvdcss 
1.2.4. I think all of them are Mandrake 10.1 packaged versions with 
certain essential additions from Penguin Liberation Front. I sometimes 
install programs from source instead from prebuilt packages but I don't 
think I did so with these three.

Maybe such problems occur only with certain drives. There is a posting 
at linux-scsi today about problems reading UDF with Pioneer drives if 
attached to an USB or SBP-2 bridge. These are accompanied by entirely 
different errors though.

Maybe Linux' IDE subsystem has some ways of error recovery which the 
SCSI subsystem is lacking...?

(Crossposted to linux-scsi for lack of other ideas. The problem is quite 
certainly not related to the IEEE 1394 subsystem.)


> 
> ------------------------------------------------------------------------
> 
> MPlayer dev-CVS--4.0.3 (C) 2000-2006 MPlayer Team
> CPU: Intel Celeron 2/Pentium III Coppermine,Geyserville (Family: 6, Stepping: 10)
> CPUflags:  MMX: 1 MMX2: 1 3DNow: 0 3DNow2: 0 SSE: 1 SSE2: 0
> Compiled with runtime CPU detection.
> 
> Playing dvd://.
> libdvdread: Using libdvdcss version 1.2.9 for DVD access
> Reading disc structure, please wait...
> There are 15 titles on this DVD.
> There are 20 chapters in this DVD title.
> There are 1 angles in this DVD title.
> 
> *** libdvdread: CHECK_VALUE failed in ifo_read.c:1522 ***
> *** for info_length % sizeof(uint32_t) == 0 ***
> 
> libdvdread: Invalid title IFO (VTS_01_0.IFO).
> Cannot open the IFO file for DVD title 1.
> 
> [file] No filename
> 
> Failed to open dvd://
> 
> ## Second try:
> 
> Playing dvd://1.
> libdvdread: Using libdvdcss version 1.2.9 for DVD access
> Reading disc structure, please wait...
> There are 15 titles on this DVD.
> There are 20 chapters in this DVD title.
> There are 1 angles in this DVD title.
> 
> *** libdvdread: CHECK_VALUE failed in ifo_read.c:1522 ***
> *** for info_length % sizeof(uint32_t) == 0 ***
> 
> libdvdread: Invalid title IFO (VTS_01_0.IFO).
> Cannot open the IFO file for DVD title 1.
> 
> File not found: '1'
> 
> Failed to open dvd://1
> 
> Exiting... (Exit)
> 
> 
> ------------------------------------------------------------------------
> 
> VLC media player 0.8.4 Janus
> libdvdread: Using libdvdcss version 1.2.9 for DVD access
> 
> libdvdread: Attempting to retrieve all CSS keys
> libdvdread: This can take a _long_ time, please be patient
> 
> libdvdread: Get key for /VIDEO_TS/VIDEO_TS.VOB at 0x00000136
> libdvdread: Elapsed time 0
> libdvdread: Get key for /VIDEO_TS/VTS_01_0.VOB at 0x00004aad
> libdvdread: Elapsed time 0
> libdvdread: Get key for /VIDEO_TS/VTS_01_1.VOB at 0x0005189a
> libdvdread: Error cracking CSS key for /VIDEO_TS/VTS_01_1.VOB (0x0005189a)!!
> libdvdread: Elapsed time 30
> libdvdread: Get key for /VIDEO_TS/VTS_02_1.VOB at 0x00347baf
> libdvdread: Elapsed time 0
> libdvdread: Get key for /VIDEO_TS/VTS_03_0.VOB at 0x003532a3
> libdvdread: Elapsed time 0
> libdvdread: Get key for /VIDEO_TS/VTS_03_1.VOB at 0x0035f0b6
> libdvdread: Error cracking CSS key for /VIDEO_TS/VTS_03_1.VOB (0x0035f0b6)!!
> libdvdread: Elapsed time 31
> libdvdread: Get key for /VIDEO_TS/VTS_04_1.VOB at 0x003bc04d
> libdvdread: Elapsed time 0
> libdvdread: Found 4 VTS's
> libdvdread: Elapsed time 61
> 
> *** libdvdread: CHECK_VALUE failed in ifo_read.c:1522 ***
> *** for info_length % sizeof(uint32_t) == 0 ***
> 
> libdvdnav: Using dvdnav version 0.1.9 from http://dvd.sf.net
> libdvdnav: DVD Title: ONG_BAK
> libdvdnav: DVD Serial Number: 324fa243
> libdvdnav: DVD Title (Alternative): 
> libdvdnav: Unable to find map file '/home/zhenech/.dvdnav/ONG_BAK.map'
> libdvdnav: DVD disk reports itself with Region mask 0x00fd0000. Regions: 2
> libdvdnav: Language 'en' not found, using 'de' instead
> libdvdnav: Menu Languages available: de 
> libdvdnav: ifoRead_TITLE_VOBU_ADMAP vtsi failed - CRASHING
> 
> 
> ------------------------------------------------------------------------
> 
> ieee1394: sbp2: Logged into SBP-2 device
> ieee1394: Node 0-00:1023: Max speed [S400] - Max payload [2048]
>   Vendor: QSI       Model: CDRW/DVD SBW242U  Rev: UU30
>   Type:   CD-ROM                             ANSI SCSI revision: 00
> sr0: scsi3-mmc drive: 1x/351x xa/form2 caddy
> Uniform CD-ROM driver Revision: 3.20
> sr 1:0:0:0: Attached scsi CD-ROM sr0
> sr 1:0:0:0: Attached scsi generic sg0 type 5
> 
> ===================================================================
> 
> end_request: I/O error, dev sr0, sector 76368
> Buffer I/O error on device sr0, logical block 9546
> Buffer I/O error on device sr0, logical block 9547
> Buffer I/O error on device sr0, logical block 9548
> Buffer I/O error on device sr0, logical block 9549
> Buffer I/O error on device sr0, logical block 9550
> Buffer I/O error on device sr0, logical block 9551
> Buffer I/O error on device sr0, logical block 9552
> Buffer I/O error on device sr0, logical block 9553
> Buffer I/O error on device sr0, logical block 9554
> Buffer I/O error on device sr0, logical block 9555
> end_request: I/O error, dev sr0, sector 76616
> end_request: I/O error, dev sr0, sector 76368
> printk: 38 messages suppressed.
> Buffer I/O error on device sr0, logical block 9546
> Buffer I/O error on device sr0, logical block 9547
> Buffer I/O error on device sr0, logical block 9548
> Buffer I/O error on device sr0, logical block 9549
> Buffer I/O error on device sr0, logical block 9550
> Buffer I/O error on device sr0, logical block 9551
> Buffer I/O error on device sr0, logical block 9552
> Buffer I/O error on device sr0, logical block 9553
> Buffer I/O error on device sr0, logical block 9554
> Buffer I/O error on device sr0, logical block 9555
> end_request: I/O error, dev sr0, sector 76616
> end_request: I/O error, dev sr0, sector 1335912
> printk: 38 messages suppressed.
> Buffer I/O error on device sr0, logical block 166989
> end_request: I/O error, dev sr0, sector 1335912
> Buffer I/O error on device sr0, logical block 166989
> ieee1394: sbp2: aborting sbp2 command
> sr 1:0:0:0: 
>         command: Read TOC/PMA/ATIP: 43 00 00 00 00 00 00 00 0c 00
> end_request: I/O error, dev sr0, sector 1335912
> Buffer I/O error on device sr0, logical block 166989
> end_request: I/O error, dev sr0, sector 1335912
> Buffer I/O error on device sr0, logical block 166989
> end_request: I/O error, dev sr0, sector 14140120
> Buffer I/O error on device sr0, logical block 1767515
> end_request: I/O error, dev sr0, sector 14140120
> Buffer I/O error on device sr0, logical block 1767515
> ieee1394: sbp2: aborting sbp2 command
> sr 1:0:0:0: 
>         command: Read TOC/PMA/ATIP: 43 00 00 00 00 00 00 00 0c 00
> end_request: I/O error, dev sr0, sector 14140120
> Buffer I/O error on device sr0, logical block 1767515
> end_request: I/O error, dev sr0, sector 14140120
> Buffer I/O error on device sr0, logical block 1767515
> end_request: I/O error, dev sr0, sector 76368
> Buffer I/O error on device sr0, logical block 9546
> Buffer I/O error on device sr0, logical block 9547
> Buffer I/O error on device sr0, logical block 9548
> Buffer I/O error on device sr0, logical block 9549
> Buffer I/O error on device sr0, logical block 9550
> Buffer I/O error on device sr0, logical block 9551
> Buffer I/O error on device sr0, logical block 9552
> Buffer I/O error on device sr0, logical block 9553


-- 
Stefan Richter
-=====-=-==- -=-- ==---
http://arcgraph.de/sr/
