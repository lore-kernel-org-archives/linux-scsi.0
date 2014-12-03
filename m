From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/2] ibmvfc: remove unused tag variable
Date: Wed, 03 Dec 2014 15:10:03 +0100
Message-ID: <547F19BB.7010809@suse.de>
References: <1416927010-6036-1-git-send-email-hch@lst.de> <1416927010-6036-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58911 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109AbaLCOKE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2014 09:10:04 -0500
In-Reply-To: <1416927010-6036-2-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 11/25/2014 03:50 PM, Christoph Hellwig wrote:
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/ibmvscsi/ibmvfc.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/i=
bmvfc.c
> index f58c6d8..8ac49cf 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> @@ -1615,7 +1615,6 @@ static int ibmvfc_queuecommand_lck(struct scsi_=
cmnd *cmnd,
>  	struct fc_rport *rport =3D starget_to_rport(scsi_target(cmnd->devic=
e));
>  	struct ibmvfc_cmd *vfc_cmd;
>  	struct ibmvfc_event *evt;
> -	u8 tag[2];
>  	int rc;
> =20
>  	if (unlikely((rc =3D fc_remote_port_chkready(rport))) ||
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
