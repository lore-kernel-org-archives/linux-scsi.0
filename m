From: Johannes Thumshirn <jthmshirn@suse.de>
Subject: Re: [PATCH] libfc: replace 'rp_mutex' with 'rp_lock'
Date: Mon, 9 May 2016 14:29:54 +0200
Message-ID: <20160509122954.GA22590@c203.arch.suse.de>
References: <1461571293-953-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35512 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbcEIMaB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 May 2016 08:30:01 -0400
Content-Disposition: inline
In-Reply-To: <1461571293-953-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On Mon, Apr 25, 2016 at 10:01:33AM +0200, Hannes Reinecke wrote:
> We cannot use an embedded mutex in a structure with reference
> counting, as mutex unlock might be delayed, and the waiters
> might then access an already freed memory area.
> So convert it to a spinlock.
>=20
> For details cf https://lkml.org/lkml/2015/2/11/245
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
