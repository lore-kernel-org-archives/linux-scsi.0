From: Thomas Babut <thomas@babut.net>
Subject: Re: Kernel 2.6.x hangs with Symbios Logic 53c1010 Ultra3 SCSI	Adapter
Date: Fri, 19 Nov 2004 10:32:40 +0100
Message-ID: <419DBDB8.2010805@babut.net>
References: <04Nov8.094419est.332239@cyborg.cybernetics.com> <1099928314.10944.81.camel@compaq-rhel4.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tueddeln.de ([213.202.245.13]:29600 "EHLO srv.specialhosting.de")
	by vger.kernel.org with ESMTP id S261326AbUKSJcp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Nov 2004 04:32:45 -0500
In-Reply-To: <1099928314.10944.81.camel@compaq-rhel4.xsintricity.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

Hi all,

yesterday I tried some new Kernels...

2.4.28-bk1 with sym53c8xx: works with normal Performance
Bootlog:
Nov 19 01:31:39 srv kernel: SCSI subsystem driver Revision: 1.00
Nov 19 01:31:39 srv kernel: sym53c8xx: at PCI bus 0, device 8, function 0
Nov 19 01:31:39 srv kernel: sym53c8xx: setting PCI_COMMAND_PARITY...(fix-up)
Nov 19 01:31:39 srv kernel: sym53c8xx: 53c1010-33 detected with Symbios 
NVRAM
Nov 19 01:31:39 srv kernel: sym53c8xx: at PCI bus 0, device 8, function 1
Nov 19 01:31:39 srv kernel: sym53c8xx: setting PCI_COMMAND_PARITY...(fix-up)
Nov 19 01:31:39 srv kernel: sym53c8xx: 53c1010-33 detected with Symbios 
NVRAM
Nov 19 01:31:39 srv kernel: sym53c1010-33-0: rev 0x1 on pci bus 0 device 
8 function 0 irq 9
Nov 19 01:31:39 srv kernel: sym53c1010-33-0: Symbios format NVRAM, ID 7, 
Fast-80, Parity Checking
Nov 19 01:31:39 srv kernel: sym53c1010-33-0: on-chip RAM at 0xf9000000
Nov 19 01:31:39 srv kernel: sym53c1010-33-0: restart (scsi reset).
Nov 19 01:31:39 srv kernel: sym53c1010-33-0: handling phase mismatch 
from SCRIPTS.
Nov 19 01:31:39 srv kernel: sym53c1010-33-0: Downloading SCSI SCRIPTS.
Nov 19 01:31:39 srv kernel: sym53c1010-33-1: rev 0x1 on pci bus 0 device 
8 function 1 irq 11
Nov 19 01:31:39 srv kernel: sym53c1010-33-1: Symbios format NVRAM, ID 7, 
Fast-80, Parity Checking
Nov 19 01:31:39 srv kernel: sym53c1010-33-1: on-chip RAM at 0xf8000000
Nov 19 01:31:39 srv kernel: sym53c1010-33-1: restart (scsi reset).
Nov 19 01:31:39 srv kernel: sym53c1010-33-1: handling phase mismatch 
from SCRIPTS.
Nov 19 01:31:39 srv kernel: sym53c1010-33-1: Downloading SCSI SCRIPTS.
Nov 19 01:31:39 srv kernel: scsi0 : sym53c8xx-1.7.3c-20010512
Nov 19 01:31:39 srv kernel: scsi1 : sym53c8xx-1.7.3c-20010512
Nov 19 01:31:39 srv kernel: blk: queue f7e9a018, I/O limit 1048575Mb 
(mask 0xffffffffff)
Nov 19 01:31:39 srv kernel:   Vendor: QUANTUM   Model: ATLAS10K2-TY367J 
  Rev: DDD6
Nov 19 01:31:39 srv kernel:   Type:   Direct-Access 
  ANSI SCSI revision: 03
