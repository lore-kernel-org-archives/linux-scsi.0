From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/5] scsi_dh_alua: add 'state' callback function
Date: Sat, 25 Jul 2015 17:42:09 +0200
Message-ID: <55B3AE51.9080405@suse.de>
References: <1436353788-104911-1-git-send-email-hare@suse.de> <1436353788-104911-5-git-send-email-hare@suse.de> <20150724144231.GB28970@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56776 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754927AbbGYPmN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Jul 2015 11:42:13 -0400
In-Reply-To: <20150724144231.GB28970@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>

On 07/24/2015 04:42 PM, Christoph Hellwig wrote:
> As per the comment on patch 3 I'd rather expose the ALUA state in the=
 core
> SCSI code.  But having this alua_state attribute in core SCSI code so=
unds
> fine to me.
>=20
Sure, we can have an attribute 'alua_state' in the core code; after all=
,
ALUA is pretty much standard by now.

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
