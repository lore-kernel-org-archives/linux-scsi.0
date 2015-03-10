From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/3] sd: don't grab a device references from driver methods
Date: Tue, 10 Mar 2015 12:21:56 -0400
Message-ID: <54FF1A24.10900@suse.de>
References: <1422882086-1863-1-git-send-email-hch@lst.de> <1422882086-1863-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53320 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932457AbbCJQWA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Mar 2015 12:22:00 -0400
In-Reply-To: <1422882086-1863-2-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>, Alan Stern <stern@rowland.harvard.edu>

On 02/02/2015 08:01 AM, Christoph Hellwig wrote:
> The device model already takes care of races between ->remove and
> ->shutdown vs its other methods, and we now take care about locking
> them out for ->rescan as well.
>=20
> This is a partial revert of commit 39b7f1 ("[SCSI] sd: Fix refcountin=
g").
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
