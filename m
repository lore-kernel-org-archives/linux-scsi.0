From: "Mukker, Atul" <Atulm@lsil.com>
Subject: RE: old and new megaraid drivers for linux
Date: Fri, 17 Dec 2004 09:00:09 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57058BFB6D@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:58613 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261182AbULQOAN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Dec 2004 09:00:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Greg Stitt' <gstitt@gmail.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

Can you send as an attachment the 2.00.3 driver information using files from
/proc/megaraid directory and the dmesg output for the PERC controller. Also
the output from "lspci -vx" command. Let us see if this controller can be
safely added in the 2.20 driver.

Thanks

---
Atul Mukker
Architect, Drivers and BIOS
LSI Logic Corporation

> -----Original Message-----
> From: Greg Stitt [mailto:gstitt@gmail.com] 
> Sent: Thursday, December 16, 2004 9:59 PM
> To: linux-scsi@vger.kernel.org
> Subject: old and new megaraid drivers for linux
> 
> Hello,
> 
> I currently have a system with both a PERC2/SC, and a 
> recently added MegaRAID SATA 150-6.
> 
> The PERC2/SC ran fine with the 'old style' megaraid driver (2.00.3). 
> However, the SATA card has issues with this driver, as I can't even
> format the drives without problems.   Under Windows 2003, both cards
> operate fine, so I don't believe this is a hardware issue.
> 
> I tried the new megaraid driver (2.20.4.0), but it doesn't 
> recognize the PERC at all.  Not sure how stable it is with 
> the SATA though, as the PERC contains all the OS. :-)
> 
> This was tried using the 2.6.9 linux kernel.
> 
> I've seen mention of this issue before on this list, but has 
> anything been done since then to resolve this?
> 
> Thanks
> Greg Stitt
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in the body of a message to 
> majordomo@vger.kernel.org More majordomo info at  
> http://vger.kernel.org/majordomo-info.html
> 
