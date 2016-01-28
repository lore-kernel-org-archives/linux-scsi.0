From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 11/11] qla2xxx: Update driver version to 8.07.00.33-k
Date: Thu, 28 Jan 2016 10:02:09 +0100
Message-ID: <20160128090209.GP27565@c203.arch.suse.de>
References: <1453914218-380-1-git-send-email-himanshu.madhani@qlogic.com>
 <1453914218-380-12-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33804 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965262AbcA1JCL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Jan 2016 04:02:11 -0500
Content-Disposition: inline
In-Reply-To: <1453914218-380-12-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

On Wed, Jan 27, 2016 at 12:03:38PM -0500, Himanshu Madhani wrote:
> Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_version.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xx=
x/qla_version.h
> index 6d31faa..0bc93fa 100644
> --- a/drivers/scsi/qla2xxx/qla_version.h
> +++ b/drivers/scsi/qla2xxx/qla_version.h
> @@ -7,7 +7,7 @@
>  /*
>   * Driver version
>   */
> -#define QLA2XXX_VERSION      "8.07.00.26-k"
> +#define QLA2XXX_VERSION      "8.07.00.33-k"
> =20
>  #define QLA_DRIVER_MAJOR_VER	8
>  #define QLA_DRIVER_MINOR_VER	7
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
