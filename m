From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 17/17] be2iscsi: Update the driver version
Date: Wed, 20 Jan 2016 11:18:30 +0100
Message-ID: <569F5EF6.7040407@suse.de>
References: <1453279261-659-1-git-send-email-jitendra.bhivare@avagotech.com>
 <1453279261-659-18-git-send-email-jitendra.bhivare@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39860 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933652AbcATKSb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jan 2016 05:18:31 -0500
In-Reply-To: <1453279261-659-18-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@avagotech.com>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

On 01/20/2016 09:41 AM, Jitendra Bhivare wrote:
> Driver version: 11.0.0.0
>=20
> Signed-off-by: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
> ---
>  drivers/scsi/be2iscsi/be_main.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/=
be_main.h
> index 41c708c..16a6fd0 100644
> --- a/drivers/scsi/be2iscsi/be_main.h
> +++ b/drivers/scsi/be2iscsi/be_main.h
> @@ -36,7 +36,7 @@
>  #include <scsi/scsi_transport_iscsi.h>
> =20
>  #define DRV_NAME		"be2iscsi"
> -#define BUILD_STR		"10.6.0.1"
> +#define BUILD_STR		"11.0.0.0"
>  #define BE_NAME			"Emulex OneConnect" \
>  				"Open-iSCSI Driver version" BUILD_STR
>  #define DRV_DESC		BE_NAME " " "Driver"
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
