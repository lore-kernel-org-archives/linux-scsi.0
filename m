From: Thomas Babut <thomas@babut.net>
Subject: Re: Kernel 2.6.x hangs with Symbios Logic 53c1010 Ultra3 SCSI Adapter
Date: Fri, 05 Nov 2004 17:07:17 +0100
Message-ID: <418BA535.5070403@babut.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tueddeln.de ([217.160.187.172]:56251 "EHLO
	p15131177.pureserver.info") by vger.kernel.org with ESMTP
	id S262714AbUKEQHS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Nov 2004 11:07:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: matthew@wil.cx

I've tried now Kernel 2.6.10-rc1-bk15 with following two patches:
http://marc.theaimsgroup.com/?l=linux-scsi&m=109840610525441&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=109844985008496&w=2

The patches applied perfectly. But the system doesn't boot up.

I've tried also on the working Kernel 2.6.9 (with drivers from 2.6.1) to 
set the following bootparams: sym53c8xx=sync:10

But it didn't change anything. Same poor performance as before.

Did I set this wrong? What would be the right way to set the speed manually?

Here is a dmesg output from 2.4.27 with normal performance (30 MB/s):

sym53c8xx: at PCI bus 0, device 8, function 0
sym53c8xx: setting PCI_COMMAND_PARITY...(fix-up)
sym53c8xx: 53c1010-33 detected with Symbios NVRAM
sym53c8xx: at PCI bus 0, device 8, function 1
sym53c8xx: setting PCI_COMMAND_PARITY...(fix-up)
sym53c8xx: 53c1010-33 detected with Symbios NVRAM
sym53c1010-33-0: rev 0x1 on pci bus 0 device 8 function 0 irq 9
sym53c1010-33-0: Symbios format NVRAM, ID 7, Fast-80, Parity Checking
sym53c1010-33-0: on-chip RAM at 0xf9000000
sym53c1010-33-0: restart (scsi reset).
sym53c1010-33-0: handling phase mismatch from SCRIPTS.
sym53c1010-33-0: Downloading SCSI SCRIPTS.
sym53c1010-33-1: rev 0x1 on pci bus 0 device 8 function 1 irq 11
sym53c1010-33-1: Symbios format NVRAM, ID 7, Fast-80, Parity Checking
sym53c1010-33-1: on-chip RAM at 0xf8000000
sym53c1010-33-1: restart (scsi reset).
sym53c1010-33-1: handling phase mismatch from SCRIPTS.
sym53c1010-33-1: Downloading SCSI SCRIPTS.
scsi0 : sym53c8xx-1.7.3c-20010512
scsi1 : sym53c8xx-1.7.3c-20010512
blk: queue f7e9bc18, I/O limit 1048575Mb (mask 0xffffffffff)
   Vendor: QUANTUM   Model: ATLAS10K2-TY367J  Rev: DDD6
   Type:   Direct-Access                      ANSI SCSI revision: 03
blk: queue f7e9ba18, I/O limit 1048575Mb (mask 0xffffffffff)
sym53c1010-33-0-<2,0>: tagged command queue depth set to 4
Attached scsi disk sda at scsi0, channel 0, id 2, lun 0
sym53c1010-33-0-<2,*>: FAST-40 SCSI 40.0 MB/s (25.0 ns, offset 31)
SCSI device sda: 71721820 512-byte hdwr sectors (36722 MB)
Partition check:
  sda: sda1 sda2

Thanks.

Regards,
Thomas Babut
