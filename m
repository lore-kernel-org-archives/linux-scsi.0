From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: fix scsi_error.c kernel-doc warning
Date: Tue, 30 Dec 2014 15:16:24 +0100
Message-ID: <54A2B3B8.1050004@suse.de>
References: <54A19228.4030308@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50119 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbaL3OQ2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Dec 2014 09:16:28 -0500
In-Reply-To: <54A19228.4030308@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>

On 12/29/2014 06:40 PM, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
>=20
> Fix kernel-doc warning in scsi_error.c:
>=20
> Warning(..//drivers/scsi/scsi_error.c:887): No description found for =
parameter 'hostt'
>=20
> Fixes: 883a030f989a17b81167f3a181cf93d741fa98b4
> 	(scsi: document scsi_try_to_abort_cmd)
>=20
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/scsi_error.c |    1 +
>  1 file changed, 1 insertion(+)
>=20
> --- lnx-319-rc2.orig/drivers/scsi/scsi_error.c
> +++ lnx-319-rc2/drivers/scsi/scsi_error.c
> @@ -868,6 +868,7 @@ static int scsi_try_bus_device_reset(str
> =20
>  /**
>   * scsi_try_to_abort_cmd - Ask host to abort a SCSI command
> + * @hostt:	SCSI driver host template
>   * @scmd:	SCSI cmd used to send a target reset
>   *
>   * Return value:
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
