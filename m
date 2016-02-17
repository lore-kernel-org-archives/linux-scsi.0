From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 2/2] Modified Maintainers list for MPT FUSION DRIVERS.
Date: Wed, 17 Feb 2016 12:36:54 +0100
Message-ID: <20160217113654.GL18134@c203.arch.suse.de>
References: <1455708326-7584-1-git-send-email-chaitra.basappa@broadcom.com>
 <1455708326-7584-3-git-send-email-chaitra.basappa@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39569 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161408AbcBQLg5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Feb 2016 06:36:57 -0500
Content-Disposition: inline
In-Reply-To: <1455708326-7584-3-git-send-email-chaitra.basappa@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chaitra P B <chaitra.basappa@broadcom.com>
Cc: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, krishnaraddi.mankani@avagotech.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@broadcom.com, sreekanth.reddy@broadcom.com

On Wed, Feb 17, 2016 at 04:55:26PM +0530, Chaitra P B wrote:
> Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
> Suganath prabu Subramani <suganath-prabu.subramani@avagotech.com>
> ---
>  MAINTAINERS | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 28eb61b..1922b16 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6659,10 +6659,9 @@ S:	Maintained
>  F:	arch/arm/mach-lpc32xx/
> =20
>  LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)
> -M:	Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>
> -M:	Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>
> -M:	Sreekanth Reddy <sreekanth.reddy@avagotech.com>
> -M:	Abhijit Mahajan <abhijit.mahajan@avagotech.com>
> +M:	Sathya Prakash <sathya.prakash@broadcom.com>
> +M:	Chaitra P B <chaitra.basappa@broadcom.com>
> +M:	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
>  L:	MPT-FusionLinux.pdl@avagotech.com
>  L:	linux-scsi@vger.kernel.org
>  W:	http://www.lsilogic.com/support
> --=20
> 1.8.3.1
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
