From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/5] scsi: rescan VPD attributes
Date: Sat, 25 Jul 2015 17:42:43 +0200
Message-ID: <55B3AE73.7060501@suse.de>
References: <1436353788-104911-1-git-send-email-hare@suse.de> <1436353788-104911-2-git-send-email-hare@suse.de> <20150724143834.GA28970@lst.de> <55B24E6A.6030904@suse.de> <20150724144348.GA29080@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56791 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754927AbbGYPmp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Jul 2015 11:42:45 -0400
In-Reply-To: <20150724144348.GA29080@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>

On 07/24/2015 04:43 PM, Christoph Hellwig wrote:
> On Fri, Jul 24, 2015 at 04:40:42PM +0200, Hannes Reinecke wrote:
>> Yeah, possibly. After all, the variable isn't expected to change
>> under rcu_read_lock().
>=20
> Actually it can and will change, that's the point.  But if you use
> a local variable you keep a single version of it, which won't be
> freed until after rcu_read_unlock.
>=20
Yeah, I figured this as well. Will be updating the patch.

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
