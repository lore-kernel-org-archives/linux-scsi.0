From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [Patch V2 9/9] [SCSI] aacraid: Update driver version
Date: Tue, 16 Jun 2015 13:43:43 +0200
Message-ID: <20150616114343.GF2883@c203.arch.suse.de>
References: <1433986951-9033-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
 <1433986951-9033-11-git-send-email-rajinikanth.pandurangan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38042 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902AbbFPLns (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Jun 2015 07:43:48 -0400
Content-Disposition: inline
In-Reply-To: <1433986951-9033-11-git-send-email-rajinikanth.pandurangan@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rajinikanth.pandurangan@pmcs.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, aacraid@pmc-sierra.com, harry.yang@pmcs.com, mahesh.rajashekhara@pmcs.com, rich.bono@pmcs.com, achim.leubner@pmcs.com, murthy.bhat@pmcs.com

On Wed, Jun 10, 2015 at 06:42:31PM -0700, rajinikanth.pandurangan@pmcs.=
com wrote:
> From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
>=20
> Signed-off-by: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.=
com>
> ---
>  drivers/scsi/aacraid/aacraid.h | 2 +-
>  drivers/scsi/aacraid/linit.c   | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aa=
craid.h
> index 7b95227..73c3384 100644
> --- a/drivers/scsi/aacraid/aacraid.h
> +++ b/drivers/scsi/aacraid/aacraid.h
> @@ -62,7 +62,7 @@ enum {
>  #define	PMC_GLOBAL_INT_BIT0		0x00000001
> =20
>  #ifndef AAC_DRIVER_BUILD
> -# define AAC_DRIVER_BUILD 40709
> +# define AAC_DRIVER_BUILD 41010
>  # define AAC_DRIVER_BRANCH "-ms"
>  #endif
>  #define MAXIMUM_NUM_CONTAINERS	32
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/lini=
t.c
> index 3df0dfb..1627928 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -56,7 +56,7 @@
> =20
>  #include "aacraid.h"
> =20
> -#define AAC_DRIVER_VERSION		"1.2-1"
> +#define AAC_DRIVER_VERSION		"1.2-2"
>  #ifndef AAC_DRIVER_BRANCH
>  #define AAC_DRIVER_BRANCH		""
>  #endif
> --=20
> 1.9.3
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                       Storage
jthumshirn@suse.de                             +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
