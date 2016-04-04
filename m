From: Ming Lin <mlin@kernel.org>
Subject: Re: [PATCH v2 0/5] mempool based chained scatterlist alloc/free api
Date: Sun, 3 Apr 2016 23:07:17 -0700
Message-ID: <CAF1ivSY-xbhv47a3UCDWmDb9PsUpTSOmXDyRmSAzMactbX_fxA@mail.gmail.com>
References: <1458684196-15923-1-git-send-email-mlin@kernel.org>
	<20160323074012.GA17929@lst.de>
	<CAF1ivSaxn7KbiLt0ByHoC-EyP-Q0ah33YGNv0rLoO-=sOvia5w@mail.gmail.com>
	<1458834360.2544.12.camel@HansenPartnership.com>
	<CAF1ivSbvrUUdMp60FAU6LURyCA9pkfaEzia+XB+1nfkDDW1WdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAF1ivSbvrUUdMp60FAU6LURyCA9pkfaEzia+XB+1nfkDDW1WdQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, lkml <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Mar 28, 2016 at 7:48 AM, Ming Lin <mlin@kernel.org> wrote:
> On Thu, Mar 24, 2016 at 8:46 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
>> On Thu, 2016-03-24 at 08:09 -0700, Ming Lin wrote:
>>> On Wed, Mar 23, 2016 at 12:40 AM, Christoph Hellwig <hch@lst.de>
>>> wrote:
>>> > On Tue, Mar 22, 2016 at 03:03:11PM -0700, Ming Lin wrote:
>>> > > From: Ming Lin <ming.l@ssi.samsung.com>
>>> > >
>>> > > The fist 4 patches make the SG related
>>> > > definitions/structs/functions
>>> > > in SCSI code generic and the last patch move it to lib/sg_pool.=
c.
>>> > >
>>> > > I still keep the macro "SG_MEMPOOL_NR" since it's used in 3
>>> > > places.
>>> >
>>> > I don't =D1=95ee the point, but I'm not going to block the series=
 over
>>> > it either.
>>> >
>>> > The new series looks really nice to me!
>>> >
>>> > Reviewed-by: Christoph Hellwig <hch@lst.de>
>>>
>>> Hi James,
>>>
>>> This series touches several sub-systems.
>>> What's the best way to merge it?
>>
>> It has a minor intrusion into
>>
>>  drivers/ata/pata_icside.c           |   2 +-
>>  drivers/infiniband/ulp/srp/ib_srp.c |   4 +-
>>  drivers/usb/storage/scsiglue.c      |   2 +-
>>
>> Apart from that, it's all SCSI, so the SCSI tree would seem to be th=
e
>> best one.
>
> Are you OK to merge it?

Hi James,

Ping ...

Are you OK to apply this series?
Or any changes needed?

Thanks.

>
> Thanks.
