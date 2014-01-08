From: Hannes Reinecke <hare@suse.de>
Subject: Re: status of block-integrity
Date: Wed, 08 Jan 2014 08:14:35 +0100
Message-ID: <52CCFADB.6080909@suse.de>
References: <20131222192128.GA28532@infradead.org> <52C6D0DB.1050906@suse.de>	<yq1wqigzvc1.fsf@sermon.lab.mkp.net>	<20140107013646.GB10297@birch.djwong.org> <52CBAA1B.7000509@suse.de> <yq1a9f7wjqr.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47859 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbaAHHOh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jan 2014 02:14:37 -0500
In-Reply-To: <yq1a9f7wjqr.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, chuck.lever@oracle.com, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On 01/07/2014 10:43 PM, Martin K. Petersen wrote:
>>>>>> "Hannes" =3D=3D Hannes Reinecke <hare@suse.de> writes:
>=20
> Hannes> Plus (as hch rightly pointed out) as there is no defined
> Hannes> userland interface the question is why we bother with all the
> Hannes> DIX stuff in the block layer. =20
>=20
> Because it catches problems in the path between block layer and HBA
> ASIC? FWIW, we find more issues there than we do between initiator an=
d
> target.
>=20
But how should it do that exactly?
As there is no user (apart from oracleasm) no-one can attach
protection information to any data, so even the most dedicated admin
cannot exercise this path, let alone find issues here.

> API issues aside, another reason adoption has been slow is that very =
few
> applications truly care about this stuff. The current approach in whi=
ch
> data is protected when the I/O is submitted by the filesystem is good
> enough for most things. Saves the filesystem people the trouble of
> dealing with it too.
>=20
> In reality there are only a handful of applications that would actual=
ly
> benefit from an explicit userland API. Mostly in the database
> department. All the potential consumers of an interface I talked to
> wanted to use aio so that's why we've focused our efforts there.
>=20
aio is perfectly fine; all I care is to have _any_ way of feeding
protection information into the kernel.

> Both Darrick and I have been busy with other projects the last little
> while. I'll start looking at this again when I'm done with copy
> offload...
>=20
Speaking of which, are there any patches?
Doug Gilbert and I are currently discussing LID4 / ROD Token copy
for sg3_utils and the block layer, so any patches would be very
helpful here.

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
