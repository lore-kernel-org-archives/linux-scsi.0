From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 0/10] megaraid_sas: Updates for scsi-misc
Date: Sun, 09 Oct 2011 09:56:35 -0400
Message-ID: <4E91A813.1070003@interlog.com>
References: <CAHtARFGh5i6M8SMqjeUnpUP=dWNdwdmDhGo+z4h4qE8r18xhWA@mail.gmail.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:60278 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021Ab1JIN4m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Oct 2011 09:56:42 -0400
In-Reply-To: <CAHtARFGh5i6M8SMqjeUnpUP=dWNdwdmDhGo+z4h4qE8r18xhWA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

On 11-10-08 09:14 PM, adam radford wrote:
> James/Linux-scsi,
>
> The following patch series for megaraid_sas brings the driver up to v6.12-rc1:
>
> 1. Continue booting immediately if FW in FAULT at driver load time.
> 2. Increase default cmds per lun to 256.
> 3. Fix mismatch in megasas_reset_fusion() mutex lock-unlock.
> 4. Remove some un-necessary code.
> 5. Clear state change interrupts for Fusion/Invader.
> 6. Clear FUSION_IN_RESET before enabling interrupts.
> 7. Add support for MegaRAID 9360/9380 12GB/s controllers.
> 8. Add multiple MSI-X vector/multiple reply queue support.
> 9. Add driver workaround for PERC5/1068 kdump kernel panic.
> 10. Version and Changelog update.

I haven't checked all SAS HBAs in Linux but of those that I
have checked only one doesn't support the SMP pass-through
in the bsg driver. And that HBA driver is megaraid_sas **.

The SMP pass-through allows user space programs to monitor
and change advanced features in SAS expanders such as
zoning. SMP (Serial Management Protocol) is one of the three
SAS transport protocols defined by t10.org (the other two are
SSP and STP). All SAS HBAs, including MegaRaid SAS HBAs,
support SMP "under the covers" otherwise they would not be
able to discover disks connected via SAS expanders.

Doug Gilbert


** I'm not aware of any proprietary SMP pass-through interface
    accessible in Linux for megaraid_sas either


