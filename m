From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 5/8] pm80xx: set PHY profiles for ATTO 12Gb SAS
 controllers
Date: Mon, 2 Nov 2015 08:57:16 +0100
Message-ID: <5637175C.2060904@suse.de>
References: <1446216811-2248-1-git-send-email-brood@attotech.com>
 <1446216811-2248-6-git-send-email-brood@attotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55319 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbbKBH5T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Nov 2015 02:57:19 -0500
In-Reply-To: <1446216811-2248-6-git-send-email-brood@attotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Rood <benjaminjrood@gmail.com>, linux-scsi@vger.kernel.org, xjtuwjp@gmail.com, James.Bottomley@HansenPartnership.com
Cc: Benjamin Rood <brood@attotech.com>

On 10/30/2015 03:53 PM, Benjamin Rood wrote:
> PHY profiles are not saved in NVRAM on ATTO 12Gb SAS controllers.
> Therefore, in order for the controller to function in a wide range of
> configurations, the PHY profiles must be statically set.  This patch
> provides the necessary functionality to do so.
>=20
> Signed-off-by: Benjamin Rood <brood@attotech.com>
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 130 ++++++++++++++++++++++++++++=
++++++++++
>  drivers/scsi/pm8001/pm8001_sas.h  |   2 +
>  drivers/scsi/pm8001/pm80xx_hwi.c  |  32 ++++++++++
>  3 files changed, 164 insertions(+)
>=20
Hmm. Can't say I like compiling in magic constants, but I guess there's
no easy way out here.
So:

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
