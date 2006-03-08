From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: dc395x.c: Please, contact ... to help improve support ...
Date: Wed, 8 Mar 2006 21:30:06 +0100 (CET)
Message-ID: <Pine.LNX.4.60.0603082114410.8414@poirot.grange>
References: <200603081336.37840.Sebastian@schnapsleichen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:15495 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1750720AbWCHUaH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2006 15:30:07 -0500
In-Reply-To: <200603081336.37840.Sebastian@schnapsleichen.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Frei <Sebastian@schnapsleichen.de>
Cc: linux-scsi@vger.kernel.org

On Wed, 8 Mar 2006, Sebastian Frei wrote:

> I got during a backup the following messages in the system log:
> 
> Mar  8 03:44:08 PINGUIN dc395x: sg_update_list: sg_to_virt failed
> Mar  8 03:44:08 PINGUIN dc395x: sg_update_list: sg_to_virt failed
> Mar  8 03:44:08 PINGUIN drivers/scsi/dc395x.c: Please, contact 
> <linux-scsi@vger.kernel.org> to help improve support
> for your system.

Thanks for writing! You are the second one. The short background why this 
message was put in the driver - there is a known bug in the driver, which 
is hard to trigger, so, we couldn't test our bugfixes. Now that you wrote 
to the list, I see that you also have a 64-bit system, as well as the 
first reporter. Unlike him, you have a tape-drive on the bus, he had a 
scanner. But in both cases it's not a block device - whether or not that 
is relevant. For comparison - on my 32-bit system neither a scanner nor a 
tape trigger this path.

> It is an opteron, 1GB RAM, a Tekram DC-315U controller with a HP DDS4 tape 
> drive, connected with a narrow->wide SCSI adaptor.
> 
> Some info:
> 
> Linux PINGUIN 2.6.15.6 #15 Mon Mar 6 11:30:52 CET 2006 x86_64 x86_64 x86_64 
> GNU/Linux
> 
> Mar  7 19:31:01 PINGUIN dc395x: Tekram DC395(U/UW/F), DC315(U) - ASIC 
> TRM-S1040 v2.05, 2004/03/08
> Mar  7 19:31:01 PINGUIN GSI 19 sharing vector 0xC1 and IRQ 19
> Mar  7 19:31:01 PINGUIN ACPI: PCI Interrupt 0000:00:0e.0[A] -> GSI 19 (level, 
> low) -> IRQ 19
> Mar  7 19:31:01 PINGUIN dc395x: Used settings: AdapterID=07, Speed=0(20.0MHz), 
> dev_mode=0x57
> Mar  7 19:31:01 PINGUIN dc395x:                AdaptMode=0x0f, Tags=4(16), 
> DelayReset=1s
> Mar  7 19:31:01 PINGUIN dc395x: Connectors: int50  Termination: Auto Low High
> Mar  7 19:31:01 PINGUIN dc395x: Performing initial SCSI bus reset
> Mar  7 19:31:01 PINGUIN scsi0 : Tekram DC395(U/UW/F), DC315(U) - ASIC 
> TRM-S1040 v2.05, 2004/03/08
> Mar  7 19:31:01 PINGUIN dc395x: Target 03:  Sync: 48ns Offset 15 (20.8 MB/s)
> Mar  7 19:31:01 PINGUIN Vendor: HP        Model: C5683A            Rev: C111
> Mar  7 19:31:01 PINGUIN Type:   Sequential-Access                  ANSI SCSI 
> revision: 02
> Mar  7 19:31:01 PINGUIN st: Version 20050830, fixed bufsize 1048576, s/g segs 
> 256
> Mar  7 19:31:01 PINGUIN st 0:0:3:0: Attached scsi tape st0<4>st0: try direct 
> i/o: yes (alignment 512 B), max page re
> achable by HBA 1048575

Do you have those messages "sg_to_virt failed" reproducibly? Does the tape 
work after that?

> Some things I should do ?

Sure. If you have some spare time to test a couple of patches we could try 
some patches. I think, we annoyed the list enough with the first reporter, 
so, we can as well take it off-list. The first reporter seems to have no 
time for further testing at the moment, so, if you want to play with the 
driver a bit just reply off-list to me.

Thanks
Guennadi
---
Guennadi Liakhovetski
