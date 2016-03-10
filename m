From: Johannes Thumshirn <jthumshirn@suse.com>
Subject: Re: [PATCH] scsi_sysfs: Fix typo in is_bin_visible()
Date: Thu, 10 Mar 2016 11:40:34 +0100
Message-ID: <20160310104034.GD16624@c203.arch.suse.de>
References: <1457605526-112163-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57356 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753450AbcCJKkh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Mar 2016 05:40:37 -0500
Content-Disposition: inline
In-Reply-To: <1457605526-112163-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Thu, Mar 10, 2016 at 11:25:26AM +0100, Hannes Reinecke wrote:
> The test for the existence vpd_pg83 is inverted.
>=20
> Fixes: 7e47976bcff ("scsi_sysfs: add 'is_bin_visible' callback")
> Signed-off-by: Hannes Reinecke <hare@suse.com>

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
