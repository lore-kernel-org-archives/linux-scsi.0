From: Johannes Thumshirn <jthumshirn@suse.com>
Subject: Re: [PATCH 2/2] scsi_transport_fc: Implement 'async_user_scan'
 module parameter
Date: Tue, 1 Mar 2016 10:07:17 +0100
Message-ID: <20160301090717.GF4181@c203.arch.suse.de>
References: <1456127462-2817-1-git-send-email-hare@suse.de>
 <1456127462-2817-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43660 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbcCAJHT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2016 04:07:19 -0500
Content-Disposition: inline
In-Reply-To: <1456127462-2817-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On Mon, Feb 22, 2016 at 08:51:02AM +0100, Hannes Reinecke wrote:
> When invoking a scan via the sysfs 'scan' attribute the process
> will be blocked until the scan is completed, which can take a
> very long time on large installations.
> Enabling the 'async_user_scan' parameter moves the actual
> LUN scanning to a workqueue, thereby unblocking the process.
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
