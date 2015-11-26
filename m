From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 4/4] bfa:Update driver version to 3.2.25.0
Date: Thu, 26 Nov 2015 09:36:39 +0100
Message-ID: <1448526999.2877.88.camel@suse.de>
References: <1448523815-24562-1-git-send-email-anil.gurumurthy@qlogic.com>
	 <1448523815-24562-5-git-send-email-anil.gurumurthy@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44774 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942AbbKZIgk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Nov 2015 03:36:40 -0500
In-Reply-To: <1448523815-24562-5-git-send-email-anil.gurumurthy@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: anil.gurumurthy@qlogic.com, martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, sudarsana.kalluru@qlogic.com

On Thu, 2015-11-26 at 02:43 -0500, anil.gurumurthy@qlogic.com wrote:
> From: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
>=20
> Signed-off-by: Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
> Signed-off-by: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
> ---
> =C2=A0drivers/scsi/bfa/bfad_drv.h |=C2=A0=C2=A0=C2=A0=C2=A02 +-
> =C2=A01 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/scsi/bfa/bfad_drv.h b/drivers/scsi/bfa/bfad_drv.=
h
> index 8001459..f9e8620 100644
> --- a/drivers/scsi/bfa/bfad_drv.h
> +++ b/drivers/scsi/bfa/bfad_drv.h
> @@ -58,7 +58,7 @@
> =C2=A0#ifdef BFA_DRIVER_VERSION
> =C2=A0#define BFAD_DRIVER_VERSION=C2=A0=C2=A0=C2=A0=C2=A0BFA_DRIVER_V=
ERSION
> =C2=A0#else
> -#define BFAD_DRIVER_VERSION=C2=A0=C2=A0=C2=A0=C2=A0"3.2.23.0"
> +#define BFAD_DRIVER_VERSION=C2=A0=C2=A0=C2=A0=C2=A0"3.2.25.0"
> =C2=A0#endif
> =C2=A0
> =C2=A0#define BFAD_PROTO_NAME FCPI_NAME

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
