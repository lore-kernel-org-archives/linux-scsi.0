From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 8/8] pm80xx: Bump pm80xx driver version to 0.1.38
Date: Wed, 29 Jul 2015 10:58:55 +0200
Message-ID: <55B895CF.6080609@suse.de>
References: <1438151240-4097-1-git-send-email-Viswas.G@pmcs.com> <1438151240-4097-9-git-send-email-Viswas.G@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60064 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961AbbG2I65 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2015 04:58:57 -0400
In-Reply-To: <1438151240-4097-9-git-send-email-Viswas.G@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Viswas.G@pmcs.com, linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, JBottomley@parallels.com, Tomas Henzl <thenzl@redhat.com>, Suresh.Thiagarajan@pmcs.com

On 07/29/2015 08:27 AM, Viswas.G@pmcs.com wrote:
> From: Viswas G <Viswas.G@pmcs.com>
>=20
> Bump pm80xx driver version to 0.1.38.
>=20
> Signed-off-by: Viswas G <Viswas.G@pmcs.com>
> Signed-off-by: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>=20
> ---
>  drivers/scsi/pm8001/pm8001_sas.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/p=
m8001_sas.h
> index 2788026..e2e97db 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.h
> +++ b/drivers/scsi/pm8001/pm8001_sas.h
> @@ -58,7 +58,7 @@
>  #include "pm8001_defs.h"
> =20
>  #define DRV_NAME		"pm80xx"
> -#define DRV_VERSION		"0.1.37"
> +#define DRV_VERSION		"0.1.38"
>  #define PM8001_FAIL_LOGGING	0x01 /* Error message logging */
>  #define PM8001_INIT_LOGGING	0x02 /* driver init logging */
>  #define PM8001_DISC_LOGGING	0x04 /* discovery layer logging */
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
