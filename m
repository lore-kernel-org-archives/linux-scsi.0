From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/4] scsi: bnx2fc: convert per-CPU thread to kworker
Date: Wed, 20 Jul 2016 14:13:53 +0200
Message-ID: <20160720121353.y2xxqfawrs3tm2sp@c203.arch.suse.de>
References: <1467734929-24442-1-git-send-email-bigeasy@linutronix.de>
 <20160720110421.5ocuquyqki2uggg4@c203.arch.suse.de>
 <323040c8-3b63-7e49-a492-e071610459fd@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47405 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905AbcGTMNz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jul 2016 08:13:55 -0400
Content-Disposition: inline
In-Reply-To: <323040c8-3b63-7e49-a492-e071610459fd@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-scsi@vger.kernel.org, jth@kernel.org, rt@linutronix.de, jejb@linux.vnet.ibm.com, "Martin K . Petersen" <martin.petersen@oracle.com>, QLogic-Storage-Upstream@qlogic.com, Christoph Hellwig <hch@lst.de>

On Wed, Jul 20, 2016 at 02:07:19PM +0200, Sebastian Andrzej Siewior wro=
te:
> On 07/20/2016 01:04 PM, Johannes Thumshirn wrote:
> > Hi Sebastian,
>=20
> Hi Johannes,
>=20
> > I've tried to test your series and unfortunately I encountered the =
following
> > oops.
> thanks for testing.
> =E2=80=A6
> >=20
> > I'll try to narrow it down to the specific patch, but currently I'm=
 a bit
> > busy, sorry.
>=20
> I looked over the patch and noticed nothing. It was possible to run t=
he
> worker but somehow the spinlock exploded.

Strange...

I'll re-apply the patches again, maybe something went wrong there.

Johannes

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=C3=BCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
