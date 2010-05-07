From: Jonas Schwertfeger <jschwertfeger@gmail.com>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Fri, 07 May 2010 12:42:15 +0200
Message-ID: <4BE3EE87.6020505@gmail.com>
References: <Pine.LNX.4.44L0.1004291144480.1697-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1004291144480.1697-100000@iolanthe.rowland.org>
Sender: linux-hotplug-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, Mark Lord <mlord@pobox.com>, Dinh.Nguyen@freescale.com, Sergei Shtylyov <sshtylyov@mvista.com>, James Bottomley <James.Bottomley@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

On 04/29/2010 05:45 PM, Alan Stern wrote:
 > I would still like to see a usbmon trace of hdparm under USB-2.

hdparm through USB-2:

/dev/sdb:
outgoing cdb:  85 08 2e 00 00 00 01 00 00 00 00 00 00 40 ec 00
data:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
SG_IO: ATA_16 status=0x0, host_status=0x0, driver_status=0x0
SG_IO: bad response (not CHECK_CONDITION)
Trying legacy HDIO_DRIVE_CMD
outgoing cdb:  85 08 2e 00 00 00 01 00 00 00 00 00 00 40 a1 00
data:  40 00 ff 3f 37 c8 10 00 00 00 00 00 3f 00 00 00
SG_IO: ATA_16 status=0x2, host_status=0x0, driver_status=0x8
SG_IO: sb[]:  72 0b 00 00 00 00 00 0e 09 0c 00 04 00 01 00 00 00 00 00 
00 40 51 00 00 00 00 00 00 00 00 00 00
SG_IO: desc[]:  09 0c 00 04 00 01 00 00 00 00 00 00
       ATA_16 stat=51 err=04 nsect=01 lbal=00 lbam=00 lbah=00 dev=40
I/O error, ata_op=0xa1 ata_status=0x51 ata_error=0x04
  HDIO_DRIVE_CMD(identify) failed: Input/output error
  readonly      =  0 (off)
  readahead     = 256 (on)
  geometry      = 121601/255/63, sectors = 1953525168, start = 0

ffff8801f8199540 602153163 S Bo:1:003:2 -115 31 = 55534243 d4000000 
00020000 80001085 082e0000 00010000 00000000 40ec00
ffff8801f8199540 602153314 C Bo:1:003:2 0 31 >
ffff8801f8184d80 602153376 S Bi:1:003:1 -115 512 <
ffff8801f8184d80 602159046 C Bi:1:003:1 0 512 = 00000000 00000000 
00000000 00000000 00000000 00000000 00000000 00000000
ffff8801f8199540 602159103 S Bi:1:003:1 -115 13 <
ffff8801f8199540 602159156 C Bi:1:003:1 0 13 = 55534253 d4000000 00000000 00
ffff8801f8199540 602159382 S Bo:1:003:2 -115 31 = 55534243 d5000000 
00020000 80001085 082e0000 00010000 00000000 40a100
ffff8801f8199540 602159536 C Bo:1:003:2 0 31 >
ffff8801f8184d80 602159594 S Bi:1:003:1 -115 512 <
ffff8801f8184d80 602159791 C Bi:1:003:1 -32 0
ffff8801f8199540 602159846 S Co:1:003:0 s 02 01 0000 0081 0000 0
ffff8801f8199540 602159900 C Co:1:003:0 0 0
ffff8801f8199540 602159951 S Bi:1:003:1 -115 13 <
ffff8801f8199540 602160029 C Bi:1:003:1 0 13 = 55534253 d5000000 00020000 01
ffff8801f8199540 602160100 S Bo:1:003:2 -115 31 = 55534243 d6000000 
60000000 80000603 00000060 00000000 00000000 000000
ffff8801f8199540 602160159 C Bo:1:003:2 0 31 >
ffff8801f8184d80 602160201 S Bi:1:003:1 -115 96 <
ffff8801f8184d80 602160276 C Bi:1:003:1 0 96 = 00000000 00000000 
00000000 00000000 00000000 00000000 00000000 00000000
ffff8801f8199540 602160334 S Bi:1:003:1 -115 13 <
ffff8801f8199540 602160418 C Bi:1:003:1 0 13 = 55534253 d6000000 00000000 00
ffff8801f8199540 602161915 S Bo:1:003:2 -115 31 = 55534243 d7000000 
00100000 80000a28 00000000 00000008 00000000 000000
ffff8801f8199540 602162023 C Bo:1:003:2 0 31 >
ffff8801f8184d80 602162080 S Bi:1:003:1 -115 4096 <
ffff8801f8184d80 602162284 C Bi:1:003:1 0 4096 = 00000000 00000000 
00000000 00000000 00000000 00000000 00000000 00000000
ffff8801f8199540 602162344 S Bi:1:003:1 -115 13 <
ffff8801f8199540 602162405 C Bi:1:003:1 0 13 = 55534253 d7000000 00000000 00

