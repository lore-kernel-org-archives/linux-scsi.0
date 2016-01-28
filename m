From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 01/11] qla2xxx: Remove unneeded link offline message.
Date: Thu, 28 Jan 2016 09:33:46 +0100
Message-ID: <20160128083346.GF27565@c203.arch.suse.de>
References: <1453914218-380-1-git-send-email-himanshu.madhani@qlogic.com>
 <1453914218-380-2-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55299 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755014AbcA1Idt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Jan 2016 03:33:49 -0500
Content-Disposition: inline
In-Reply-To: <1453914218-380-2-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

On Wed, Jan 27, 2016 at 12:03:28PM -0500, Himanshu Madhani wrote:
> From: Chad Dupuis <chad.dupuis@qlogic.com>
>=20
> Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_dbg.c |    1 +
>  drivers/scsi/qla2xxx/qla_isr.c |    4 ----
>  2 files changed, 1 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/ql=
a_dbg.c
> index cd0d94e..9e714cc 100644
> --- a/drivers/scsi/qla2xxx/qla_dbg.c
> +++ b/drivers/scsi/qla2xxx/qla_dbg.c
> @@ -27,6 +27,7 @@
>   * |                              |                    | 0x303a		|
>   * | DPC Thread                   |       0x4023       | 0x4002,0x40=
13  |
>   * | Async Events                 |       0x5089       | 0x502b-0x50=
2f  |
> + * |                              |                    | 0x505e     =
    |
>   * |                              |                    | 0x5084,0x50=
75	|
>   * |                              |                    | 0x503d,0x50=
44  |
>   * |                              |                    | 0x507b,0x50=
5f	|
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/ql=
a_isr.c
> index d4d65eb..edd97de 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -934,10 +934,6 @@ skip_rio:
>  			break;
> =20
>  global_port_update:
> -			/* Port unavailable. */
> -			ql_log(ql_log_warn, vha, 0x505e,
> -			    "Link is offline.\n");
> -
>  			if (atomic_read(&vha->loop_state) !=3D LOOP_DOWN) {
>  				atomic_set(&vha->loop_state, LOOP_DOWN);
>  				atomic_set(&vha->loop_down_timer,
> --=20
> 1.7.7
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

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
