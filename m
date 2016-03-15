From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: vpd pages are mandatory for SPC-2
Date: Tue, 15 Mar 2016 08:28:42 +0100
Message-ID: <56E7B9AA.3020302@suse.de>
References: <1457703965-71028-1-git-send-email-hare@suse.de>
 <yq137rshbrr.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53469 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147AbcCOH2o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Mar 2016 03:28:44 -0400
In-Reply-To: <yq137rshbrr.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, James Bottomley <james.bottomley@hansenpartnership.com>, Hannes Reinecke <hare@suse.com>

On 03/15/2016 12:37 AM, Martin K. Petersen wrote:
>>>>>> "Hannes" =3D=3D Hannes Reinecke <hare@suse.de> writes:
>=20
> Hannes,
>=20
> Hannes> VPD pages 0x0 and 0x83 are mandatory even for SPC-2, so we
> Hannes> should be lowering the restriction to avoid having to whiteli=
st
> Hannes> every SPC-2 compliant device.
>=20
> I wonder how many non-compliant devices we would have to blacklist as=
 a
> result of this change...
>=20
But it feels even sillier having to whitelist every
standards-conformant device here; I certainly was when I figured
that EMC Clariion won't work properly without this patch.

And the idea was to mark off _misbehaving_ drives, not the other way
round.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
