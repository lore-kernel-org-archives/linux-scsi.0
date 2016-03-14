From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi: disable automatic target scan
Date: Mon, 14 Mar 2016 09:08:27 +0100
Message-ID: <20160314080827.GO16624@c203.arch.suse.de>
References: <1457710420-37769-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58115 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933735AbcCNII3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Mar 2016 04:08:29 -0400
Content-Disposition: inline
In-Reply-To: <1457710420-37769-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On Fri, Mar 11, 2016 at 04:33:40PM +0100, Hannes Reinecke wrote:
> On larger installations it is useful to disable automatic LUN
> scanning, and only add the required LUNs via udev rules.
> This can speed up bootup dramatically.
>=20
> This patch introduces a scan_type 'disabled', which work like
> 'none', but can be overriden by setting the 'rescan' value
> from scsi_scan_target to '2'.
> And it updates all relevant callers to set the 'rescan' value
> to '2' if invoked via the 'scan' option in sysfs.
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
