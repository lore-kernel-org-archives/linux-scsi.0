From: Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] [LSF/MM ATTEND] discuss blk-mq related to DM-multipath
 and status of XCOPY
Date: Wed, 07 Jan 2015 09:32:19 +0100
Message-ID: <54ACEF13.7000508@suse.de>
References: <CAMM=eLdGQ4wQDHy0ACzDsYOs0AYC+KAcx7Mx7FmpBTV293d41Q@mail.gmail.com>	<54AA90B1.1030201@suse.de> <yq17fwz8nwb.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59260 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755774AbbAGIcV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Jan 2015 03:32:21 -0500
In-Reply-To: <yq17fwz8nwb.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>, Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 01/07/2015 12:55 AM, Martin K. Petersen wrote:
>>>>>> "Hannes" =3D=3D Hannes Reinecke <hare@suse.de> writes:
>=20
> Hannes> Yep. That definitely needs to be discussed.  Especially we'd
> Hannes> need to discuss how to handle exceptions, seeing that XCOPY
> Hannes> might fail basically at any time. =20
>=20
> Like any SCSI command :)
>=20
Not quite. XCOPY is optional, and the system works well without it.
So the exception handling would need to copy things by hand to avoid
regressions.

Plus XCOPY requires some elaborate setup, and even if those succeeded
the array might still fail the command.
_And_ there is no guarantee that that the XCOPY command is actually
faster than the manual procedure.

I guess we'll need some timing / initialisation routine to figure
out what speed-up is to be had with XCOPY.

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
