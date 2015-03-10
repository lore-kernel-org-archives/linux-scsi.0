From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/3] scsi: proper state checking and module refcount handling
 in scsi_device_get
Date: Tue, 10 Mar 2015 12:22:42 -0400
Message-ID: <54FF1A52.40700@suse.de>
References: <1422882086-1863-1-git-send-email-hch@lst.de> <1422882086-1863-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53365 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbbCJQWq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Mar 2015 12:22:46 -0400
In-Reply-To: <1422882086-1863-3-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>, Alan Stern <stern@rowland.harvard.edu>

On 02/02/2015 08:01 AM, Christoph Hellwig wrote:
> This effectively reverts commits 85b6c7 ("[SCSI] sd: fix cache flushi=
ng on
> module removal (and individual device removal)" and dc4515ea ("scsi: =
always
> increment reference count").
>=20
> We now never call scsi_device_get from the shutdown path, and the fac=
t
> that we started grabbing reference there in commit 85b6c7 turned out
> turned out to create more problems than it solves, and required
> workarounds for workarounds for workarounds. Move back to properly ch=
ecking
> the device state and carefully handle module refcounting.
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
