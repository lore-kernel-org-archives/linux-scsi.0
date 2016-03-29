From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/2] Declare local symbols static
Date: Tue, 29 Mar 2016 08:41:41 +0200
Message-ID: <56FA23A5.3080609@suse.de>
References: <56F9740A.4060100@sandisk.com> <56F9743C.8040301@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38740 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117AbcC2Gln (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Mar 2016 02:41:43 -0400
In-Reply-To: <56F9743C.8040301@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 03/28/2016 08:13 PM, Bart Van Assche wrote:
> Avoid that building with W=3D1 causes gcc to report warnings about
> symbols that have not been declared.
>=20
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/scsi_sysfs.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
