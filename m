From: Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: Re: [PATCH -next] scsi: be2iscsi needs ISCSI_BOOT_SYSFS
Date: Thu, 29 Jul 2010 15:34:20 -0400
Message-ID: <20100729193420.GB13308@andromeda.dapyr.net>
References: <20100729143211.9e7edaed.sfr@canb.auug.org.au> <20100729101609.965dbe48.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andromeda.dapyr.net ([206.212.254.10]:34501 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757408Ab0G2Tnc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jul 2010 15:43:32 -0400
Content-Disposition: inline
In-Reply-To: <20100729101609.965dbe48.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, scsi <linux-scsi@vger.kernel.org>, Jayamohan Kallickal <jayamohank@serverengines.com>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, jejbscsi <james.bottomley@suse.de>

On Thu, Jul 29, 2010 at 10:16:09AM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> be2iscsi uses iscsi_boot_*() interfaces, so it should ensure that
> ISCSI_BOOT_SYSFS is enabled.
> 
> ERROR: "iscsi_boot_create_target" [drivers/scsi/be2iscsi/be2iscsi.ko] undefined!
> ERROR: "iscsi_boot_create_ethernet" [drivers/scsi/be2iscsi/be2iscsi.ko] undefined!
> ERROR: "iscsi_boot_create_host_kset" [drivers/scsi/be2iscsi/be2iscsi.ko] undefined!
> ERROR: "iscsi_boot_create_initiator" [drivers/scsi/be2iscsi/be2iscsi.ko] undefined!
> ERROR: "iscsi_boot_destroy_kset" [drivers/scsi/be2iscsi/be2iscsi.ko] undefined!
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Acked-by: Konrad Rzeszutek Wilk <konrad@kernel.org>

> ---
>  drivers/scsi/be2iscsi/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-next-20100729.orig/drivers/scsi/be2iscsi/Kconfig
> +++ linux-next-20100729/drivers/scsi/be2iscsi/Kconfig
> @@ -2,6 +2,7 @@ config BE2ISCSI
>  	tristate "ServerEngines' 10Gbps iSCSI - BladeEngine 2"
>  	depends on PCI && SCSI && NET
>  	select SCSI_ISCSI_ATTRS
> +	select ISCSI_BOOT_SYSFS
>  
>  	help
>  	This driver implements the iSCSI functionality for ServerEngines'
> ---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
