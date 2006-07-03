From: Hannes Reinecke <hare@suse.de>
Subject: Re: [patch 06/22] drivers/scsi/aic7xxx/aic79xx_core.c: make ahd_done_with_status()
 static
Date: Mon, 03 Jul 2006 16:06:04 +0200
Message-ID: <44A9244C.9090808@suse.de>
References: <200606300933.k5U9X7O2001692@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55944 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S1751155AbWGCOGS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Jul 2006 10:06:18 -0400
In-Reply-To: <200606300933.k5U9X7O2001692@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, bunk@stusta.de

akpm@osdl.org wrote:
> From: Adrian Bunk <bunk@stusta.de>
>=20
> This patch makes a needlessly global function static.
>=20
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> Cc: James Bottomley <James.Bottomley@steeleye.com>
> Signed-off-by: Andrew Morton <akpm@osdl.org>
> ---
>=20
>  drivers/scsi/aic7xxx/aic79xx_core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff -puN drivers/scsi/aic7xxx/aic79xx_core.c~drivers-scsi-aic7xxx-ai=
c79xx_corec-make-ahd_done_with_status-static drivers/scsi/aic7xxx/aic79=
xx_core.c
> --- a/drivers/scsi/aic7xxx/aic79xx_core.c~drivers-scsi-aic7xxx-aic79x=
x_corec-make-ahd_done_with_status-static
> +++ a/drivers/scsi/aic7xxx/aic79xx_core.c
> @@ -7354,7 +7354,7 @@ ahd_reset_cmds_pending(struct ahd_softc=20
>  	ahd->flags &=3D ~AHD_UPDATE_PEND_CMDS;
>  }
> =20
> -void
> +static void
>  ahd_done_with_status(struct ahd_softc *ahd, struct scb *scb, uint32_=
t status)
>  {
>  	cam_status ostat;
> _
> -
Ack-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
