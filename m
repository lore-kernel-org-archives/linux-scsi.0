From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] constants.c: asc/ascq codes, sync to T10 20141221
Date: Mon, 29 Dec 2014 10:36:34 +0100
Message-ID: <54A120A2.3060601@suse.de>
References: <54999854.2070501@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34408 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbaL2Jge (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Dec 2014 04:36:34 -0500
In-Reply-To: <54999854.2070501@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, SCSI development list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

On 12/23/2014 05:29 PM, Douglas Gilbert wrote:
> The last time these SCSI asc/ascq codes were synced with T10
> was 20130605. This patch is against lk 3.19.0-rc1 .
>=20
> ChangeLog:
>   sync the SCSI ASC/ASCQ number to string tables with those
>   found at http://www.t10.org/lists/asc-num.txt dated
>   20141221
>=20
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
Ah, good. I'll need that for my ZBC prototype.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
