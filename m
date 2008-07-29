From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][SCSI] hptiop: add more PCI device IDs
Date: Tue, 29 Jul 2008 00:34:19 -0700
Message-ID: <20080729003419.1b754608.akpm@linux-foundation.org>
References: <200807251329.24263.linux@highpoint-tech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34653 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752706AbYG2Hex (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jul 2008 03:34:53 -0400
In-Reply-To: <200807251329.24263.linux@highpoint-tech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: HighPoint Linux Team <linux@highpoint-tech.com>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, stable@kernel.org

On Fri, 25 Jul 2008 13:29:24 +0800 HighPoint Linux Team <linux@highpoint-tech.com> wrote:

> Add PCI device ID for new adapter models.
> 
> Signed-off-by: HighPoint Linux Team <linux@highpoint-tech.com>
> ---
> 
>  drivers/scsi/hptiop.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff -purN linux-2.6.26-rc8/drivers/scsi/hptiop.c linux-2.6.26-rc8-hpt/drivers/scsi/hptiop.c
> --- linux-2.6.26-rc8/drivers/scsi/hptiop.c	2008-06-25 09:58:20.000000000 +0800
> +++ linux-2.6.26-rc8-hpt/drivers/scsi/hptiop.c	2008-07-24 15:09:50.000000000 +0800
> @@ -1249,6 +1249,13 @@ static struct pci_device_id hptiop_id_ta
>  	{ PCI_VDEVICE(TTI, 0x3522), (kernel_ulong_t)&hptiop_itl_ops },
>  	{ PCI_VDEVICE(TTI, 0x3410), (kernel_ulong_t)&hptiop_itl_ops },
>  	{ PCI_VDEVICE(TTI, 0x3540), (kernel_ulong_t)&hptiop_itl_ops },
> +	{ PCI_VDEVICE(TTI, 0x3530), (kernel_ulong_t)&hptiop_itl_ops },
> +	{ PCI_VDEVICE(TTI, 0x3560), (kernel_ulong_t)&hptiop_itl_ops },
> +	{ PCI_VDEVICE(TTI, 0x4322), (kernel_ulong_t)&hptiop_itl_ops },
> +	{ PCI_VDEVICE(TTI, 0x4210), (kernel_ulong_t)&hptiop_itl_ops },
> +	{ PCI_VDEVICE(TTI, 0x4211), (kernel_ulong_t)&hptiop_itl_ops },
> +	{ PCI_VDEVICE(TTI, 0x4310), (kernel_ulong_t)&hptiop_itl_ops },
> +	{ PCI_VDEVICE(TTI, 0x4311), (kernel_ulong_t)&hptiop_itl_ops },
>  	{ PCI_VDEVICE(TTI, 0x3120), (kernel_ulong_t)&hptiop_mv_ops },
>  	{ PCI_VDEVICE(TTI, 0x3122), (kernel_ulong_t)&hptiop_mv_ops },
>  	{ PCI_VDEVICE(TTI, 0x3020), (kernel_ulong_t)&hptiop_mv_ops },

I assume that this patch makes new devices work, whereas they do not
work correctly in unpatched kernels, yes?

If so, then this patch should be backported into 2.6.25.x and 2.6.26.x.
Users of these kernels would presumably like their devices to work.
