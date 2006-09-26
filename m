From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [patch 20/28] drivers/message/fusion/linux_compat.h Removal of old code
Date: Mon, 25 Sep 2006 18:14:26 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D7034FA42@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:60395 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751840AbWIZAOd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Sep 2006 20:14:33 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org, James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, michal.k.k.piotrowski@gmail.com

On Monday, September 25, 2006 5:59 PM, Andrew Morton wrote: 

> 
> From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
> 
> Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
> Acked-by: "Moore, Eric Dean" <Eric.Moore@lsil.com>
> Cc: James Bottomley <James.Bottomley@steeleye.com>
> Signed-off-by: Andrew Morton <akpm@osdl.org>
> ---
> 
>  drivers/message/fusion/linux_compat.h |    9 ---------
>  1 file changed, 9 deletions(-)
> 
> diff -puN 
> drivers/message/fusion/linux_compat.h~drivers-message-fusion-l
> inux_compath-removal-of-old-code drivers/message/fusion/linux_compat.h
> --- 
> a/drivers/message/fusion/linux_compat.h~drivers-message-fusion
> -linux_compath-removal-of-old-code
> +++ a/drivers/message/fusion/linux_compat.h
> @@ -6,13 +6,4 @@
>  #include <linux/version.h>
>  #include <scsi/scsi_device.h>
>  
> -#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,6))
> -static int inline scsi_device_online(struct scsi_device *sdev)
> -{
> -	return sdev->online;
> -}
> -#endif
> -
> -
> -/*}-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
> -=-=-=-=-=-=-=-=*/
>  #endif /* _LINUX_COMPAT_H */
> _
>


James, pls apply. 

However pls don't remove this file from the tree.

Eric 
