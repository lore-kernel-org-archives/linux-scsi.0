From: nico <nico@mandrakesoft.com>
Subject: U160 on sym53c8xx very slow
Date: Mon, 20 Oct 2003 15:02:47 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <pan.2003.10.20.13.02.47.426779@mandrakesoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.224.249]:52657 "EHLO main.gmane.org")
	by vger.kernel.org with ESMTP id S262558AbTJTNKb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Oct 2003 09:10:31 -0400
Received: from root by main.gmane.org with local (Exim 3.35 #1 (Debian))
	id 1ABZno-0007JB-00
	for <linux-scsi@vger.kernel.org>; Mon, 20 Oct 2003 15:10:28 +0200
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I have very poor performance with my Ultra160 disks (fujitsu MAN3184MP,
10000rpms).
When I copy a reasonably large (500MB) file from /dev/sda2 to /dev/sda3,
it copies at a rate of 10-20 MB/sec maximum.
I was expecting better troughput.

Here is the result of a dmesg:


----------------------
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
PCI: Found IRQ 11 for device 0000:00:08.0
PCI: Sharing IRQ 11 with 0000:00:07.2
PCI: Sharing IRQ 11 with 0000:00:07.3
PCI: Sharing IRQ 11 with 0000:00:0b.0
sym0: <1010-33> rev 0x1 at pci 0000:00:08.0 irq 11
sym0: using 64 bit DMA addressing
sym0: Symbios NVRAM, ID 7, Fast-80, SE, parity checking
sym0: open drain IRQ line driver, using on-chip SRAM
sym0: using LOAD/STORE-based firmware.
sym0: handling phase mismatch from SCRIPTS.
sym0: SCAN AT BOOT disabled for targets 0 1 2 3 4 5 8 9 10 11 12 13 14 15.
sym0: SCAN FOR LUNS disabled for targets 0 1 2 3 4 5 6 8 9 10 11 12 13 14 15.
sym0: SCSI BUS has been reset.
scsi0 : sym-2.1.18b
  Vendor: FUJITSU   Model: MAN3184MP         Rev: 0108
  Type:   Direct-Access                      ANSI SCSI revision: 03
sym0:6:0: tagged command queuing enabled, command queue depth 16.
PCI: Found IRQ 15 for device 0000:00:08.1
PCI: Sharing IRQ 15 with 0000:00:0d.0
PCI: Sharing IRQ 15 with 0000:00:0f.0
sym1: <1010-33> rev 0x1 at pci 0000:00:08.1 irq 15
sym1: using 64 bit DMA addressing
sym1: Symbios NVRAM, ID 2, Fast-80, SE, parity checking
sym1: open drain IRQ line driver, using on-chip SRAM
sym1: using LOAD/STORE-based firmware.
sym1: handling phase mismatch from SCRIPTS.
sym1: SCAN AT BOOT disabled for targets 0 1 3 4 5 6 7 8 9 10 11 12 13 14 15.
sym1: SCAN FOR LUNS disabled for targets 0 1 3 4 5 6 7 8 9 10 11 12 13 14 15.
sym1: SCSI BUS has been reset.
sym1: SCSI BUS mode change from SE to SE.
sym1: SCSI BUS has been reset.
scsi1 : sym-2.1.18b
sym0:6:0:M_REJECT to send for : 1-6-4-c-0-3e-1-0.
sym0:6:0:M_REJECT received (7:8).
sym0:6: FAST-20 WIDE SCSI 40.0 MB/s ST (50.0 ns, offset 31)
SCSI device sda: 35885448 512-byte hdwr sectors (18373 MB)
SCSI device sda: drive cache: write back
 sda: sda1 sda2 < sda5 sda6 sda7 sda8 sda9 sda10 sda11 sda12 sda13 >
Attached scsi disk sda at scsi0, channel 0, id 6, lun 0
Attached scsi generic sg0 at scsi0, channel 0, id 6, lun 0,  type 0

----------------------


Something wrong with my configuration? Is it a setting of my adapter
(Tekram DC-390-U3W) that is wrong? Should I plug it on another pci slot?
Else?


Thank you very much for your help.

BTW: it's a 2,6,0-test8 on a debian unstable.

