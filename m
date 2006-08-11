From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: bogus error handling in qla2x00_iospace_config
Date: Fri, 11 Aug 2006 11:10:51 -0700
Message-ID: <20060811181051.GG4053@andrew-vasquezs-computer.local>
References: <20060811174425.GA32639@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:4404 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S1750907AbWHKSKz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Aug 2006 14:10:55 -0400
Content-Disposition: inline
In-Reply-To: <20060811174425.GA32639@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olh@suse.de>
Cc: linux-scsi@vger.kernel.org

On Fri, 11 Aug 2006, Olaf Hering wrote:

> the oops below was reported from a user with a qla card in an Apple
> Xserve G5. I have to check if the request_region() is obsolete with
> current kernels, but the qla driver should not crash either way.
> 
> https://bugzilla.novell.com/show_bug.cgi?id=195931
> .
> Linux agpgart interface v0.101 (c) Dave Jones
> agpgart: Detected Apple U3H chipset
> agpgart: configuring for size idx: 64
> agpgart: AGP aperture is 256M @ 0x0
> QLogic Fibre Channel HBA Driver
> PCI: Enabling device: (0001:06:02.0), cmd 7
> PCI: Unable to reserve I/O region #1:100@0 for device 0001:06:02.0
> qla2xxx 0001:06:02.0: Failed to reserve PIO/MMIO regions (0001:06:02.0)
> Unable to handle kernel paging request for data at address 0x00000000
> Faulting instruction address: 0xd0000000004e163c
> Oops: Kernel access of bad area, sig: 11 [#1]
> SMP NR_CPUS=128 NUMA POWERMAC 
> Modules linked in: qla2xxx scsi_transport_fc uninorth_agp agpgart firmware_class
>  tg3 snd_powermac snd_pcm snd_page_alloc snd_timer snd soundcore sbp2 ohci1394
> sg ieee1394 sata_svw libata sd_mod scsi_mod
> NIP: D0000000004E163C LR: D0000000004C16AC CTR: 0000000000000001

This issue was addressed in a more recent driver version (post 2.6.16,
the kernel the bugzilla was logged against).

here's the commit SHA1: 4971cd221ad3f1266b87aa0e996d082d91bac2a6 

--
Andrew
