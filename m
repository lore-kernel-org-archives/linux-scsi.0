From: Johannes Thumshirn <jthmshirn@suse.de>
Subject: Re: [PATCH] libfc: unsafe refcounting in fc_rport_work()
Date: Wed, 20 Apr 2016 16:17:00 +0200
Message-ID: <20160420141700.GG28402@c203.arch.suse.de>
References: <1461158661-97688-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42893 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753988AbcDTORE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Apr 2016 10:17:04 -0400
Content-Disposition: inline
In-Reply-To: <1461158661-97688-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On Wed, Apr 20, 2016 at 03:24:21PM +0200, Hannes Reinecke wrote:
> When pushing items on a workqueue we cannot take reference
> when the workqueue item is executed, as the structure might
> already been freed at that time.
> So instead we need to take a reference before adding it
> to the workqueue, thereby ensuring that the workqueue item
> will always be valid.
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