and hdparm through UBS-3:

/dev/sdb:
outgoing cdb:  85 08 2e 00 00 00 01 00 00 00 00 00 00 40 ec 00
data:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
SG_IO: ATA_16 status=0x0, host_status=0x0, driver_status=0x0
SG_IO: bad response (not CHECK_CONDITION)
Trying legacy HDIO_DRIVE_CMD
outgoing cdb:  85 08 2e 00 00 00 01 00 00 00 00 00 00 40 a1 00
data:  40 00 ff 3f 37 c8 10 00 00 00 00 00 3f 00 00 00
SG_IO: ATA_16 status=0x2, host_status=0x0, driver_status=0x8
SG_IO: sb[]:  72 0b 00 00 00 00 00 0e 09 0c 00 04 00 01 00 00 00 00 00 
00 40 51 00 00 00 00 00 00 00 00 00 00
SG_IO: desc[]:  09 0c 00 04 00 01 00 00 00 00 00 00
       ATA_16 stat=51 err=04 nsect=01 lbal=00 lbam=00 lbah=00 dev=40
I/O error, ata_op=0xa1 ata_status=0x51 ata_error=0x04
  HDIO_DRIVE_CMD(identify) failed: Input/output error
  readonly      =  0 (off)
  readahead     = 256 (on)
  geometry      = 121601/255/63, sectors = 1953525168, start = 0

ffff8801f810c6c0 734453214 S Bo:10:002:2 -115 31 = 55534243 c4000000 
00020000 80001085 082e0000 00010000 00000000 40ec00
ffff8801f810c6c0 734453421 C Bo:10:002:2 0 31 >
ffff8801f810c9c0 734453512 S Bi:10:002:1 -115 512 <
ffff8801f810c9c0 734459225 C Bi:10:002:1 0 512 Z
ffff8801f810c6c0 734459316 S Bi:10:002:1 -115 13 <
ffff8801f810c6c0 734459485 C Bi:10:002:1 0 13 = 55534253 c4000000 
00000000 00
ffff8801f810c6c0 734459861 S Bo:10:002:2 -115 31 = 55534243 c5000000 
00020000 80001085 082e0000 00010000 00000000 40a100
ffff8801f810c6c0 734460033 C Bo:10:002:2 0 31 >
ffff8801f810c9c0 734460121 S Bi:10:002:1 -115 512 <
ffff8801f810c9c0 734460395 C Bi:10:002:1 -32 0
ffff8801f810c6c0 734460482 S Co:10:002:0 s 02 01 0000 0081 0000 0
ffff8801f810c6c0 734460885 C Co:10:002:0 0 0
ffff8801f810c6c0 734461026 S Bi:10:002:1 -115 13 <
ffff8801f810c6c0 734461270 C Bi:10:002:1 0 13 = 55534253 c5000000 
00020000 01
ffff8801f810c6c0 734461371 S Bo:10:002:2 -115 31 = 55534243 c6000000 
60000000 80000603 00000060 00000000 00000000 000000
ffff8801f810c6c0 734461560 C Bo:10:002:2 0 31 >
ffff8801f810c9c0 734461649 S Bi:10:002:1 -115 96 <
ffff8801f810c9c0 734461814 C Bi:10:002:1 0 96 Z
ffff8801f810c6c0 734461904 S Bi:10:002:1 -115 13 <
ffff8801f810c6c0 734462066 C Bi:10:002:1 0 13 = 55534253 c6000000 
00000000 00
ffff8801f810c6c0 734463922 S Bo:10:002:2 -115 31 = 55534243 c7000000 
00100000 80000a28 00000000 00000008 00000000 000000
ffff8801f810c6c0 734464100 C Bo:10:002:2 0 31 >
ffff8801f810c9c0 734464187 S Bi:10:002:1 -115 4096 <
ffff8801f810c9c0 734476632 C Bi:10:002:1 0 4096 Z
ffff8801f810c6c0 734476724 S Bi:10:002:1 -115 13 <
ffff8801f810c6c0 734476913 C Bi:10:002:1 0 13 = 55534253 c7000000 
00000000 00

Hope this helps,
-Jonas
