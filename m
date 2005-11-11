From: James.Smart@Emulex.Com
Subject: RE: [PATCH] lpfc build fix
Date: Thu, 10 Nov 2005 22:51:31 -0500
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276B53@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932355AbVKKDvz@vger.kernel.org>
content-class: urn:content-classes:message
Sender: linux-kernel-owner@vger.kernel.org
To: jgarzik@pobox.com, akpm@osdl.org, torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, gregkh@suse.de
List-Id: linux-scsi@vger.kernel.org

ok...

-- james s

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org]On Behalf Of Jeff Garzik
> Sent: Thursday, November 10, 2005 8:34 PM
> To: Andrew Morton; Linus Torvalds
> Cc: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org; Greg KH
> Subject: [PATCH] lpfc build fix
> 
> 
> Current upstream 'allmodconfig' build is broken.  This is the obvious
> patch...
> 
> Signed-off-by: Jeff Garzik <jgarzik@pobox.com>
> 
> diff --git a/drivers/scsi/lpfc/lpfc_init.c 
> b/drivers/scsi/lpfc/lpfc_init.c
> index c907238..0749811 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -1704,7 +1704,6 @@ MODULE_DEVICE_TABLE(pci, lpfc_id_table);
>  
>  static struct pci_driver lpfc_driver = {
>  	.name		= LPFC_DRIVER_NAME,
> -	.owner		= THIS_MODULE,
>  	.id_table	= lpfc_id_table,
>  	.probe		= lpfc_pci_probe_one,
>  	.remove		= __devexit_p(lpfc_pci_remove_one),
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
