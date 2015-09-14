From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 14/14] lpfc: Update version to 11.0.0.0 for upstream patch
 set
Date: Mon, 14 Sep 2015 09:41:10 +0200
Message-ID: <55F67A16.20504@suse.de>
References: <55e4bd96.ieZitv3jHOr0EOKp%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40632 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbbINHlM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Sep 2015 03:41:12 -0400
In-Reply-To: <55e4bd96.ieZitv3jHOr0EOKp%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>, linux-scsi@vger.kernel.org

On 08/31/2015 10:48 PM, James Smart wrote:
>=20
> Update version to 11.0.0.0 for upstream patch set
>=20
> Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
> Signed-off-by: James Smart <james.smart@avagotech.com>
> ---
>  drivers/scsi/lpfc/lpfc_version.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpf=
c_version.h
> index 6258d3d..ea53aa6 100644
> --- a/drivers/scsi/lpfc/lpfc_version.h
> +++ b/drivers/scsi/lpfc/lpfc_version.h
> @@ -18,7 +18,7 @@
>   * included with this package.                                     *
>   *******************************************************************=
/
> =20
> -#define LPFC_DRIVER_VERSION "10.7.0.0."
> +#define LPFC_DRIVER_VERSION "11.0.0.0."
>  #define LPFC_DRIVER_NAME		"lpfc"
> =20
>  /* Used for SLI 2/3 */
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

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
