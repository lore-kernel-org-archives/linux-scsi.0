From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/3] scsi: update scsi_device_types
Date: Mon, 21 Jul 2014 07:59:35 +0200
Message-ID: <53CCAC47.5010507@suse.de>
References: <1405696638-23770-1-git-send-email-hch@lst.de> <1405696638-23770-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42327 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461AbaGUF7h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jul 2014 01:59:37 -0400
In-Reply-To: <1405696638-23770-2-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 07/18/2014 05:17 PM, Christoph Hellwig wrote:
> Add two new device types, most importantly the zoned block device
> one.
>
> Split from an earlier patch by Hannes Reinecke.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/scsi.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 013709f..33318f5 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -122,6 +122,8 @@ static const char *const scsi_device_types[] =3D =
{
>   	"Bridge controller",
>   	"Object storage   ",
>   	"Automation/Drive ",
> +	"Security Manager ",
> +	"Direct-Access-ZBC",
>   };
>
>   /**
>
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
