From: "Patro, Sumant" <Sumant.Patro@lsil.com>
Subject: RE: [Patch 1/6] megaraid_sas: FW transition and q size changes
Date: Wed, 4 Oct 2006 18:44:16 -0600
Message-ID: <0631C836DBF79F42B5A60C8C8D4E822971ABDF@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:55435 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751271AbWJEAoi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Oct 2006 20:44:38 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, hch@lst.de, linux-kernel@vger.kernel.org

Hello James,

	I will do the clean up and check before submitting patches next
time.	

Regards,

Sumant 

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
Sent: Wednesday, October 04, 2006 10:56 AM
To: Patro, Sumant
Cc: linux-scsi@vger.kernel.org; akpm@osdl.org; hch@lst.de;
linux-kernel@vger.kernel.org
Subject: Re: [Patch 1/6] megaraid_sas: FW transition and q size changes

On Tue, 2006-10-03 at 12:28 -0700, Sumant Patro wrote:
> Resubmitting with one addition (item f mentioned below)
> 
> This patch has the following enhancements :
>         a. handles new transition states of FW to support controller
hotplug. 
>         b. It reduces by 1 the maximum cmds that the driver may send
to FW. 
>         c. Sends "Stop Processing" cmd to FW before returning failure
from reset routine
>         d. Adds print in megasas_transition routine
>         e. Sends "RESET" flag to FW to do a soft reset of controller 
> to move from Operational to Ready state.
> 	f. Sending correct pointer (cmd->sense) to pci_pool_free
>           
>         This patch has been generated on latest scsi-misc git.
> 
> Signed-off-by: Sumant Patro <Sumant.Patro@lsil.com>

Every one of these patches had extra whitespace at the end of several
lines.  This is a sample from the first patch:

Adds trailing whitespace.
.dotest/patch:21:       if (fw_state != MFI_STATE_READY) 
Adds trailing whitespace.
.dotest/patch:44:               case MFI_STATE_BOOT_MESSAGE_PENDING:
Adds trailing whitespace.
.dotest/patch:85:        * Reduce the max supported cmds by 1. This is
to ensure that the 

Could you please try to ensure it doesn't happen in future ... it's time
consuming to clean it all up again.

Thanks,

James


