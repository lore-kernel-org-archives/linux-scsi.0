From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 10/10] scsi: mark scsi_setup_blk_pc_cmnd static
Date: Fri, 11 Jul 2014 14:33:57 +0200
Message-ID: <53BFD9B5.6080407@suse.de>
References: <1404048881-19526-1-git-send-email-hch@lst.de> <1404048881-19526-11-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54722 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099AbaGKMd7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jul 2014 08:33:59 -0400
In-Reply-To: <1404048881-19526-11-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

On 06/29/2014 03:34 PM, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/scsi_lib.c    |    3 +--
>   include/scsi/scsi_driver.h |    2 --
>   2 files changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index ea23860..f0a3ef1 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1080,7 +1080,7 @@ static struct scsi_cmnd *scsi_get_cmd_from_req(=
struct scsi_device *sdev,
>   	return cmd;
>   }
>
> -int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request =
*req)
> +static int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct r=
equest *req)
>   {
>   	struct scsi_cmnd *cmd =3D req->special;
>
> @@ -1105,7 +1105,6 @@ int scsi_setup_blk_pc_cmnd(struct scsi_device *=
sdev, struct request *req)
>   	cmd->allowed =3D req->retries;
>   	return BLKPREP_OK;
>   }
> -EXPORT_SYMBOL(scsi_setup_blk_pc_cmnd);
>
>   /*
>    * Setup a REQ_TYPE_FS command.  These are simple request from file=
systems
> diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
> index 009d2ae..c2b7598 100644
> --- a/include/scsi/scsi_driver.h
> +++ b/include/scsi/scsi_driver.h
> @@ -29,6 +29,4 @@ extern int scsi_register_interface(struct class_int=
erface *);
>   #define scsi_unregister_interface(intf) \
>   	class_interface_unregister(intf)
>
> -int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request =
*req);
> -
>   #endif /* _SCSI_SCSI_DRIVER_H */
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
