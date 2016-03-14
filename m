From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] Avoid that long log lines are truncated
Date: Mon, 14 Mar 2016 15:32:36 +0100
Message-ID: <20160314143236.GC14621@c203.arch.suse.de>
References: <56E6C88B.6010201@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52154 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932705AbcCNOck (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Mar 2016 10:32:40 -0400
Content-Disposition: inline
In-Reply-To: <56E6C88B.6010201@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Robert Elliott <Elliott@hp.com>, "Ewan D. Milne" <emilne@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, Mar 14, 2016 at 07:19:55AM -0700, Bart Van Assche wrote:
> While testing the latest version of the SRP initiator and target
> drivers I encountered the following message in the kernel log:
>=20
> sd 16:0:0:0: Warning! Received an indication that the LUN assignments=
 on this target have changed. The Linux SCSI layer does not automatical
>=20
> This is a truncated message. Avoid that such truncation happens
> by increasing the SCSI_LOG_BUFSIZE constant.
>=20
> Fixes: ded85c193a39 (scsi: Implement per-cpu logging buffer)
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>

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
