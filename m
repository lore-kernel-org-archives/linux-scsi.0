From: Thomas Babut <thomas@babut.net>
Subject: Re: Kernel 2.6.x hangs with Symbios Logic 53c1010 Ultra3 SCSI Adapter
Date: Fri, 05 Nov 2004 14:59:25 +0100
Message-ID: <418B873D.30305@babut.net>
References: <418B7790.3060905@babut.net> <20041105134331.GV24690@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tueddeln.de ([217.160.187.172]:4026 "EHLO
	p15131177.pureserver.info") by vger.kernel.org with ESMTP
	id S262693AbUKEN70 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Nov 2004 08:59:26 -0500
In-Reply-To: <20041105134331.GV24690@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

Matthew Wilcox wrote:
> On Fri, Nov 05, 2004 at 01:52:32PM +0100, Thomas Babut wrote:
> Sounds like your drive isn't negotiating the correct transfer rate.
> If it's able to do 30MB/s, I guess it should be negotiating at least
> wide, 20MHz -- 5MB/s sounds like asynchronous.
dmesg output from Kernel 2.6.9 with the drivers from 2.6.1:

Nov  5 03:30:07 srv kernel: sym0: Symbios NVRAM, ID 7, Fast-80, LVD,
parity checking
Nov  5 03:30:07 srv kernel: sym0: open drain IRQ line driver, using
on-chip SRAM
Nov  5 03:30:07 srv kernel: sym0: using LOAD/STORE-based firmware.
Nov  5 03:30:07 srv kernel: sym0: handling phase mismatch from SCRIPTS.
Nov  5 03:30:07 srv kernel: sym0: SCSI BUS has been reset.
Nov  5 03:30:07 srv kernel: scsi0 : sym-2.1.18f
Nov  5 03:30:07 srv kernel: Using anticipatory io scheduler
Nov  5 03:30:07 srv kernel:   Vendor: QUANTUM   Model: ATLAS10K2-TY367J
  Rev: DDD6
Nov  5 03:30:07 srv kernel:   Type:   Direct-Access
  ANSI SCSI revision: 03
Nov  5 03:30:07 srv kernel: sym0:2:0: tagged command queuing enabled,
command queue depth 4.
Nov  5 03:30:07 srv kernel: sym0:2:0:M_REJECT to send for : 1-3-1-9-1f.
Nov  5 03:30:07 srv kernel: sym1: <1010-33> rev 0x1 at pci 0000:00:08.1
irq 11
Nov  5 03:30:07 srv kernel: sym1: Symbios NVRAM, ID 7, Fast-80, LVD,
parity checking
Nov  5 03:30:07 srv kernel: sym1: open drain IRQ line driver, using
on-chip SRAM
Nov  5 03:30:07 srv kernel: sym1: using LOAD/STORE-based firmware.
Nov  5 03:30:07 srv kernel: sym1: handling phase mismatch from SCRIPTS.
Nov  5 03:30:07 srv kernel: sym1: SCSI BUS has been reset.
Nov  5 03:30:07 srv kernel: scsi1 : sym-2.1.18f
Nov  5 03:30:07 srv kernel: SCSI device sda: 71721820 512-byte hdwr
sectors (36722 MB)
Nov  5 03:30:07 srv kernel: SCSI device sda: drive cache: write back
Nov  5 03:30:07 srv kernel:  sda: sda1 sda2
Nov  5 03:30:07 srv kernel: Attached scsi disk sda at scsi0, channel 0,
id 2, lun 0

> 
> Can you turn on negotiation debugging and send me the result?  If you
> have 2.1.18m, that's sym53c8xx.debug=0x200 ... earlier than that, it's
> sym53c8xx=debug:0x200
Sorry, I can't because this a dedicated server. :(

>>sym0: SCSI BUS reset detected.
>>sym0: SCSI BUS has been reset.
>>sym0: SCSI BUS operation completed.
>>
>>At this point only a hard-reset helps.
> 
> 
> Do you mean the machine freezes at this point, or you can't boot because
> this drive has your root partition on it and it can't be found?  If the
> former, this is another bug that needs to be fixed.

I've got two screenshots from the local administrator:
http://tomek.tueddeln.de/screenshot1.jpg
http://tomek.tueddeln.de/screenshot2.jpg

Btw: Where can I get the newest sym53c8xx_2 driver?

Thanks.

Regards,
Thomas Babut

