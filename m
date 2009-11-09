From: Jing Huang <huangj@Brocade.COM>
Subject: RE: [PATCH 60/75] bfa: declare MODULE_FIRMWARE
Date: Mon, 9 Nov 2009 11:32:43 -0800
Message-ID: <B0A7AF226B49A14897036E9B3A68CFFECF0442C32C@HQ-EXCH-7.corp.brocade.com>
References: <1257631534.15927.482.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.82]:50517 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbZKITcj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Nov 2009 14:32:39 -0500
In-Reply-To: <1257631534.15927.482.camel@localhost>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>, "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Reviewed-by: Jing Huang <huangj@brocade.com>

Thanks.

> -----Original Message-----
> From: Ben Hutchings [mailto:ben@decadent.org.uk]
> Sent: Saturday, November 07, 2009 2:06 PM
> To: James E.J. Bottomley
> Cc: Jing Huang; linux-scsi@vger.kernel.org
> Subject: [PATCH 60/75] bfa: declare MODULE_FIRMWARE
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/scsi/bfa/bfad_fwimg.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/bfa/bfad_fwimg.c b/drivers/scsi/bfa/bfad_fwimg.c
> index 2c2082d..2ad65f2 100644
> --- a/drivers/scsi/bfa/bfad_fwimg.c
> +++ b/drivers/scsi/bfa/bfad_fwimg.c
> @@ -41,6 +41,8 @@ u32 *bfi_image_cb;
> 
>  #define	BFAD_FW_FILE_CT	"ctfw.bin"
>  #define	BFAD_FW_FILE_CB	"cbfw.bin"
> +MODULE_FIRMWARE(BFAD_FW_FILE_CT);
> +MODULE_FIRMWARE(BFAD_FW_FILE_CB);
> 
>  u32 *
>  bfad_read_firmware(struct pci_dev *pdev, u32 **bfi_image,
> --
> 1.6.5.2
> 
> 

