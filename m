From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/8] pm80xx: configure PHY settings based on subsystem
 vendor ID
Date: Mon, 2 Nov 2015 08:51:31 +0100
Message-ID: <56371603.3000807@suse.de>
References: <1446216811-2248-1-git-send-email-brood@attotech.com>
 <1446216811-2248-2-git-send-email-brood@attotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54406 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbbKBHvd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Nov 2015 02:51:33 -0500
In-Reply-To: <1446216811-2248-2-git-send-email-brood@attotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Rood <benjaminjrood@gmail.com>, linux-scsi@vger.kernel.org, xjtuwjp@gmail.com, James.Bottomley@HansenPartnership.com
Cc: Benjamin Rood <brood@attotech.com>

On 10/30/2015 03:53 PM, Benjamin Rood wrote:
> Previuosly, all PMC Sierra 80xx controllers are assumed to be a
> motherboard controller, except if the subsystem vendor ID was equal t=
o
> PCI_VENDOR_ID_ADAPTEC.  The driver then attempts to load PHY settings
> from NVRAM.  While this may be correct behavior for most controllers,=
 it
> does not work with Adaptec and ATTO controllers since they do not sto=
re
> PHY settings in NVRAM and choose to use either custom PHY settings or=
 chip
> defaults.  Loading random values from NVRAM may cause the controllers=
 to
> malfunction in this edge case.
>=20
> Signed-off-by: Benjamin Rood <brood@attotech.com>
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 26 ++++++++++++++++++++------
>  1 file changed, 20 insertions(+), 6 deletions(-)
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
