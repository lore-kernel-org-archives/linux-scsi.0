From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 07/11] hpsa: add in new controllers
Date: Wed, 22 Jul 2015 17:19:26 +0200
Message-ID: <55AFB47E.3020808@redhat.com>
References: <20150718160245.31955.16794.stgit@brunhilda>
 <20150718161254.31955.27250.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934322AbbGVPT3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Jul 2015 11:19:29 -0400
In-Reply-To: <20150718161254.31955.27250.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hp.com
Cc: linux-scsi@vger.kernel.org

On 18.7.2015 18:12, Don Brace wrote:
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

> ---
>  drivers/scsi/hpsa.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index f34978d..20c29e5 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -129,6 +129,11 @@ static const struct pci_device_id hpsa_pci_device_id[] = {
>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21CD},
>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21CE},
>  	{PCI_VENDOR_ID_ADAPTEC2, 0x0290, 0x9005, 0x0580},
> +	{PCI_VENDOR_ID_ADAPTEC2, 0x0290, 0x9005, 0x0581},
> +	{PCI_VENDOR_ID_ADAPTEC2, 0x0290, 0x9005, 0x0582},
> +	{PCI_VENDOR_ID_ADAPTEC2, 0x0290, 0x9005, 0x0583},
> +	{PCI_VENDOR_ID_ADAPTEC2, 0x0290, 0x9005, 0x0584},
> +	{PCI_VENDOR_ID_ADAPTEC2, 0x0290, 0x9005, 0x0585},
>  	{PCI_VENDOR_ID_HP_3PAR, 0x0075, 0x1590, 0x0076},
>  	{PCI_VENDOR_ID_HP_3PAR, 0x0075, 0x1590, 0x0087},
>  	{PCI_VENDOR_ID_HP_3PAR, 0x0075, 0x1590, 0x007D},
> @@ -187,6 +192,11 @@ static struct board_type products[] = {
>  	{0x21CD103C, "Smart Array", &SA5_access},
>  	{0x21CE103C, "Smart HBA", &SA5_access},
>  	{0x05809005, "SmartHBA-SA", &SA5_access},
> +	{0x05819005, "SmartHBA-SA 8i", &SA5_access},
> +	{0x05829005, "SmartHBA-SA 8i8e", &SA5_access},
> +	{0x05839005, "SmartHBA-SA 8e", &SA5_access},
> +	{0x05849005, "SmartHBA-SA 16i", &SA5_access},
> +	{0x05859005, "SmartHBA-SA 4i4e", &SA5_access},
>  	{0x00761590, "HP Storage P1224 Array Controller", &SA5_access},
>  	{0x00871590, "HP Storage P1224e Array Controller", &SA5_access},
>  	{0x007D1590, "HP Storage P1228 Array Controller", &SA5_access},
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

