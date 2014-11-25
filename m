From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 5/5] scsi_debug: Add Report supported opcodes+tmfs;
 Compare and write
Date: Tue, 25 Nov 2014 08:05:15 +0100
Message-ID: <54742A2B.2080505@suse.de>
References: <54740014.8060605@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60280 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343AbaKYHFQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Nov 2014 02:05:16 -0500
In-Reply-To: <54740014.8060605@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, SCSI development list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@ORACLE.COM>

On 11/25/2014 05:05 AM, Douglas Gilbert wrote:
> From: Douglas Gilbert <dgilbert@interlog.com>
> Date: Mon, 24 Nov 2014 21:27:12 -0500
> Subject: [PATCH 5/5] Add Report supported opcodes+tmfs; Compare and
> write
>=20
> The Report supported operation codes command is very closely integrat=
ed
> into the table driven parser and very useful for testing it. Its cdb
> masks form the basis of the 'strict' parameter's checks. The Report
> supported TMFs command is a simple extension. The Compare and write
> command may even be useful, as it should be atomic due to the
> read-write
> lock that the driver uses on its backing store (ram).
> ---
>  drivers/scsi/scsi_debug.c | 326
> +++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 307 insertions(+), 19 deletions(-)
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
