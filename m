From: "didier" <didier@ece.gatech.edu>
Subject: Pb between an UltraTrak SX8000 and an Adaptec 29160
Date: Thu, 14 Nov 2002 15:50:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <004601c28c1f$66cde6c0$13e2cf82@darkwolf>
Reply-To: <didier@ece.gatech.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from darkwolf (darkwolf.ee.gatech.edu [130.207.226.19])
	by mail.ee.gatech.edu (8.12.3/8.12.3) with ESMTP id gAEKo1L8013636
	for <linux-scsi@vger.kernel.org>; Thu, 14 Nov 2002 15:50:01 -0500 (EST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org



I have just connected a brand new UltraTrak SX8000
(from Promise with 8 x 200GB IDE drives) to an
adaptec 29160. The UltraTrak SX8000 is connected
via a brand new LVD cable (1meter).

While everything seems fine, I am getting a bunch of

(scsi0:A:0:0): parity error detected in Data-out phase. SEQADDR(0x56)
SCSIRATE(0xc2)
        No terminal CRC packet recevied
(scsi0:A:0:0): parity error detected in Data-out phase. SEQADDR(0x54)
SCSIRATE(0xc2)
        No terminal CRC packet recevied
(scsi0:A:0:0): parity error detected in Data-out phase. SEQADDR(0x54)
SCSIRATE(0xc2)
        No terminal CRC packet recevied
(scsi0:A:0:0): parity error detected in Data-out phase. SEQADDR(0x55)
SCSIRATE(0xc2)
        No terminal CRC packet recevied
(scsi0:A:0:0): parity error detected in Data-out phase. SEQADDR(0x90)
SCSIRATE(0xc2)
        No terminal CRC packet recevied

in my /var/log/messages.

I was wondering if someone could give me some insight.

The UltraTrak SX8000 has its internal termination enabled.

Here is what I get during my boot:

Nov 14 11:04:32 dagdhasrv kernel: Linux version 2.4.18-17.7.xsmp
(bhcompile@daffy.perf.redhat.com) (gcc version 2.96 20000731 (Red Hat
Linux 7.3 2.96-112)) #1 SMP Tue Oct 8 12:37:04 EDT 2002
[..........]
Nov 14 11:04:35 dagdhasrv kernel: SCSI subsystem driver Revision: 1.00
Nov 14 11:04:35 dagdhasrv kernel: kmod: failed to exec /sbin/modprobe -s
-k scsi_hostadapter, errno = 2
Nov 14 11:04:35 dagdhasrv kernel: scsi0 : Adaptec AIC7XXX EISA/VLB/PCI
SCSI HBA DRIVER, Rev 6.2.8
Nov 14 11:04:35 dagdhasrv kernel:         <Adaptec 29160 Ultra160 SCSI
adapter>
Nov 14 11:04:35 dagdhasrv kernel:         aic7892: Ultra160 Wide Channel
A, SCSI Id=7, 32/253 SCBs
Nov 14 11:04:35 dagdhasrv kernel: 
[........]
Nov 14 11:04:35 dagdhasrv kernel: blk: queue c35ef618, I/O limit 4095Mb
(mask 0xffffffff)
Nov 14 11:04:35 dagdhasrv kernel:   Vendor: Promise   Model: 7 Disk
RAID5      Rev: 1.10
Nov 14 11:04:35 dagdhasrv kernel:   Type:   Direct-Access
ANSI SCSI revision: 03
Nov 14 11:04:35 dagdhasrv kernel: blk: queue c35ef418, I/O limit 4095Mb
(mask 0xffffffff)
Nov 14 11:04:35 dagdhasrv kernel: scsi0:A:0:0: Tagged Queuing enabled.
Depth 253
[.......]
Nov 14 11:04:35 dagdhasrv kernel: (scsi0:A:0): 160.000MB/s transfers
(80.000MHz DT, offset 62, 16bit)
Nov 14 11:04:35 dagdhasrv kernel: SCSI device sda: -1951217920 512-byte
hdwr sectors (100488 MB)
Nov 14 11:04:35 dagdhasrv kernel: Partition check:
Nov 14 11:04:35 dagdhasrv kernel:  sda: sda1

Any idea ?

Thanks in advance for any suggestion

