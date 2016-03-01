From: Johannes Thumshirn <jthumshirn@suse.com>
Subject: Re: [PATCH 1/2] scsi_transport_fc: implement 'disable_target_scan'
 module parameter
Date: Tue, 1 Mar 2016 10:06:51 +0100
Message-ID: <20160301090651.GE4181@c203.arch.suse.de>
References: <1456127462-2817-1-git-send-email-hare@suse.de>
 <1456127462-2817-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43578 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbcCAJGz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2016 04:06:55 -0500
Content-Disposition: inline
In-Reply-To: <1456127462-2817-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On Mon, Feb 22, 2016 at 08:51:01AM +0100, Hannes Reinecke wrote:
> On larger installations it makes sense to disable the target scan
> per default on boot, and scan the required LUNs directly via udev
> rules.
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
