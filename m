From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv4 1/1] SCSI: hosts: update to use ida_simple for host_no
 management
Date: Mon, 16 Nov 2015 13:10:06 +0100
Message-ID: <5649C79E.9070603@suse.de>
References: <cover.1444241058.git.lduncan@suse.com>	<f89fe3933ae899dc01f2eddd2a0cefac3383cf3c.1444241058.git.lduncan@suse.com>	<1444830904.2220.28.camel@HansenPartnership.com>	<561EA018.7020700@suse.com>	<1444848835.2220.50.camel@HansenPartnership.com>	<5644BEE1.3010208@suse.com> <yq1ziyhy38c.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1ziyhy38c.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Lee Duncan <lduncan@suse.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On 11/13/2015 10:54 PM, Martin K. Petersen wrote:
>>>>>> "Lee" =3D=3D Lee Duncan <lduncan@suse.com> writes:
>=20
>>> Well, I'm a bit worried about the loss of a monotonically increasin=
g
>>> host number from the debugging perspective.  Right now, if you look
>>> at any log, hostX always refers to one and only one incarnation
>>> throughout the system lifetime for any given value of X.
>=20
> That's a feature that I would absolutely hate to lose. I spend a huge
> amount of time looking at system logs.
>=20
Right. Then have it enabled via a modprobe parameters.

We actually had customers running into a host_no overflow due to
excessive host allocations and freeing done by iSCSI.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
