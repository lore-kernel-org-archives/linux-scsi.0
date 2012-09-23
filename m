From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 47781] ata2: exception Emask 0x10 SAct 0x0 SErr 0x4050002
 action 0xe frozen
Date: Sun, 23 Sep 2012 21:54:10 +0000 (UTC)
Message-ID: <20120923215410.0FCF111FB49@bugzilla.kernel.org>
References: <bug-47781-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:38770 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520Ab2IWVyP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Sep 2012 17:54:15 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 450C7202C4
	for <linux-scsi@vger.kernel.org>; Sun, 23 Sep 2012 21:54:14 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 175F5202CA
	for <linux-scsi@vger.kernel.org>; Sun, 23 Sep 2012 21:54:10 +0000 (UTC)
In-Reply-To: <bug-47781-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=47781


Reartes Guillermo <rtguille@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |rtguille@gmail.com




--- Comment #5 from Reartes Guillermo <rtguille@gmail.com>  2012-09-23 21:54:09 ---
Controller #1:

<<<< SATA controller [0106]: Intel Corporation N10/ICH7 Family SATA Controller 
[AHCI mode] [8086:27c1] (rev 01) (prog-if 01 [AHCI 1.0]) >>>

ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: irq 45 for MSI/MSI-X
ahci 0000:00:1f.2: enabling ASUS P5W DH Deluxe on-board SIMG4726 workaround
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part 
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 abar m1024@0xfebfb800 port 0xfebfb900 irq 45
ata2: SATA max UDMA/133 abar m1024@0xfebfb800 port 0xfebfb980 irq 45
ata3: SATA max UDMA/133 abar m1024@0xfebfb800 port 0xfebfba00 irq 45
ata4: SATA max UDMA/133 abar m1024@0xfebfb800 port 0xfebfba80 irq 45

Controller #2:

<<< SATA controller [0106]: JMicron Technology Corp. JMB363 SATA/IDE Controller
[197b:2363] (rev 03) (prog-if 01 [AHCI 1.0]) >>>

ahci 0000:02:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
ahci 0000:02:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
scsi4 : ahci
scsi5 : ahci
ata5: SATA max UDMA/133 abar m8192@0xf87fe000 port 0xf87fe100 irq 17
ata6: SATA max UDMA/133 abar m8192@0xf87fe000 port 0xf87fe180 irq 17

Controller #3:

<<<  IDE interface [0101]: Intel Corporation 82801G (ICH7 Family) IDE
Controller
[8086:27df] (rev 01) (prog-if 8a [Master SecP PriP]) >>>

ata_piix 0000:00:1f.1: version 2.13
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi6 : ata_piix
scsi7 : ata_piix
ata7: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
ata8: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15

Controller #4 (PATA, SAME CARD as #2):

<<< IDE interface [0101]: JMicron Technology Corp. JMB363 SATA/IDE Controller
[197b:2363] (rev 03) (prog-if 85 [Master SecO PriO]) >>>

pata_acpi 0000:02:00.1: enabling device (0000 -> 0001)
pata_acpi 0000:02:00.1: setting latency timer to 64
scsi8 : pata_acpi
scsi9 : pata_acpi
ata9: PATA max UDMA/133 cmd 0xac00 ctl 0xa880 bmdma 0xa400 irq 18
ata10: PATA max UDMA/133 cmd 0xa800 ctl 0xa480 bmdma 0xa408 irq 18

ERRORS:

* ata2.00: failed to IDENTIFY (I/O error, err_mask=0x100)

* ata2.00: unsupported device, disabling

* ata10: prereset failed (errno=-19)
  ata10: reset failed, giving up

WARNINGS:

* WARNING#1: (For ATA6 & ATA7)

  pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it
with 'pcie_aspm=force'


* WARNING#2: 

  pci0000:00: ACPI _OSC support notification failed, disabling PCIe ASPM
  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)


* WARNING#3: 

  ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
  ata2.00: failed to IDENTIFY (I/O error, err_mask=0x100)
  ata2: SATA link down (SStatus 0 SControl 300)

  ata2: exception Emask 0x10 SAct 0x0 SErr 0x4050002 action 0xe frozen
  ata2: irq_stat 0x00000040, connection status changed
  ata2: SError: { RecovComm PHYRdyChg CommWake DevExch }
  ata2: hard resetting link
  ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
  ata2.00: unsupported device, disabling
  ata2.00: disabled
  ata2: EH complete

* WARNING#4:

  ata10: prereset failed (errno=-19)
  ata10: reset failed, giving up

* WARNING#5:

  ACPI: Invalid Power Resource to register!

  ACPI Warning: 0x00000295-0x00000296 SystemIO conflicts with Region
\_SB_.PCI0.SBRG.SIOR.HWRE 1 (20120711/utaddress-251)
  ACPI: If an ACPI driver is available for this device, you should use it
instead of the native driver

  ACPI Warning: 0x00000480-0x000004bf SystemIO conflicts with Region
\_SB_.PCI0.SBRG.GPIO 1 (20120711/utaddress-251)
  ACPI: If an ACPI driver is available for this device, you should use it
instead of the native driver

------------------------------------------------

What device is attached to ata2 and ata10?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
