From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 3/5] scsi_debug: add Capacity Changed Unit Attention
Date: Tue, 25 Nov 2014 07:59:39 +0100
Message-ID: <547428DB.8030507@suse.de>
References: <54740000.3010104@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60202 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbaKYG7k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Nov 2014 01:59:40 -0500
In-Reply-To: <54740000.3010104@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, SCSI development list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@ORACLE.COM>

On 11/25/2014 05:05 AM, Douglas Gilbert wrote:
> From: Douglas Gilbert <dgilbert@interlog.com>
> Date: Mon, 24 Nov 2014 20:27:51 -0500
> Subject: [PATCH 3/5] add Capacity Changed Unit Attention
>=20
> Via sysfs the virtual_gb scsi_debug parameter can be changed while
> LUs are in use. If that changes, the 'Capacity data has changed'
> Unit Attention is queued on all LUs.
> ---
>  drivers/scsi/scsi_debug.c | 28 ++++++++++++++++++++++++----
>  1 file changed, 24 insertions(+), 4 deletions(-)
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
