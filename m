From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 5/6] scsi: move scsi_dispatch_cmd to scsi_lib.c
Date: Thu, 06 Nov 2014 09:25:21 +0100
Message-ID: <545B3071.6040303@suse.de>
References: <1415259630-20784-1-git-send-email-hch@lst.de> <1415259630-20784-6-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41727 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbaKFIZW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Nov 2014 03:25:22 -0500
In-Reply-To: <1415259630-20784-6-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>

On 11/06/2014 08:40 AM, Christoph Hellwig wrote:
> scsi_lib.c is where the rest of the I/O submission path lives, so mov=
e
> scsi_dispatch_cmd there and mark it static.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>

A round of applause for that.
One of the most annoying things when debugging.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
