From: "Joe Wilhelmi" <joe@rtlogic.com>
Subject: RE: Hang problem on Dell 1850 and 2850 using  Perc megaraid controller
Date: Mon, 6 Feb 2006 13:27:45 -0700
Message-ID: <00c601c62b5b$ce1133d0$2301a8c0@whitney>
References: <9738BCBE884FDB42801FAD8A7769C265142053@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eagle.rtlogic.com ([216.87.68.236]:29323 "EHLO rtlogic.com")
	by vger.kernel.org with ESMTP id S964780AbWBFU2F (ORCPT
	<rfc822;Linux-scsi@vger.kernel.org>); Mon, 6 Feb 2006 15:28:05 -0500
In-Reply-To: <9738BCBE884FDB42801FAD8A7769C265142053@NAMAIL1.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'Ju, Seokmann'" <Seokmann.Ju@lsil.com>, Linux-scsi@vger.kernel.org

Hello,

The controllers in the 2850 and the 1850 are perc4/ei.  However I do not
know if they have the same PCI bridge chip as the Ultra-320-2X.  The
SCSI chip is an LSI 1030 which I believe is a pciX connection.  There is
also a Dobson on the motherboard that I believe connects over the PCIeX
interface.  I think the Dobson is related to the romb dimm.

Thanks for the help,
Joe

-----Original Message-----
From: Ju, Seokmann [mailto:Seokmann.Ju@lsil.com] 
Sent: Monday, February 06, 2006 12:19 PM
To: Joe Wilhelmi; Linux-scsi@vger.kernel.org
Subject: RE: Hang problem on Dell 1850 and 2850 using Perc megaraid
controller


Hi,

> Also, I attempted to produce the problem using a MegaRAID SCSI-320-2x 
> card with the same RAID 1 configuration with the same OS and version 
> of the driver.  The hang did not occur.
Can you elaborate which PERC4 controller are on both 1850 and 2850? Do
both PERC4 controllers have PCI-X interface as MegaRAID SCSI-320-2X?
 
> It seems that the issue is in some part of the MegaRAID driver that 
> deals specifically with the Perc cards in the 2850 and the 1850 and 
> not with the LSI MegaRAID cards.
> 
> I need to mention that the kernel has been built with MSI and ACPI 
> disabled because of issues with our e1000 ethernet adapter.  Because 
> ACPI was disabled, we also disabled hw_random.  Snare is also built 
> in.
>
> The following are the relevant firmware versions:
> Dell 1850 Perc Controller: H418
> Dell 2850 Perc Controller: H430
> Lsi Ultra-320-2X:          H409
Thank you for detail descriptin on the issue.
It will be duplicated and will update you as soon as possible.

Thank you,

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Joe Wilhelmi
> Sent: Monday, February 06, 2006 1:57 PM
> To: Linux-scsi@vger.kernel.org
> Subject: Hang problem on Dell 1850 and 2850 using Perc 
> megaraid controller
> 
> Friends of MegaRAID,
> 
> I have been noticing a hang problem on my 1850 and 2850 systems when 
> using the Perc4 controllers in a RAID 1 configuration using 
> LSI_COMMON_MOD_VERSION 2.20.2.6 on the linux 2.6.14 kernel.  I can 
> repeatedly reproduce the problem by copying about 580MB of data to the

> disk from an NFS share.
> 
> If I install my system in bios SCSI mode, which uses the LSI scsi 
> controller and fusion driver instead of MegaRAID, this issue goes 
> away: I can copy the 580MB of data without the hang.
> 
> Also, I attempted to produce the problem using a MegaRAID SCSI-320-2x 
> card with the same RAID 1 configuration with the same OS and version 
> of the driver.  The hang did not occur.
> 
> It seems that the issue is in some part of the MegaRAID driver that 
> deals specifically with the Perc cards in the 2850 and the 1850 and 
> not with the LSI MegaRAID cards.
> 
> I need to mention that the kernel has been built with MSI and ACPI 
> disabled because of issues with our e1000 ethernet adapter.  Because 
> ACPI was disabled, we also disabled hw_random.  Snare is also built 
> in.
> 
> 
> The following are the relevant firmware versions:
> Dell 1850 Perc Controller: H418
> Dell 2850 Perc Controller: H430
> Lsi Ultra-320-2X:          H409
> 
> I appreciate any help or thoughts,
> 
> Regards,
> Joe Wilhelmi
> RTLogic
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


