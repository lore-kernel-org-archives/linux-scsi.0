From: Orion Poplawski <orion@cora.nwra.com>
Subject: sym53c8xx scsi errors
Date: Thu, 11 Dec 2003 09:19:58 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <bra5fm$6gj$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.224.249]:27282 "EHLO main.gmane.org")
	by vger.kernel.org with ESMTP id S265163AbTLKQao (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Dec 2003 11:30:44 -0500
Received: from root by main.gmane.org with local (Exim 3.35 #1 (Debian))
	id 1AUTi6-0005a3-00
	for <linux-scsi@vger.kernel.org>; Thu, 11 Dec 2003 17:30:42 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I was hoping someone might be able to explain the cause of the two scsi 
errors at the end of this log output.  These errors occured at boot, but 
I haven't seen any other errors.  System appears to be working fine 
otherwise, but I'm concerned.

Linux kernel version 2.4.22.

Thanks!

  - Orion

Dec 10 17:43:04 saga kernel: sym.4.3.0: setting PCI_COMMAND_PARITY...
Dec 10 17:43:04 saga kernel: sym.4.3.1: setting PCI_COMMAND_PARITY...
Dec 10 17:43:04 saga kernel: sym0: <1010-33> rev 0x1 on pci bus 4 device 
3 function 0 irq 18
Dec 10 17:43:04 saga kernel: sym0: using 64 bit DMA addressing
Dec 10 17:43:04 saga kernel: sym0: Symbios NVRAM, ID 7, Fast-80, LVD, 
parity checking
Dec 10 17:43:04 saga kernel: sym0: open drain IRQ line driver, using 
on-chip SRAM
Dec 10 17:43:04 saga kernel: sym0: using LOAD/STORE-based firmware.
Dec 10 17:43:04 saga kernel: sym0: handling phase mismatch from SCRIPTS.
Dec 10 17:43:04 saga kernel: sym0: SCSI BUS has been reset.
Dec 10 17:43:04 saga kernel: sym1: <1010-33> rev 0x1 on pci bus 4 device 
3 function 1 irq 18
Dec 10 17:43:04 saga kernel: sym1: using 64 bit DMA addressing
Dec 10 17:43:04 saga kernel: sym1: Symbios NVRAM, ID 7, Fast-80, SE, 
parity checking
Dec 10 17:43:04 saga kernel: sym1: open drain IRQ line driver, using 
on-chip SRAM
Dec 10 17:43:04 saga kernel: sym1: using LOAD/STORE-based firmware.
Dec 10 17:43:04 saga kernel: sym1: handling phase mismatch from SCRIPTS.
Dec 10 17:43:04 saga kernel: sym1: SCSI BUS has been reset.
Dec 10 17:43:04 saga kernel: scsi2 : sym-2.1.17a
Dec 10 17:43:04 saga kernel: scsi3 : sym-2.1.17a
Dec 10 17:43:05 saga kernel: sym0:0:0: tagged command queuing enabled, 
command queue depth 16.
Dec 10 17:43:05 saga kernel: sym0:1:0: tagged command queuing enabled, 
command queue depth 16.
Dec 10 17:43:05 saga kernel: sym0:2:0: tagged command queuing enabled, 
command queue depth 16.
Dec 10 17:43:05 saga kernel: sym0:3:0: tagged command queuing enabled, 
command queue depth 16.
Dec 10 17:43:05 saga kernel: sym0:8:0: tagged command queuing enabled, 
command queue depth 16.
Dec 10 17:43:05 saga kernel: sym0:9:0: tagged command queuing enabled, 
command queue depth 16.
Dec 10 17:43:05 saga kernel: sym0:0: FAST-20 WIDE SCSI 40.0 MB/s ST 
(50.0 ns, offset 15)
Dec 10 17:43:05 saga kernel: sym0:1: FAST-20 WIDE SCSI 40.0 MB/s ST 
(50.0 ns, offset 31)
Dec 10 17:43:05 saga kernel: sym0:2: FAST-20 WIDE SCSI 40.0 MB/s ST 
(50.0 ns, offset 31)
Dec 10 17:43:05 saga kernel: sym0:3: FAST-20 WIDE SCSI 40.0 MB/s ST 
(50.0 ns, offset 15)
Dec 10 17:43:05 saga kernel: sym0:8: FAST-20 WIDE SCSI 40.0 MB/s ST 
(50.0 ns, offset 31)
Dec 10 17:43:05 saga kernel: sym0:9: FAST-20 WIDE SCSI 40.0 MB/s ST 
(50.0 ns, offset 31)
Dec 10 17:43:05 saga kernel: sym53c8xx: at PCI bus 4, device 3, function 0
Dec 10 17:43:05 saga kernel: sym53c8xx: IO region 0x4000[0..127] is in use
Dec 10 17:43:05 saga kernel: sym0:9: ERROR (0:8) (0-0-0) (1f/38/0) @ 
(scripta 3c0:50000000).
Dec 10 17:43:05 saga kernel: sym0: script cmd = 80000000
Dec 10 17:43:05 saga kernel: sym0: regdump: da 00 00 38 47 1f 09 0f 04 
08 89 00 80 00 0f 0a ff 10 46 37 02 00 00 00.
Dec 10 17:43:05 saga kernel: sym53c8xx: at PCI bus 4, device 3, function 1
Dec 10 17:43:05 saga kernel: sym53c8xx: IO region 0x4400[0..127] is in use
Dec 10 17:43:05 saga kernel: sym0: SCSI BUS reset detected.
Dec 10 17:43:05 saga kernel: sym0: SCSI BUS has been reset.
Dec 10 17:43:05 saga kernel: sym1:15: ERROR (0:8) (0-0-0) (0/0/0) @ 
(scripta 3c0:50000000).
Dec 10 17:43:05 saga kernel: sym1: script cmd = 80000000
Dec 10 17:43:05 saga kernel: sym1: regdump: da 00 00 00 47 00 0f 0f 00 
08 00 00 80 00 08 0a ff c0 45 37 00 00 00 00.
Dec 10 17:43:05 saga kernel: sym1: SCSI BUS reset detected.
Dec 10 17:43:05 saga kernel: sym1: SCSI BUS has been reset.


