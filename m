From: Stanislav Malyshev <stas@zend.com>
Subject: problem with SCSI tape/linux
Date: Wed, 12 Jun 2002 14:03:36 +0300 (IDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0206121403160.26529-100000@shire.zend.office>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have strange problem with SCSI tape on Linux: each time it tries to 
write the tape, the following error is given:

Jun 12 12:24:53 cheese kernel: st0: Error with sense data: [valid=0] Info 
fld=0x0, Current st09:00: sense key Aborted Command
Jun 12 12:24:53 cheese kernel: Additional sense indicates Data phase error

The error comes almost instantly on write, seemingly even before the tape 
is really accessed. Can it be driver problem or the drive itself is defect 
(I have sent it once to repair, but they say the drive is OK) or any other 
reason?
The kernel version is 2.2.20. The SCSI controller is:

Adaptec AHA-294X Ultra2 SCSI host adapter
Ultra-2 LVD/SE Wide Controller at PCI 0/11/0

SCSI info:

(scsi0:0:0:0)
  Device using Wide/Sync transfers at 40.0 MByte/sec, offset 31
  Transinfo settings: current(12/31/1/0), goal(10/127/1/0), 
user(10/127/1/0)
  Total transfers 26615764 (10008238 reads and 16607526 writes)


(scsi0:0:1:0)
  Device using Wide/Sync transfers at 40.0 MByte/sec, offset 31
  Transinfo settings: current(12/31/1/0), goal(10/127/1/0), 
user(10/127/1/0)
  Total transfers 2824250 (1851699 reads and 972551 writes)


(scsi0:0:3:0)
  Device using Narrow/Sync transfers at 10.0 MByte/sec, offset 32
  Transinfo settings: current(25/32/0/0), goal(10/127/0/0), 
user(10/127/1/0)
  Total transfers 261155 (25 reads and 261130 writes)


The drive is HP C1537A, in the following setup:

Attached devices: 
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: IBM      Model: DNES-318350W     Rev: SA30
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 01 Lun: 00
  Vendor: IBM      Model: DNES-318350W     Rev: SA30
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 03 Lun: 00
  Vendor: HP       Model: C1537A           Rev: L105
  Type:   Sequential-Access                ANSI SCSI revision: 02

Thanks in advance for any help.
-- 
Stanislav Malyshev, Zend Products Engineer   
stas@zend.com  http://www.zend.com/ +972-3-6139665 ext.115




