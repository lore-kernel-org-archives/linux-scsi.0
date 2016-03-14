From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCHv2] scsi_transport_sas: add 'scsi_target_id' sysfs
 attribute
Date: Mon, 14 Mar 2016 10:46:09 +0100
Message-ID: <20160314094609.GY16624@c203.arch.suse.de>
References: <1457948588-14558-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42473 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194AbcCNJqM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Mar 2016 05:46:12 -0400
Content-Disposition: inline
In-Reply-To: <1457948588-14558-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Manoj Kumar <manoj@linux.vnet.ibm.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Mon, Mar 14, 2016 at 10:43:08AM +0100, Hannes Reinecke wrote:
> There is no way to detect the scsi_target_id for any given SAS
> remote port, so add a new sysfs attribute 'scsi_target_id'.
>=20
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
