From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/7] scsi: avoid ->change_queue_depth indirection for
 queue full tracking
Date: Thu, 20 Nov 2014 08:34:39 +0100
Message-ID: <546D998F.1060509@suse.de>
References: <1415901546-8006-1-git-send-email-hch@lst.de> <1415901546-8006-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47204 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754697AbaKTHel (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Nov 2014 02:34:41 -0500
In-Reply-To: <1415901546-8006-3-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: James Smart <james.smart@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>

On 11/13/2014 06:59 PM, Christoph Hellwig wrote:
> All drivers use the implementation for ramping the queue up and down,=
 so
> instead of overloading the change_queue_depth method call the
> implementation diretly if the driver opts into it by setting the
> track_queue_depth flag in the host template.
>=20
> Note that a few drivers validated the new queue depth in their
> change_queue_depth method, but as we never go over the queue depth
> set during slave_configure or the sysfs file this isn't nessecary
> and can safely be removed.
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
