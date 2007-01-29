From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] remove duplicate device id from IPR driver
Date: Mon, 29 Jan 2007 13:59:11 -0600
Message-ID: <45BE520F.4050507@linux.vnet.ibm.com>
References: <20070126021503.GB3444@kroah.com>
Reply-To: brking@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:47385 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579AbXA2T7P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Jan 2007 14:59:15 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0TJxDcg029071
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jan 2007 14:59:13 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0TJxDgt305754
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jan 2007 14:59:13 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0TJxCpG008148
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jan 2007 14:59:13 -0500
In-Reply-To: <20070126021503.GB3444@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: brking@us.ibm.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

Greg KH wrote:
> From: Greg Kroah-Hartman <gregkh@suse.de>
> 
> This patch removes a duplicate device id from the IPR driver.  Based on
> the ipr.h file, I'm not so sure this was intended to be a duplicate, and
> if so, the .h file should be modified to use the proper sub-device id
> instead.

ACK.

I double checked the subsystem ids and this patch is indeed the correct
fix. It turns out both of these adapters have the same subsystem ids,
which I didn't realize initially.

Thanks,

Brian

> 
> This was pointed out to me by Kay Sievers <kay.sievers@suse.de>
> 
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/scsi/ipr.c |    3 ---
>  1 file changed, 3 deletions(-)
> 
> --- gregkh-2.6.orig/drivers/scsi/ipr.c
> +++ gregkh-2.6/drivers/scsi/ipr.c
> @@ -7558,9 +7558,6 @@ static struct pci_device_id ipr_pci_tabl
>  	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN,
>  	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_575C,
>  	      0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
> -	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN,
> -	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B8,
> -	      0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
>  	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN_E,
>  	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B7,
>  	      0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
