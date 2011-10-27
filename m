From: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Subject: Re: [RESEND][PATCH 1/1] ipr: add definitions for additional adapter
Date: Thu, 27 Oct 2011 11:42:39 -0700
Message-ID: <4EA9A61F.3030605@linux.vnet.ibm.com>
References: <20111019230016.134176494@linux.vnet.ibm.com> <4EA04B8E.9030909@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:41099 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754860Ab1J0SuC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Oct 2011 14:50:02 -0400
Received: from /spool/local
	by e4.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <wayneb@linux.vnet.ibm.com>;
	Thu, 27 Oct 2011 14:43:21 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p9RIgfrD255500
	for <linux-scsi@vger.kernel.org>; Thu, 27 Oct 2011 14:42:41 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p9RIge0q003596
	for <linux-scsi@vger.kernel.org>; Thu, 27 Oct 2011 16:42:41 -0200
In-Reply-To: <4EA04B8E.9030909@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>, Wendy Xiong <wenxiong@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>

This patch is not correct.  It will break support for the 57C4
adapter.  New patch to follow.

Wayne

On 10/20/2011 09:25 AM, Wayne Boyer wrote:
> Add the appropriate definitions and table entry for an additional adapter.
> 
> Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
> ---
>  drivers/scsi/ipr.c |    4 +++-
>  drivers/scsi/ipr.h |    1 +
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> Index: b/drivers/scsi/ipr.c
> ===================================================================
> --- a/drivers/scsi/ipr.c	2011-10-19 15:53:30.852967743 -0700
> +++ b/drivers/scsi/ipr.c	2011-10-19 15:56:17.363057868 -0700
> @@ -9114,8 +9114,10 @@ static struct pci_device_id ipr_pci_tabl
>  	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_FPGA_E2,
>  		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B2, 0, 0, 0 },
>  	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_FPGA_E2,
> -		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57C4, 0, 0, 0 },
> +		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57C3, 0, 0, 0 },
>  	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_ASIC_E2,
> +		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57C4, 0, 0, 0 },
> +	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_FPGA_E2,
>  		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B4, 0, 0, 0 },
>  	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_ASIC_E2,
>  		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B1, 0, 0, 0 },
> Index: b/drivers/scsi/ipr.h
> ===================================================================
> --- a/drivers/scsi/ipr.h	2011-10-19 15:53:32.829134947 -0700
> +++ b/drivers/scsi/ipr.h	2011-10-19 15:56:20.895356624 -0700
> @@ -82,6 +82,7 @@
> 
>  #define IPR_SUBS_DEV_ID_57B4    0x033B
>  #define IPR_SUBS_DEV_ID_57B2    0x035F
> +#define IPR_SUBS_DEV_ID_57C3    0x0353
>  #define IPR_SUBS_DEV_ID_57C4    0x0354
>  #define IPR_SUBS_DEV_ID_57C6    0x0357
>  #define IPR_SUBS_DEV_ID_57CC    0x035C
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


