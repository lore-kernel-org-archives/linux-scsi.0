From: "frage schnell" <frage.schnell1@gmx.de>
Subject: Re: sym53c8xx_2 make scsitap slow
Date: Thu, 13 Jan 2005 11:20:17 +0100 (MET)
Message-ID: <12890.1105611617@www67.gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imap.gmx.net ([213.165.64.20]:481 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S261554AbVAMKUS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Jan 2005 05:20:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

"frage schnell" <frage.schnell@gmx.de> writes:  
  
>> I used a HP ulrium storage on a tekteam DC-390U2B with kernel 2.6.5 and  
>> modul sym53c8xx   
>>   tar writs with 11MB/s to the tape  
>> with new kernel 2.6.8 or 2.6.10  
>>    tar writs with 3MB/s to the tape  
>>  
>> wath have I to to to get the same speed with the new kennel   
  
>Please provide dmesg logs to shed some light on the detection of the  
>adaptor and tape drive.  
  
dmesg for kernel 2.6.5 scsi related parts   
  
Linux version 2.6.5-7.111-smp (geeko@buildhost) (gcc version 3.3.3 (SuSE  
Linux))SCSI subsystem initialized  
Red Hat/Adaptec aacraid driver (1.1.2-lk1 Oct 14 2004)  
AAC0: kernel 4.0.4 build 5770  
AAC0: monitor 4.0.4 build 5770  
AAC0: bios 4.0.0 build 5770  
AAC0: serial ba2b1bfafaf001  
aacraid:        NMI ISR: NMI_PRIMARY_ATU_ERROR  
scsi0 : aacraid  
  Vendor: ADAPTEC   Model: Adaptec RAID5     Rev: V1.0  
  Type:   Direct-Access                      ANSI SCSI revision: 02  
SCSI device sda: 287105024 512-byte hdwr sectors (146998 MB)  
sda: Write Protect is off  
sda: Mode Sense: 03 00 00 00  
SCSI device sda: drive cache: write through  
 sda: sda1 sda2  
Attached scsi removable disk sda at scsi0, channel 0, id 0, lun 0  
  Vendor: ADAPTEC   Model: Adaptec Volume    Rev: V1.0  
  Type:   Direct-Access                      ANSI SCSI revision: 02  
SCSI device sdb: 143552512 512-byte hdwr sectors (73499 MB)  
sdb: Write Protect is off  
sdb: Mode Sense: 03 00 00 00  
SCSI device sdb: drive cache: write through  
 sdb: sdb1 sdb2  
Attached scsi removable disk sdb at scsi0, channel 0, id 1, lun 0  
Capability LSM initialized  
ReiserFS: sda1: found reiserfs format "3.6" with standard journal  
ReiserFS: sda1: using ordered data mode  
reiserfs: using flush barriers  
ReiserFS: sda1: journal params: device sda1, size 8192, journal first  
block 18,  
max trans len 1024, max batch 900, max commit age 30, max trans age 30  
ReiserFS: sda1: checking transaction log (sda1)  
reiserfs: disabling flush barriers on sda1  
ReiserFS: sda1: Using r5 hash to sort names  
VFS: Mounted root (reiserfs filesystem) readonly.  
Trying to move old root to /initrd ... failed  
Unmounting old root  
Trying to free ramdisk memory ... failed  
Freeing unused kernel memory: 244k freed  
Adding 1052216k swap on /dev/sdb1.  Priority:42 extents:1  
sk98lin: Network Device Driver v6.23  
(C)Copyright 1999-2004 Marvell(R).  
eth0: 3Com Gigabit LOM (3C940)  
      PrefPort:A  RlmtMode:Check Link State  
sym0: <895> rev 0x1 at pci 0000:02:0c.0 irq 20  
sym0: Tekram NVRAM, ID 15, Fast-40, LVD, parity checking  
sym0: SCSI BUS has been reset.  
scsi1 : sym-2.1.18i  
  
md: Autodetecting RAID arrays.  
md: autorun ...  
md: ... autorun DONE.  
device-mapper: 4.1.0-ioctl (2003-12-10) initialised: dm@uk.sistina.com  
8139too Fast Ethernet driver 0.9.27  
  Vendor: HP        Model: Ultrium 1-SCSI    Rev: N27D  
  Type:   Sequential-Access                  ANSI SCSI revision: 03  
sym0:5: FAST-40 WIDE SCSI 80.0 MB/s ST (25.0 ns, offset 15)  
Attached scsi generic sg0 at scsi0, channel 0, id 0, lun 0,  type 0  
Attached scsi generic sg1 at scsi0, channel 0, id 1, lun 0,  type 0  
Attached scsi generic sg2 at scsi1, channel 0, id 5, lun 0,  type 1  
hw_random hardware driver 1.0.0 loaded  
  
st: Version 20040318, fixed bufsize 32768, s/g segs 256  
Attached scsi tape st0 at scsi1, channel 0, id 5, lun 0  
st0: try direct i/o: yes (alignment 512 B), max page reachable by HBA  
1048575  
subfs 0.9  
  
  
st0: Block limits 1 - 16777215 bytes.  
 
dmesg for kernel 2.6.5 scsi related parts   
 
 
 Linux version 2.6.8-24.10-smp (geeko@buildhost) (gcc version 3.3.4 (pre 
3.3.5 20040809)) #1 SMP Wed Dec 22 11:54:27 UTC 2004 
 
SCSI subsystem initialized 
aacraid: falsely claims to have parameter commit 
Red Hat/Adaptec aacraid driver (1.1.2-lk2 Dec 22 2004) 
ACPI: PCI interrupt 0000:02:0a.0[A] -> GSI 22 (level, low) -> IRQ 209 
AAC0: kernel 4.0.4 build 5770 
AAC0: monitor 4.0.4 build 5770 
AAC0: bios 4.0.0 build 5770 
AAC0: serial ba2b1bfafaf001 
AAC0: Non-DASD support enabled. 
aacraid:        NMI ISR: NMI_PRIMARY_ATU_ERROR 
scsi0 : aacraid 
  Vendor: ADAPTEC   Model: Adaptec RAID5     Rev: V1.0 
  Type:   Direct-Access                      ANSI SCSI revision: 02 
SCSI device sda: 287105024 512-byte hdwr sectors (146998 MB) 
sda: Write Protect is off 
sda: Mode Sense: 03 00 00 00 
SCSI device sda: drive cache: write through 
 sda: sda1 sda2 
Attached scsi removable disk sda at scsi0, channel 0, id 0, lun 0 
  Vendor: ADAPTEC   Model: Adaptec Volume    Rev: V1.0 
  Type:   Direct-Access                      ANSI SCSI revision: 02 
SCSI device sdb: 143552512 512-byte hdwr sectors (73499 MB) 
sdb: Write Protect is off 
sdb: Mode Sense: 03 00 00 00 
SCSI device sdb: drive cache: write through 
 sdb: sdb1 sdb2 
Attached scsi removable disk sdb at scsi0, channel 0, id 1, lun 0 
Capability LSM initialized 
 
 
ACPI: PCI interrupt 0000:02:0c.0[A] -> GSI 20 (level, low) -> IRQ 217 
sym0: <895> rev 0x1 at pci 0000:02:0c.0 irq 217 
md: Autodetecting RAID arrays. 
sym0: Tekram NVRAM, ID 15, Fast-40, LVD, parity checking 
sym0: SCSI BUS has been reset. 
scsi1 : sym-2.1.18j 
md: autorun ... 
md: ... autorun DONE. 
device-mapper: 4.1.0-ioctl (2003-12-10) initialised: dm@uk.sistina.com 
evdev_connect: evdev cde12780 handle cde1279c name event0 
evdev_connect: evdev cde12580 handle cde1259c name event1 
evdev_connect: evdev cde6aa80 handle cde6aa9c name event2 
  Vendor: HP        Model: Ultrium 1-SCSI    Rev: N27D 
  Type:   Sequential-Access                  ANSI SCSI revision: 03 
scsi(1:0:5:0): Beginning Domain Validation 
scsi(1:0:5:0): Ending Domain Validation 
hw_random hardware driver 1.0.0 loaded 
Attached scsi generic sg0 at scsi0, channel 0, id 0, lun 0,  type 0 
Attached scsi generic sg1 at scsi0, channel 0, id 1, lun 0,  type 0 
Attached scsi generic sg2 at scsi1, channel 0, id 5, lun 0,  type 1 
 
 
  
st: Version 20040403, fixed bufsize 32768, s/g segs 256 
Attached scsi tape st0 at scsi1, channel 0, id 5, lun 0 
st0: try direct i/o: yes (alignment 512 B), max page reachable by HBA 
1048575 
subfs 0.9 
 
  
 
 

-- 
+++ Sparen Sie mit GMX DSL +++ http://www.gmx.net/de/go/dsl
AKTION für Wechsler: DSL-Tarife ab 3,99 EUR/Monat + Startguthaben
