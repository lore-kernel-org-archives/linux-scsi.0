From: Alexander Jolk <alexj@buf.fr>
Subject: LSI MegaRAID SATA 300-X8 problems
Date: Tue, 07 Jun 2005 21:15:01 +0200
Message-ID: <42A5F235.6000300@buf.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.buf.fr ([195.68.52.65]:24287 "EHLO mail.buf.fr")
	by vger.kernel.org with ESMTP id S261960AbVFGTPE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jun 2005 15:15:04 -0400
Received: from srv1.pantin.buf.fr (srv1.pantin.buf.fr [172.21.0.241])
	by mail.buf.fr (8.12.3/8.12.3/Debian-7.1) with ESMTP id j57JExdf019880
	for <linux-scsi@vger.kernel.org>; Tue, 7 Jun 2005 21:14:59 +0200
Received: from [172.21.0.11] (alexj@admin2.pantin.buf.fr [172.21.0.11])
	by srv1.pantin.buf.fr (8.13.1/8.13.1/Debian-20) with ESMTP id j57JF2Wx017863
	for <linux-scsi@vger.kernel.org>; Tue, 7 Jun 2005 21:15:02 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I'm trying to get an LSI MegaRAID SATA 300-X8 controller to work on a 
Debian/sarge system with kernel 2.6.11-9-em64t-p4-smp from unstable. 
The megaraid_mbox module is loaded and seems to identify the controller, 
but whenever I try to access the disk, I get SCSI errors, the controller 
alarm goes off, and upon inspection in the BIOS, the first SATA disc is 
marked `FAILED'.  Reconfiguring the RAID lets me restart the whole process.

Simple question: am I doing something stupid, or else are there known 
problems, or should this normally work?  Pointers to docs would be very 
welcome, I've googled around quite a while but cannot seem to find 
relevant info.

Alex

Kernel messages follow:
Jun  7 19:25:24 player2k kernel: megaraid cmm: 2.20.2.5 (Release Date: 
Fri Jan 21 00:01:03 EST 2005)
Jun  7 19:25:24 player2k kernel: megaraid: 2.20.4.5 (Release Date: Thu 
Feb 03 12:27:22 EST 2005)
Jun  7 19:25:24 player2k kernel: megaraid: probe new device 
0x1000:0x0409:0x1000:0x3008: bus 4:slot 14:func 0
Jun  7 19:25:24 player2k kernel: ACPI: PCI interrupt 0000:04:0e.0[C] -> 
GSI 24 (level, low) -> IRQ 24
Jun  7 19:25:24 player2k kernel: megaraid: fw version:[813F] bios 
version:[H425]
Jun  7 19:25:24 player2k kernel: scsi4 : LSI Logic MegaRAID driver
Jun  7 19:25:24 player2k kernel: scsi[4]: scanning scsi channel 0 [Phy 
0] for non-raid devices
Jun  7 19:25:24 player2k kernel: scsi[4]: scanning scsi channel 1 
[virtual] for logical drives
Jun  7 19:25:24 player2k kernel:   Vendor: MegaRAID  Model: LD 0 RAID0 
469G  Rev: 813F
Jun  7 19:25:24 player2k kernel:   Type:   Direct-Access 
       ANSI SCSI revision: 02
Jun  7 19:25:24 player2k kernel: SCSI device sdb: 960933888 512-byte 
hdwr sectors (491998 MB)
Jun  7 19:25:24 player2k kernel: Losing some ticks... checking if CPU 
frequency changed.
Jun  7 19:25:24 player2k kernel: sdb: asking for cache data failed
Jun  7 19:25:24 player2k kernel: sdb: assuming drive cache: write through
Jun  7 19:25:24 player2k kernel: SCSI device sdb: 960933888 512-byte 
hdwr sectors (491998 MB)
Jun  7 19:25:24 player2k kernel: sdb: asking for cache data failed
Jun  7 19:25:24 player2k kernel: sdb: assuming drive cache: write through
Jun  7 19:25:24 player2k kernel:  /dev/scsi/host4/bus1/target0/lun0: 
unknown partition table
Jun  7 19:25:24 player2k kernel: Attached scsi disk sdb at scsi4, 
channel 1, id 0, lun 0
Jun  7 19:25:24 player2k kernel: megaraid: probe new device 
0x1000:0x0409:0x1000:0x3008: bus 5:slot 14:func 0
Jun  7 19:25:24 player2k kernel: ACPI: PCI interrupt 0000:05:0e.0[C] -> 
GSI 28 (level, low) -> IRQ 28
Jun  7 19:25:24 player2k kernel: megaraid: fw version:[813F] bios 
version:[H425]
Jun  7 19:25:24 player2k kernel: scsi5 : LSI Logic MegaRAID driver
Jun  7 19:25:24 player2k kernel: scsi[5]: scanning scsi channel 0 [Phy 
0] for non-raid devices
Jun  7 19:25:24 player2k kernel: scsi[5]: scanning scsi channel 1 
[virtual] for logical drives
Jun  7 19:25:24 player2k kernel:   Vendor: MegaRAID  Model: LD 0 RAID0 
469G  Rev: 813F
Jun  7 19:25:24 player2k kernel:   Type:   Direct-Access 
       ANSI SCSI revision: 02
Jun  7 19:25:24 player2k kernel: SCSI device sdc: 960933888 512-byte 
hdwr sectors (491998 MB)
Jun  7 19:25:24 player2k kernel: sdc: asking for cache data failed
Jun  7 19:25:24 player2k kernel: sdc: assuming drive cache: write through
Jun  7 19:25:24 player2k kernel: SCSI device sdc: 960933888 512-byte 
hdwr sectors (491998 MB)
Jun  7 19:25:24 player2k kernel: sdc: asking for cache data failed
Jun  7 19:25:24 player2k kernel: sdc: assuming drive cache: write through
Jun  7 19:25:24 player2k kernel:  /dev/scsi/host5/bus1/target0/lun0: 
unknown partition table
Jun  7 19:25:24 player2k kernel: Attached scsi disk sdc at scsi5, 
channel 1, id 0, lun 0
Jun  7 19:25:24 player2k kernel: e1000: eth0: e1000_watchdog: NIC Link 
is Up 100 Mbps Full Duplex
Jun  7 19:25:28 player2k kernel: NET: Registered protocol family 10
Jun  7 19:25:28 player2k kernel: Disabled Privacy Extensions on device 
ffffffff8038f300(lo)
Jun  7 19:25:28 player2k kernel: IPv6 over IPv4 tunneling driver
Jun  7 19:25:30 player2k kernel: XFree86: vm86 mode not supported on 64 
bit kernel
Jun  7 19:25:39 player2k kernel: eth0: no IPv6 routers present
Jun  7 19:27:17 player2k kernel: md: md driver 0.90.1 MAX_MD_DEVS=256, 
MD_SB_DISKS=27
Jun  7 19:27:27 player2k kernel: SCSI error : <4 1 0 0> return code = 
0x40001
Jun  7 19:27:27 player2k kernel: end_request: I/O error, dev sdb, sector 0
Jun  7 19:27:27 player2k kernel: Buffer I/O error on device sdb, logical 
block 0
Jun  7 19:27:27 player2k kernel: SCSI error : <4 1 0 0> return code = 
0x40001
Jun  7 19:27:27 player2k kernel: end_request: I/O error, dev sdb, sector 8
Jun  7 19:27:27 player2k kernel: Buffer I/O error on device sdb, logical 
block 1
[many more of these...]

-- 
Alexander Jolk  * BUF Compagnie * alexj@buf.com
Tel +33-1 42 68 18 28  *  Fax +33-1 42 68 18 29
