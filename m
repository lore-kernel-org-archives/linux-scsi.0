From: "Michael Chan" <mchan@broadcom.com>
Subject: Re: [PATCH] let bnx2i iSCSI driver depend on PCI
Date: Mon, 15 Jun 2009 13:35:30 -0700
Message-ID: <1245098130.12000.30.camel@HP1>
References: <20090615203542.GB4788@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3112 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbZFOUmz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Jun 2009 16:42:55 -0400
In-Reply-To: <20090615203542.GB4788@osiris.boeblingen.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


On Mon, 2009-06-15 at 13:35 -0700, Heiko Carstens wrote:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> allyesconfig on s390 fails like this because of lack of PCI:
> 
> drivers/scsi/bnx2i/bnx2i_iscsi.c:760:
>   error: implicit declaration of function 'pci_dev_get'
> 

A similar patch is already in James' tree:

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=babdb788f7ec1a782a52240a5f6dae568f32565f

Thanks.

> Cc: Michael Chan <mchan@broadcom.com>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  drivers/scsi/bnx2i/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux-2.6/drivers/scsi/bnx2i/Kconfig
> ===================================================================
> --- linux-2.6.orig/drivers/scsi/bnx2i/Kconfig
> +++ linux-2.6/drivers/scsi/bnx2i/Kconfig
> @@ -2,6 +2,7 @@ config SCSI_BNX2_ISCSI
>  	tristate "Broadcom NetXtreme II iSCSI support"
>  	select SCSI_ISCSI_ATTRS
>  	select CNIC
> +	depends on PCI
>  	---help---
>  	This driver supports iSCSI offload for the Broadcom NetXtreme II
>  	devices.
> 


