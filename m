From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] fusion: fix excess parameter kernel-doc warning
Date: Mon, 18 Aug 2014 13:07:52 -0400
Message-ID: <1408381672.1223.212.camel@localhost.localdomain>
References: <53EFC9E3.6070306@infradead.org>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391AbaHRRI1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Aug 2014 13:08:27 -0400
In-Reply-To: <53EFC9E3.6070306@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, DL-MPTFusionLinux@lsi.com, MPT-FusionLinux.pdl@avagotech.com

On Sat, 2014-08-16 at 14:15 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix kernel-doc excess parameter warning:
> 
> Warning(..//drivers/message/fusion/mptbase.c:1411): Excess function parameter 'prod_name' description in 'mpt_get_product_name'
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: DL-MPTFusionLinux@lsi.com
> Cc: MPT-FusionLinux.pdl@avagotech.com
> ---
>  drivers/message/fusion/mptbase.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> Index: lnx-317-rc1/drivers/message/fusion/mptbase.c
> ===================================================================
> --- lnx-317-rc1.orig/drivers/message/fusion/mptbase.c
> +++ lnx-317-rc1/drivers/message/fusion/mptbase.c
> @@ -1400,7 +1400,6 @@ mpt_verify_adapter(int iocid, MPT_ADAPTE
>   *	@vendor: pci vendor id
>   *	@device: pci device id
>   *	@revision: pci revision id
> - *	@prod_name: string returned
>   *
>   *	Returns product string displayed when driver loads,
>   *	in /proc/mpt/summary and /sysfs/class/scsi_host/host<X>/version_product
> --

Goes with commit c9834c70efbaaa1461ec04289d97a842244fb294.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


