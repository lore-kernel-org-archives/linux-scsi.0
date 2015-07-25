From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 09/20] scsi_dh_alua: switch to scsi_execute()
Date: Sat, 25 Jul 2015 17:44:41 +0200
Message-ID: <55B3AEE9.5060509@suse.de>
References: <1436346378-96518-1-git-send-email-hare@suse.de> <1436346378-96518-10-git-send-email-hare@suse.de> <20150724145343.GD29096@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56970 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932115AbbGYPon (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Jul 2015 11:44:43 -0400
In-Reply-To: <20150724145343.GD29096@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>

On 07/24/2015 04:53 PM, Christoph Hellwig wrote:
> Seems like this should use scsi_execute_req_flags instead so that it =
doesn't
> have to deal with the raw sense buffer.
>=20
Ok, I'll have a look here.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
