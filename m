From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 0/6] fcoe: VN2VN target mode fixes
Date: Mon, 25 Jul 2016 09:34:45 +0200
Message-ID: <20160725073445.uwn777ntd6elrgtt@c203.arch.suse.de>
References: <1467620963-67047-1-git-send-email-hare@suse.de>
 <yq1furdm0iy.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53311 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752379AbcGYHer (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jul 2016 03:34:47 -0400
Content-Disposition: inline
In-Reply-To: <yq1furdm0iy.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On Wed, Jul 13, 2016 at 10:11:33PM -0400, Martin K . Petersen wrote:
> >>>>> "Hannes" =3D=3D Hannes Reinecke <hare@suse.de> writes:
>=20
> Hannes> Hi all, When setting up a VN2VN FCoE target there is no real
> Hannes> need to run fcoeadm, especially if DCB is disabled.  So this
> Hannes> patchset implements a VIP VLAN responder which can be enabled=
 by
> Hannes> writing to the sysfs attribute 'fip_vlan_responder'.
> Hannes> Additionally there are some fixes for VN2VN mode, most notabl=
y
> Hannes> the multicast address update when changing modes.
>=20
> Applied patches 1-4 to 4.8/scsi-queue.

Hi Martin,

I've now Acked patches 5 and 6 as well, Hannes' answers clarified my co=
ncerns.
Can you pick 'em up for 4.8 as well?

Thanks,
	Johannes

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
