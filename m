From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/9] dm-mpath, scsi_dh: don't let dm detach device handlers
Date: Fri, 01 May 2015 09:10:26 +0200
Message-ID: <554326E2.9070704@suse.de>
References: <1430415151-30948-1-git-send-email-hch@lst.de> <1430415151-30948-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59727 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbbEAHK3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 May 2015 03:10:29 -0400
In-Reply-To: <1430415151-30948-3-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: Mike Snitzer <snitzer@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 04/30/2015 07:32 PM, Christoph Hellwig wrote:
> While allowing dm-mpath to attach device handlers is a functionality =
we need
> for backwards compatibility reason there is no reason to reference co=
unt
> them and detach them if dm-mpath stops using the device for some reas=
on.
>=20
> If the device handler works for the given device it can just stay att=
ached.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
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
