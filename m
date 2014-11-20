From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 5/7] mpt2sas: simplify ->change_queue_depth
Date: Thu, 20 Nov 2014 08:39:51 +0100
Message-ID: <546D9AC7.8060301@suse.de>
References: <1415901546-8006-1-git-send-email-hch@lst.de> <1415901546-8006-6-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47289 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbaKTHjw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Nov 2014 02:39:52 -0500
In-Reply-To: <1415901546-8006-6-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: James Smart <james.smart@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>

On 11/13/2014 06:59 PM, Christoph Hellwig wrote:
> Merge two functions, and remove overly verbose debugging output that =
pokes
> into mid-layer internal structures.
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
