From: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Subject: RE: Hang problem on Dell 1850 and 2850 using  Perc megaraid controller
Date: Mon, 6 Feb 2006 12:19:04 -0700
Message-ID: <9738BCBE884FDB42801FAD8A7769C265142053@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:16536 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932290AbWBFTUL convert rfc822-to-8bit
	(ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
	Mon, 6 Feb 2006 14:20:11 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Wilhelmi <joe@rtlogic.com>, Linux-scsi@vger.kernel.org

Hi,

> Also, I attempted to produce the problem using a MegaRAID SCSI-320-2x
> card with the same RAID 1 configuration with the same OS and 
> version of
> the driver.  The hang did not occur.
Can you elaborate which PERC4 controller are on both 1850 and 2850?
Do both PERC4 controllers have PCI-X interface as MegaRAID SCSI-320-2X?
 
> It seems that the issue is in some part of the MegaRAID driver that
> deals specifically with the Perc cards in the 2850 and the 
> 1850 and not
> with the LSI MegaRAID cards.
> 
> I need to mention that the kernel has been built with MSI and ACPI
> disabled because of issues with our e1000 ethernet adapter.  Because
> ACPI was disabled, we also disabled hw_random.  Snare is also 
> built in.
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
> controller and fusion driver instead of MegaRAID, this issue 
> goes away:
> I can copy the 580MB of data without the hang.
> 
> Also, I attempted to produce the problem using a MegaRAID SCSI-320-2x
> card with the same RAID 1 configuration with the same OS and 
> version of
> the driver.  The hang did not occur.
> 
> It seems that the issue is in some part of the MegaRAID driver that
> deals specifically with the Perc cards in the 2850 and the 
> 1850 and not
> with the LSI MegaRAID cards.
> 
> I need to mention that the kernel has been built with MSI and ACPI
> disabled because of issues with our e1000 ethernet adapter.  Because
> ACPI was disabled, we also disabled hw_random.  Snare is also 
> built in.
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
