From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/6] scsi: clean up S/G table freeing
Date: Thu, 06 Nov 2014 09:23:30 +0100
Message-ID: <545B3002.4050207@suse.de>
References: <1415259630-20784-1-git-send-email-hch@lst.de> <1415259630-20784-4-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41676 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070AbaKFIXb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Nov 2014 03:23:31 -0500
In-Reply-To: <1415259630-20784-4-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>

On 11/06/2014 08:40 AM, Christoph Hellwig wrote:
> Now that we are using the split completion model for the legacy reque=
st
> path as well we can use scsi_mq_free_sgtables unconditionally.
>=20
> Rename it to scsi_free_sgtables, use it for the legacy path and remov=
e
> scsi_release_(bidi_)buffers.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
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
