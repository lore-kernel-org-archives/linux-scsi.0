From: thierry <thierr@sockho.com>
Subject: aic7xxx_dev_reset
Date: 30 Apr 2003 12:38:10 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1051699092.1056.5.camel@mahite>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adaro.host4u.net ([216.71.64.121]:3090 "EHLO adaro.host4u.net")
	by vger.kernel.org with ESMTP id S262139AbTD3KZ5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Apr 2003 06:25:57 -0400
Received: from [192.168.1.23] (midisys.rain.fr [195.101.170.238])
	by adaro.host4u.net (8.11.6/8.11.6) with ESMTP id h3UAcBF19601
	for <linux-scsi@vger.kernel.org>; Wed, 30 Apr 2003 05:38:12 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I have an adaptec scsi card (2910C) on my linux box with a freshly
installed redhat 9.0 and a 2.4.18 kernel, and a scsi plextor cd
recorder,I used cdrecord to burn a cd and I got a problem.

Here is the dmesg out :

******
SCSI subsystem driver Revision: 1.00
scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.4
        <Adaptec 2902/04/10/15/20/30C SCSI adapter>
        aic7850: Single Channel A, SCSI Id=7, 3/253 SCBs

  Vendor: PLEXTOR   Model: CD-R   PX-W4012S  Rev: 1.00
  Type:   CD-ROM                             ANSI SCSI revision: 02
(scsi0:A:0): 10.000MB/s transfers (10.000MHz, offset 15)
Journalled Block Device driver loaded
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
Freeing unused kernel memory: 200k freed
Real Time Clock Driver v1.10e
EXT3 FS 2.4-0.9.17, 10 Jan 2002 on ide0(3,1), internal journal
Adding Swap: 64220k swap-space (priority -1)
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.17, 10 Jan 2002 on ide0(3,7), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.17, 10 Jan 2002 on ide0(3,5), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.17, 10 Jan 2002 on ide0(3,2), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.17, 10 Jan 2002 on ide0(3,3), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
RTLinux Extensions Loaded (http://www.fsmlabs.com/)
8139too Fast Ethernet driver 0.9.24
eth0: D-Link DFE-538TX (RealTek RTL8139) at 0xc28a4f00,
00:05:5d:2e:24:5d, IRQ 5
eth0:  Identified 8139 chip type 'RTL-8139C'
eth0: Setting 10mbps full-duplex based on auto-negotiated partner
ability 4061.
Attached scsi CD-ROM sr0 at scsi0, channel 0, id 0, lun 0
sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.12
VFS: Disk change detected on device sr(11,0)
ISO 9660 Extensions: RRIP_1991A
Attached scsi CD-ROM sr0 at scsi0, channel 0, id 0, lun 0
sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
VFS: Disk change detected on device sr(11,0)
scsi0:0:0:0: Attempting to queue an ABORT message
scsi0: Dumping Card State while idle, at SEQADDR 0x7
ACCUM = 0xf5, SINDEX = 0x7, DINDEX = 0x21, ARG_2 = 0x0
HCNT = 0x0
SCSISEQ = 0x12, SBLKCTL = 0x0
 DFCNTRL = 0x0, DFSTATUS = 0x2d
LASTPHASE = 0x1, SCSISIGI = 0x0, SXFRCTL0 = 0x80
SSTAT0 = 0x5, SSTAT1 = 0xa
STACK == 0x3, 0x198, 0x157, 0x0
SCB count = 4
Kernel NEXTQSCB = 2
Card NEXTQSCB = 2
QINFIFO entries: 
Waiting Queue entries: 
Disconnected Queue entries: 0:3 
QOUTFIFO entries: 
Sequencer Free SCB List: 1 2 
Pending list: 3
Kernel Free SCB list: 1 0 
Untagged Q(0): 3 
DevQ(0:0:0): 0 waiting
(scsi0:A:0:0): Queuing a recovery SCB
scsi0:0:0:0: Device is disconnected, re-queuing SCB
Recovery code sleeping
(scsi0:A:0:0): Abort Message Sent
(scsi0:A:0:0): SCB 3 - Abort Completed.
Recovery SCB completes
Recovery code awake
aic7xxx_abort returns 0x2002
scsi0:0:0:0: Attempting to queue a TARGET RESET message
scsi0:0:0:0: Command not found
aic7xxx_dev_reset returns 0x2002
scsi0:0:0:0: Attempting to queue an ABORT message
scsi0: Dumping Card State while idle, at SEQADDR 0x7
ACCUM = 0x34, SINDEX = 0x7, DINDEX = 0x21, ARG_2 = 0x0
HCNT = 0x0
SCSISEQ = 0x12, SBLKCTL = 0x0
 DFCNTRL = 0x0, DFSTATUS = 0x2d
LASTPHASE = 0x1, SCSISIGI = 0x0, SXFRCTL0 = 0x80
SSTAT0 = 0x5, SSTAT1 = 0xa
STACK == 0x3, 0x198, 0x157, 0xe2
SCB count = 4
Kernel NEXTQSCB = 2
Card NEXTQSCB = 2
QINFIFO entries: 
Waiting Queue entries: 
Disconnected Queue entries: 0:3 
QOUTFIFO entries: 
Sequencer Free SCB List: 1 2 
Pending list: 3
Kernel Free SCB list: 1 0 
Untagged Q(0): 3 
DevQ(0:0:0): 0 waiting
(scsi0:A:0:0): Queuing a recovery SCB
scsi0:0:0:0: Device is disconnected, re-queuing SCB
Recovery code sleeping
(scsi0:A:0:0): Abort Message Sent
(scsi0:A:0:0): SCB 3 - Abort Completed.
Recovery SCB completes
Recovery code awake
aic7xxx_abort returns 0x2002
scsi0:0:0:0: Attempting to queue a TARGET RESET message
scsi0:0:0:0: Command not found
aic7xxx_dev_reset returns 0x2002
Device 0b:00 not ready.
 I/O error: dev 0b:00, sector 1246296
isofs_read_super: bread failed, dev=0b:00, iso_blknum=311574,
block=311574
Attached scsi CD-ROM sr0 at scsi0, channel 0, id 0, lun 0
sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
cdrom: open failed.
VFS: Disk change detected on device sr(11,0)
cdrom: open failed.
VFS: Disk change detected on device sr(11,0)

***

The cdrecorder was not ready for few seconds.
I never had this problem before.

What is the problem ?

Thanks a lot.

Thierry


