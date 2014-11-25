From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 1/5] scsi_debug: pinpoint invalid field in sense data
Date: Tue, 25 Nov 2014 07:57:48 +0100
Message-ID: <5474286C.3030104@suse.de>
References: <5473FFDF.5070206@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60185 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbaKYG5u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Nov 2014 01:57:50 -0500
In-Reply-To: <5473FFDF.5070206@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, SCSI development list <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@ORACLE.COM>

On 11/25/2014 05:04 AM, Douglas Gilbert wrote:
> Use Sense Key Specific field in the sense data of an ILLEGAL REQUEST
> to optionally pinpoint the location of the problem field. This may
> be either in the cdb or the associated parameter list.
> ---
>  drivers/scsi/scsi_debug.c | 138
> +++++++++++++++++++++++++++++-----------------
>  1 file changed, 88 insertions(+), 50 deletions(-)
>=20
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 21284 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
