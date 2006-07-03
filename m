From: Hannes Reinecke <hare@suse.de>
Subject: Re: [patch 08/22] drivers/scsi/aic7xxx/aic79xx_core.c: make ahd_match_scb()
 static
Date: Mon, 03 Jul 2006 16:06:37 +0200
Message-ID: <44A9246D.7010605@suse.de>
References: <200606300933.k5U9X8nU001698@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:61624 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S1751168AbWGCOGj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Jul 2006 10:06:39 -0400
In-Reply-To: <200606300933.k5U9X8nU001698@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, bunk@stusta.de

akpm@osdl.org wrote:
> From: Adrian Bunk <bunk@stusta.de>
>=20
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> Cc: James Bottomley <James.Bottomley@steeleye.com>
> Signed-off-by: Andrew Morton <akpm@osdl.org>
> ---
>=20
>  drivers/scsi/aic7xxx/aic79xx.h      |    3 ---
>  drivers/scsi/aic7xxx/aic79xx_core.c |    5 ++++-
>  2 files changed, 4 insertions(+), 4 deletions(-)
>=20
> diff -puN drivers/scsi/aic7xxx/aic79xx_core.c~drivers-scsi-aic7xxx-ai=
c79xx_corec-make-ahd_match_scb-static drivers/scsi/aic7xxx/aic79xx_core=
=2Ec
> --- a/drivers/scsi/aic7xxx/aic79xx_core.c~drivers-scsi-aic7xxx-aic79x=
x_corec-make-ahd_match_scb-static
> +++ a/drivers/scsi/aic7xxx/aic79xx_core.c
> @@ -262,6 +262,9 @@ static void		ahd_update_coalescing_value
>  						     u_int mincmds);
>  static int		ahd_verify_vpd_cksum(struct vpd_config *vpd);
>  static int		ahd_wait_seeprom(struct ahd_softc *ahd);
> +static int		ahd_match_scb(struct ahd_softc *ahd, struct scb *scb,
> +				      int target, char channel, int lun,
> +				      u_int tag, role_t role);
> =20
>  /******************************** Private Inlines ******************=
***********/
> =20
> @@ -7215,7 +7218,7 @@ ahd_busy_tcl(struct ahd_softc *ahd, u_in
>  }
> =20
>  /************************** SCB and SCB queue management ***********=
***********/
> -int
> +static int
>  ahd_match_scb(struct ahd_softc *ahd, struct scb *scb, int target,
>  	      char channel, int lun, u_int tag, role_t role)
>  {
> diff -puN drivers/scsi/aic7xxx/aic79xx.h~drivers-scsi-aic7xxx-aic79xx=
_corec-make-ahd_match_scb-static drivers/scsi/aic7xxx/aic79xx.h
> --- a/drivers/scsi/aic7xxx/aic79xx.h~drivers-scsi-aic7xxx-aic79xx_cor=
ec-make-ahd_match_scb-static
> +++ a/drivers/scsi/aic7xxx/aic79xx.h
> @@ -1345,9 +1345,6 @@ int	ahd_pci_test_register_access(struct=20
>  /************************** SCB and SCB queue management ***********=
***********/
>  void		ahd_qinfifo_requeue_tail(struct ahd_softc *ahd,
>  					 struct scb *scb);
> -int		ahd_match_scb(struct ahd_softc *ahd, struct scb *scb,
> -			      int target, char channel, int lun,
> -			      u_int tag, role_t role);
> =20
>  /****************************** Initialization *********************=
***********/
>  struct ahd_softc	*ahd_alloc(void *platform_arg, char *name);
> _
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
