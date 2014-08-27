From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 5/5] be2iscsi: Bump the driver version
Date: Wed, 27 Aug 2014 15:53:21 +0200
Message-ID: <53FDE2D1.60000@suse.de>
References: <1407474003-26220-1-git-send-email-jkallickal@emulex.com> <1407474003-26220-5-git-send-email-jkallickal@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36176 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933803AbaH0NxW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Aug 2014 09:53:22 -0400
In-Reply-To: <1407474003-26220-5-git-send-email-jkallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jay Kallickal <jayamohank@gmail.com>, jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

On 08/08/2014 07:00 AM, Jay Kallickal wrote:
> From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
>
>   Bump the driver version
>
> Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
> Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
> ---
>   drivers/scsi/be2iscsi/be_main.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/=
be_main.h
> index 5f8b0fc..3605631 100644
> --- a/drivers/scsi/be2iscsi/be_main.h
> +++ b/drivers/scsi/be2iscsi/be_main.h
> @@ -36,7 +36,7 @@
>   #include <scsi/scsi_transport_iscsi.h>
>
>   #define DRV_NAME		"be2iscsi"
> -#define BUILD_STR		"10.2.273.0"
> +#define BUILD_STR		"10.4.74.0"
>   #define BE_NAME			"Emulex OneConnect" \
>   				"Open-iSCSI Driver version" BUILD_STR
>   #define DRV_DESC		BE_NAME " " "Driver"
>
Reviewed-by: Hannes Reinecke <hare@suse.de>

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
