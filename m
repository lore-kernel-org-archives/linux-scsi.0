From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH] scsi: vpd pages are mandatory for SPC-2
Date: Wed, 16 Mar 2016 08:38:39 +0100
Message-ID: <56E90D7F.7080106@suse.com>
References: <1457703965-71028-1-git-send-email-hare@suse.de>
 <yq137rshbrr.fsf@sermon.lab.mkp.net> <56E7B9AA.3020302@suse.de>
 <yq1pouve84o.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60439 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004AbcCPHil (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Mar 2016 03:38:41 -0400
In-Reply-To: <yq1pouve84o.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, James Bottomley <james.bottomley@hansenpartnership.com>

On 03/15/2016 10:36 PM, Martin K. Petersen wrote:
>>>>>> "Hannes" =3D=3D Hannes Reinecke <hare@suse.de> writes:
>=20
>>> I wonder how many non-compliant devices we would have to blacklist =
as
>>> a result of this change...
>=20
> Hannes> But it feels even sillier having to whitelist every
> Hannes> standards-conformant device here; I certainly was when I figu=
red
> Hannes> that EMC Clariion won't work properly without this patch.
>=20
> Hannes> And the idea was to mark off _misbehaving_ drives, not the ot=
her
> Hannes> way round.
>=20
> I understand. But my concern is that the number of broken USB doodad
> model strings far outnumber enterprise storage vendor ditto. And ther=
e
> is no point in reversing the polarity if it increases the maintenance
> burden.
>=20
> So I would be more comfortable with just widening the VPD whitelist a=
nd
> assume that everything with an EMC, Dell, NetApp, whatever vendor ID =
is
> compliant.
>=20
Well, yes, that's the bugger. You never know until you try.

But we have been asking for VPD pages per default for quite some
time now from userspace (thanks to udev), and so far have had only a
few bug reports for misbehaving devices.

And again, it just feels wrong to punish every well-behaved device
out there, for the sake of some buggy USB implementation of a few
bucks worth.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
