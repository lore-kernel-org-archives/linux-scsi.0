From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 02/11] qla2xxx: Seed init-cb login timeout from nvram
 exclusively.
Date: Thu, 28 Jan 2016 09:34:38 +0100
Message-ID: <20160128083438.GG27565@c203.arch.suse.de>
References: <1453914218-380-1-git-send-email-himanshu.madhani@qlogic.com>
 <1453914218-380-3-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55447 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933277AbcA1Iem (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Jan 2016 03:34:42 -0500
Content-Disposition: inline
In-Reply-To: <1453914218-380-3-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

On Wed, Jan 27, 2016 at 12:03:29PM -0500, Himanshu Madhani wrote:
> From: Joe Carnuccio <joe.carnuccio@qlogic.com>
>=20
> Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_init.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/q=
la_init.c
> index 52a8765..a663ff6 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -2844,7 +2844,6 @@ qla2x00_nvram_config(scsi_qla_host_t *vha)
>  	if (nv->login_timeout < 4)
>  		nv->login_timeout =3D 4;
>  	ha->login_timeout =3D nv->login_timeout;
> -	icb->login_timeout =3D nv->login_timeout;
> =20
>  	/* Set minimum RATOV to 100 tenths of a second. */
>  	ha->r_a_tov =3D 100;
> @@ -5274,7 +5273,6 @@ qla24xx_nvram_config(scsi_qla_host_t *vha)
>  	if (le16_to_cpu(nv->login_timeout) < 4)
>  		nv->login_timeout =3D cpu_to_le16(4);
>  	ha->login_timeout =3D le16_to_cpu(nv->login_timeout);
> -	icb->login_timeout =3D nv->login_timeout;
> =20
>  	/* Set minimum RATOV to 100 tenths of a second. */
>  	ha->r_a_tov =3D 100;
> @@ -6231,7 +6229,6 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
>  	if (le16_to_cpu(nv->login_timeout) < 4)
>  		nv->login_timeout =3D cpu_to_le16(4);
>  	ha->login_timeout =3D le16_to_cpu(nv->login_timeout);
> -	icb->login_timeout =3D nv->login_timeout;
> =20
>  	/* Set minimum RATOV to 100 tenths of a second. */
>  	ha->r_a_tov =3D 100;
> --=20
> 1.7.7
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

You really should be a bit more verbose in your commit messages...

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
