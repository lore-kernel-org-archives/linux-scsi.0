From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/2] fcoe: Rename 'fip_frame' to 'fip_vn2vn_notify_frame'
Date: Tue, 19 Jul 2016 13:50:57 +0200
Message-ID: <20160719115057.kf7c43leiopwn3rl@c203.arch.suse.de>
References: <1468928980-40549-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50297 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752995AbcGSLvC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jul 2016 07:51:02 -0400
Content-Disposition: inline
In-Reply-To: <1468928980-40549-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Johannes Thumshirn <jth@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Tue, Jul 19, 2016 at 01:49:39PM +0200, Hannes Reinecke wrote:
> Do not use a generic name to avoid confusions with other
> usages.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.com>

Very nice :-)


Acked-by: Johannes Thumshirn <jth@kernel.org>
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
