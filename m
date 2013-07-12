From: Hannes Reinecke <hare@suse.de>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] scsi-mq prototype discussion
Date: Fri, 12 Jul 2013 12:52:37 +0200
Message-ID: <51DFDFF5.80702@suse.de>
References: <1373588612.7397.447.camel@haakon3.risingtidesystems.com>  <20130712010223.GA15673@kroah.com> <1373592815.7397.477.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1373592815.7397.477.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Greg KH <greg@kroah.com>, ksummit-2013-discuss@lists.linuxfoundation.org, Jens Axboe <axboe@kernel.dk>, James Smart <James.Smart@Emulex.Com>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, kmo@daterainc.com, target-devel <target-devel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>, scameron@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

On 07/12/2013 03:33 AM, Nicholas A. Bellinger wrote:
> On Thu, 2013-07-11 at 18:02 -0700, Greg KH wrote:
>> On Thu, Jul 11, 2013 at 05:23:32PM -0700, Nicholas A. Bellinger wrot=
e:
>>> Drilling down the work items ahead of a real mainline push is high =
on
>>> priority list for discussion.
>>>
>>> The parties to be included in such a discussion are:
>>>
>>>   - Jens Axboe (blk-mq author)
>>>   - James Bottomley (scsi maintainer)
>>>   - Christoph Hellwig (scsi)
>>>   - Martin Petersen (scsi)
>>>   - Tejun Heo (block + libata)
>>>   - Hannes Reinecke (scsi error recovery)
>>>   - Kent Overstreet (block, per-cpu ida)
>>>   - Stephen Cameron (scsi-over-pcie driver)
>>>   - Andrew Vasquez (qla2xxx LLD)
>>>   - James Smart (lpfc LLD)
>>
>> Isn't this something that should have been discussed at the storage
>> mini-summit a few months ago?
>=20
> The scsi-mq prototype, along with blk-mq (in it's current form) did n=
ot
> exist a few short months ago.  ;)
>=20
>>  It seems very specific to one subsystem to be a kernel summit topic=
,
>> don't you think?
>=20
> It's no more subsystem specific than half of the other proposals so f=
ar,
> and given it's reach across multiple subsystems (block, scsi, target)=
,
> and the amount of off-list interest on the topic, I think it would ma=
ke
> a good candidate for discussion.
>=20
And it'll open up new approaches which previously were dismissed,
like re-implementing multipathing on top of scsi-mq, giving us the
single scsi device like other UNIX systems.

Also I do think there's quite some synergy to be had, as with blk-mq
we could nail each queue to a processor, which would eliminate the
need for locking.
Which could be useful for other subsystems, too.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