Nov 19 01:31:39 srv kernel: blk: queue f7e67e18, I/O limit 1048575Mb 
(mask 0xffffffffff)
Nov 19 01:31:39 srv kernel: sym53c1010-33-0-<2,0>: tagged command queue 
depth set to 8
Nov 19 01:31:39 srv kernel: Attached scsi disk sda at scsi0, channel 0, 
id 2, lun 0
Nov 19 01:31:39 srv kernel: sym53c1010-33-0-<2,*>: FAST-40 SCSI 40.0 
MB/s (25.0 ns, offset 31)
Nov 19 01:31:39 srv kernel: SCSI device sda: 71721820 512-byte hdwr 
sectors (36722 MB)
Nov 19 01:31:39 srv kernel: Partition check:
Nov 19 01:31:39 srv kernel:  sda: sda1 sda2

2.4.28-bk1 with sym53c8xx2: works, but poor performance (max. 5 MByte/s)
Bootlog:
Nov 19 01:27:19 srv kernel: SCSI subsystem driver Revision: 1.00
Nov 19 01:27:19 srv kernel: sym.0.8.0: setting PCI_COMMAND_PARITY...
Nov 19 01:27:19 srv kernel: sym.0.8.1: setting PCI_COMMAND_PARITY...
Nov 19 01:27:19 srv kernel: sym0: <1010-33> rev 0x1 on pci bus 0 device 
8 function 0 irq 9
Nov 19 01:27:19 srv kernel: sym0: using 64 bit DMA addressing
Nov 19 01:27:19 srv kernel: sym0: Symbios NVRAM, ID 7, Fast-80, LVD, 
parity checking
Nov 19 01:27:19 srv kernel: sym0: open drain IRQ line driver, using 
on-chip SRAM
Nov 19 01:27:19 srv kernel: sym0: using LOAD/STORE-based firmware.
Nov 19 01:27:19 srv kernel: sym0: handling phase mismatch from SCRIPTS.
Nov 19 01:27:19 srv kernel: sym0: SCSI BUS has been reset.
Nov 19 01:27:19 srv kernel: sym1: <1010-33> rev 0x1 on pci bus 0 device 
8 function 1 irq 11
Nov 19 01:27:19 srv kernel: sym1: using 64 bit DMA addressing
Nov 19 01:27:19 srv kernel: sym1: Symbios NVRAM, ID 7, Fast-80, LVD, 
parity checking
Nov 19 01:27:19 srv kernel: sym1: open drain IRQ line driver, using 
on-chip SRAM
Nov 19 01:27:19 srv kernel: sym1: using LOAD/STORE-based firmware.
Nov 19 01:27:19 srv kernel: sym1: handling phase mismatch from SCRIPTS.
Nov 19 01:27:19 srv kernel: sym1: SCSI BUS has been reset.
Nov 19 01:27:19 srv kernel: scsi0 : sym-2.1.17a
Nov 19 01:27:19 srv kernel: scsi1 : sym-2.1.17a
Nov 19 01:27:19 srv kernel: blk: queue f7e9a018, I/O limit 1048575Mb 
(mask 0xffffffffff)
Nov 19 01:27:19 srv kernel:   Vendor: QUANTUM   Model: ATLAS10K2-TY367J 
  Rev: DDD6
Nov 19 01:27:19 srv kernel:   Type:   Direct-Access 
  ANSI SCSI revision: 03
Nov 19 01:27:19 srv kernel: blk: queue f7e64e18, I/O limit 1048575Mb 
(mask 0xffffffffff)
Nov 19 01:27:19 srv kernel: sym0:2:0: tagged command queuing enabled, 
command queue depth 16.
Nov 19 01:27:19 srv kernel: Attached scsi disk sda at scsi0, channel 0, 
id 2, lun 0
Nov 19 01:27:19 srv kernel: sym0:2:0:M_REJECT to send for : 1-3-1-9-1f.
Nov 19 01:27:19 srv kernel: SCSI device sda: 71721820 512-byte hdwr 
sectors (36722 MB)
Nov 19 01:27:19 srv kernel: Partition check:
Nov 19 01:27:19 srv kernel:  sda: sda1 sda2

2.6.10-rc2-bk3 with sym53c8xx2: System doesn't come up, same errors as 
before
No bootlog because of the lack of physical access to the machine.

I still would like to run Kernel 2.6. :)

Regards,
Thomas Babut
