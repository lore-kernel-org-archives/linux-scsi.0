From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH 1/2] fusion: select BLK_DEV_BSG
Date: Wed, 18 Aug 2010 17:37:28 +0530
Message-ID: <1C9608B8A4CD534FB19C7C7543CBB249029923AB32@inbmail02.lsi.com>
References: <20100817113540.83e98a77.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:35147 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752684Ab0HRMHk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Aug 2010 08:07:40 -0400
In-Reply-To: <20100817113540.83e98a77.randy.dunlap@oracle.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>, scsi <linux-scsi@vger.kernel.org>
Cc: jejbscsi <james.bottomley@suse.de>, "Moore, Eric" <Eric.Moore@lsi.com>

Please consider this patch as an ACKed.

~ Kashyap

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Randy Dunlap
> Sent: Wednesday, August 18, 2010 12:06 AM
> To: scsi
> Cc: jejbscsi; Moore, Eric
> Subject: [PATCH 1/2] fusion: select BLK_DEV_BSG
> 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fusion selects SCSI_SAS_ATTRS which needs BLK_DEV_BSG, so also select
> BLK_DEV_BSG in fusion.
> 
> Fixes the kconfig warning:
> 
> warning: (SCSI_SAS_LIBSAS && SCSI || SCSI_MPT2SAS && SCSI_LOWLEVEL &&
> PCI && SCSI || FUSION_SAS && FUSION && PCI && SCSI) selects
> SCSI_SAS_ATTRS which has unmet direct dependencies (SCSI &&
> BLK_DEV_BSG)
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Eric Moore <Eric.Moore@lsi.com>
> ---
>  drivers/message/fusion/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-next-20100810.orig/drivers/message/fusion/Kconfig
> +++ linux-next-20100810/drivers/message/fusion/Kconfig
> @@ -49,6 +49,7 @@ config FUSION_SAS
>  	tristate "Fusion MPT ScsiHost drivers for SAS"
>  	depends on PCI && SCSI
>  	select SCSI_SAS_ATTRS
> +	select BLK_DEV_BSG
>  	---help---
>  	  SCSI HOST support for a SAS host adapters.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
