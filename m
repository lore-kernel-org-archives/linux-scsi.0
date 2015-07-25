From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 04/20] scsi_dh_alua: Improve error handling
Date: Sat, 25 Jul 2015 17:42:57 +0200
Message-ID: <55B3AE81.8090603@suse.de>
References: <1436346378-96518-1-git-send-email-hare@suse.de> <1436346378-96518-5-git-send-email-hare@suse.de> <20150724144802.GA29096@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56808 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754880AbbGYPm7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Jul 2015 11:42:59 -0400
In-Reply-To: <20150724144802.GA29096@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>

On 07/24/2015 04:48 PM, Christoph Hellwig wrote:
> This seems to be a bit of a catchall.  Can you split the logging chan=
ges
> from actual error code logic changes and describe the latter in more =
detail?
>=20
Ok.

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
