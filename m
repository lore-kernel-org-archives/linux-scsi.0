From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] scsi-mq prototype discussion
Date: Fri, 19 Jul 2013 10:01:43 -0400
Message-ID: <51E946C7.3020502@redhat.com>
References: <1373588612.7397.447.camel@haakon3.risingtidesystems.com> <20130712010223.GA15673@kroah.com> <1373592815.7397.477.camel@haakon3.risingtidesystems.com> <51DFDFF5.80702@suse.de> <1373698410.2922.10.camel@dabdike> <1374008849.7397.853.camel@haakon3.risingtidesystems.com> <20130716211529.GQ22392@kernel.dk> <1374036751.2045.20.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1374036751.2045.20.camel@dabdike>
Sender: target-devel-owner@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Jens Axboe <axboe@kernel.dk>, "ksummit-2013-discuss@lists.linuxfoundation.org" <ksummit-2013-discuss@lists.linuxfoundation.org>, James Smart <James.Smart@Emulex.Com>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>, "kmo@daterainc.com" <kmo@daterainc.com>, target-devel <target-devel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>, Andrew Vasquez <andrew.vasquez@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

On 07/17/2013 12:52 AM, James Bottomley wrote:
> On Tue, 2013-07-16 at 15:15 -0600, Jens Axboe wrote:
>> On Tue, Jul 16 2013, Nicholas A. Bellinger wrote:
>>> On Sat, 2013-07-13 at 06:53 +0000, James Bottomley wrote:
>>>> On Fri, 2013-07-12 at 12:52 +0200, Hannes Reinecke wrote:
>>>>> On 07/12/2013 03:33 AM, Nicholas A. Bellinger wrote:
>>>>>> On Thu, 2013-07-11 at 18:02 -0700, Greg KH wrote:
>>>>>>> On Thu, Jul 11, 2013 at 05:23:32PM -0700, Nicholas A. Bellinger wrote:
>>>>>>>> Drilling down the work items ahead of a real mainline push is high on
>>>>>>>> priority list for discussion.
>>>>>>>>
>>>>>>>> The parties to be included in such a discussion are:
>>>>>>>>
>>>>>>>>    - Jens Axboe (blk-mq author)
>>>>>>>>    - James Bottomley (scsi maintainer)
>>>>>>>>    - Christoph Hellwig (scsi)
>>>>>>>>    - Martin Petersen (scsi)
>>>>>>>>    - Tejun Heo (block + libata)
>>>>>>>>    - Hannes Reinecke (scsi error recovery)
>>>>>>>>    - Kent Overstreet (block, per-cpu ida)
>>>>>>>>    - Stephen Cameron (scsi-over-pcie driver)
>>>>>>>>    - Andrew Vasquez (qla2xxx LLD)
>>>>>>>>    - James Smart (lpfc LLD)
>>>>>>> Isn't this something that should have been discussed at the storage
>>>>>>> mini-summit a few months ago?
>>>>>> The scsi-mq prototype, along with blk-mq (in it's current form) did not
>>>>>> exist a few short months ago.  ;)
>>>>>>
>>>>>>>   It seems very specific to one subsystem to be a kernel summit topic,
>>>>>>> don't you think?
>>>>>> It's no more subsystem specific than half of the other proposals so far,
>>>>>> and given it's reach across multiple subsystems (block, scsi, target),
>>>>>> and the amount of off-list interest on the topic, I think it would make
>>>>>> a good candidate for discussion.
>>>>>>
>>>>> And it'll open up new approaches which previously were dismissed,
>>>>> like re-implementing multipathing on top of scsi-mq, giving us the
>>>>> single scsi device like other UNIX systems.
>>>>>
>>>>> Also I do think there's quite some synergy to be had, as with blk-mq
>>>>> we could nail each queue to a processor, which would eliminate the
>>>>> need for locking.
>>>>> Which could be useful for other subsystems, too.
>>>> Lets start with discussing this on the list, please, and then see where
>>>> we go from there ...
>>>>
>>> Yes, the discussion is beginning to make it's way to the list.  I've
>>> mostly been waiting for blk-mq to get a wider review before taking the
>>> early scsi-mq prototype driver to a larger public audience.
>>>
>>> Primarily, I'm now reaching out to the people most effected by existing
>>> scsi_request_fn() based performance limitations.  Most of them have
>>> abandoned existing scsi_request_fn() based logic in favor of raw block
>>> make_request() based drivers, and are now estimating the amount of
>>> effort to move to an scsi-mq based approach.
>>>
>>> Regardless, as the prototype progresses over the next months, having a
>>> face-to-face discussion with the key parties in the room would be very
>>> helpful given the large amount of effort involved to actually make this
>>> type of generational shift in SCSI actually happen.
>> There's a certain amount of overlap with the aio/O_DIRECT work as well.
>> But if it's not a general session, could always be a BOF or something.
>>
>> I'll second the argument that most technical topics probably DO belong
>> in a topic related workshop. But that leaves us with basically only
>> process related topics at KS, I don't think it hurts to have a bit of
>> tech meat on the bone too. At least I personally miss that part of KS
>> from years gone by.
> Heh well, given that most of the block mq discussions at LSF have been
> you saying you really should get around to cleaning up and posting the
> code, you'll understand my wanting to see that happen first ...
>
> I suppose we could try to run a storage workshop within KS, but I think
> most of the mini summit slots have already gone.  There's also plumbers
> if all slots are gone (I would say that, being biased and on the
> programme committee) Ric is running the storage and Filesystems MC
>
> http://www.linuxplumbersconf.org/2013/ocw/events/LPC2013/tracks/159
>
> James
>

And we still are looking for suggested topics - it would be great to have the 
multi-queue work at plumbers.

You can post a proposal for it (or other topics) here:

http://www.linuxplumbersconf.org/2013/ocw/events/LPC2013/proposals

Ric
