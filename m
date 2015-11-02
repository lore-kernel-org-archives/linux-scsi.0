From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 6/8] pm80xx: do not examine registers for iButton feature
 if ATTO adapter
Date: Mon, 2 Nov 2015 08:58:31 +0100
Message-ID: <563717A7.508@suse.de>
References: <1446216811-2248-1-git-send-email-brood@attotech.com>
 <1446216811-2248-7-git-send-email-brood@attotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55471 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133AbbKBH6d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Nov 2015 02:58:33 -0500
In-Reply-To: <1446216811-2248-7-git-send-email-brood@attotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Rood <benjaminjrood@gmail.com>, linux-scsi@vger.kernel.org, xjtuwjp@gmail.com, James.Bottomley@HansenPartnership.com
Cc: Benjamin Rood <brood@attotech.com>

On 10/30/2015 03:53 PM, Benjamin Rood wrote:
> ATTO adapters do not support this feature.  If the firmware fails to =
be
> ready, it should not check the examined registers in order to examine
> the state of the feature in order to prevent undefined behavior.
>=20
> Signed-off-by: Benjamin Rood <brood@attotech.com>
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
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
