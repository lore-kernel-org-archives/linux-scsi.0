From: Hannes Reinecke <hare@suse.de>
Subject: Re: status of block-integrity
Date: Tue, 07 Jan 2014 08:17:47 +0100
Message-ID: <52CBAA1B.7000509@suse.de>
References: <20131222192128.GA28532@infradead.org> <52C6D0DB.1050906@suse.de> <yq1wqigzvc1.fsf@sermon.lab.mkp.net> <20140107013646.GB10297@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52223 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbaAGHRx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Jan 2014 02:17:53 -0500
In-Reply-To: <20140107013646.GB10297@birch.djwong.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, chuck.lever@oracle.com
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On 01/07/2014 02:36 AM, Darrick J. Wong wrote:
> On Fri, Jan 03, 2014 at 03:03:42PM -0500, Martin K. Petersen wrote:
>>>>>>> "Hannes" =3D=3D Hannes Reinecke <hare@suse.de> writes:
>>
>> Hannes> Personally, I doubt it's a good idea to kill it off, but a
>> Hannes> proper (userland) API for it has been a long time missing.
>>
>> Before we throw the baby out with the bath water, maybe Darrick can =
fill
>> us in on the progress of the aio passthrough interface?
>=20
> I haven't made much progress on it -- I haven't seen any earnest dema=
nd for it.
>=20
Of course not. Who should be demanding it? Application developer
tend to code to existing interfaces.

> Last year Chuck Lever said that some NFS working group was looking de=
fining an
> interface it... has there been any progress?  It doesn't sound like t=
here has
> been.
>=20
Well, the point is that without any defined (userland) interface
it's quite hard to pursuade any userland application developer to
use it.

Plus (as hch rightly pointed out) as there is no defined userland
interface the question is why we bother with all the DIX stuff
in the block layer.
DIF support would be perfectly sufficient to cover any connectivity
issues.

And one feels _really_ silly trying to convince customers from the
benefits of DIX they can't even use.
I've tried that several times, and it doesn't get better over time...

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
