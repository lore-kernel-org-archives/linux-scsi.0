From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] scsi-mq prototype discussion
Date: Fri, 19 Jul 2013 15:06:01 -0700
Message-ID: <1374271561.7397.1089.camel@haakon3.risingtidesystems.com>
References: <1373588612.7397.447.camel@haakon3.risingtidesystems.com>
	 <20130712010223.GA15673@kroah.com>
	 <1373592815.7397.477.camel@haakon3.risingtidesystems.com>
	 <51DFDFF5.80702@suse.de> <1373698410.2922.10.camel@dabdike>
	 <1374008849.7397.853.camel@haakon3.risingtidesystems.com>
	 <20130716211529.GQ22392@kernel.dk> <1374036751.2045.20.camel@dabdike>
	 <1374268967.7397.1075.camel@haakon3.risingtidesystems.com>
	 <1374270366.2266.70.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1374270366.2266.70.camel@dabdike>
Sender: target-devel-owner@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Jens Axboe <axboe@kernel.dk>, Mike Christie <michaelc@cs.wisc.edu>, "ksummit-2013-discuss@lists.linuxfoundation.org" <ksummit-2013-discuss@lists.linuxfoundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Smart <James.Smart@Emulex.Com>, LKML <linux-kernel@vger.kernel.org>, "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>, "kmo@daterainc.com" <kmo@daterainc.com>, target-devel <target-devel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>, Andrew Vasquez <andrew.vasquez@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2013-07-19 at 21:46 +0000, James Bottomley wrote:
> On Fri, 2013-07-19 at 14:22 -0700, Nicholas A. Bellinger wrote:
> > On Wed, 2013-07-17 at 04:52 +0000, James Bottomley wrote:
> > > On Tue, 2013-07-16 at 15:15 -0600, Jens Axboe wrote:
> > > > On Tue, Jul 16 2013, Nicholas A. Bellinger wrote:
> > > > > On Sat, 2013-07-13 at 06:53 +0000, James Bottomley wrote:
> > 
> > <SNIP>
> > 
> > > > > > Lets start with discussing this on the list, please, and then see where
> > > > > > we go from there ...
> > > > > > 
> > > > > 
> > > > > Yes, the discussion is beginning to make it's way to the list.  I've
> > > > > mostly been waiting for blk-mq to get a wider review before taking the
> > > > > early scsi-mq prototype driver to a larger public audience.
> > > > > 
> > > > > Primarily, I'm now reaching out to the people most effected by existing
> > > > > scsi_request_fn() based performance limitations.  Most of them have
> > > > > abandoned existing scsi_request_fn() based logic in favor of raw block
> > > > > make_request() based drivers, and are now estimating the amount of
> > > > > effort to move to an scsi-mq based approach.
> > > > > 
> > > > > Regardless, as the prototype progresses over the next months, having a
> > > > > face-to-face discussion with the key parties in the room would be very
> > > > > helpful given the large amount of effort involved to actually make this
> > > > > type of generational shift in SCSI actually happen.
> > > > 
> > > > There's a certain amount of overlap with the aio/O_DIRECT work as well.
> > > > But if it's not a general session, could always be a BOF or something.
> > > > 
> > > > I'll second the argument that most technical topics probably DO belong
> > > > in a topic related workshop. But that leaves us with basically only
> > > > process related topics at KS, I don't think it hurts to have a bit of
> > > > tech meat on the bone too. At least I personally miss that part of KS
> > > > from years gone by.
> > > 
> > > Heh well, given that most of the block mq discussions at LSF have been
> > > you saying you really should get around to cleaning up and posting the
> > > code, you'll understand my wanting to see that happen first ...
> > > 
> > > I suppose we could try to run a storage workshop within KS, but I think
> > > most of the mini summit slots have already gone.
> > 
> > That would be great, given there is a reasonable level of interest from
> > various parities, and the pain threshold for existing scsi small block
> > random I/O performance is high..
> > 
> > When will we know if there is a workshop / mini summit slot available..?
> > 
> > (CC'ing Mike Christie as well for open-iscsi/scsi-mq bits)
> > 
> > > There's also plumbers
> > > if all slots are gone (I would say that, being biased and on the
> > > programme committee) Ric is running the storage and Filesystems MC
> > > 
> > > http://www.linuxplumbersconf.org/2013/ocw/events/LPC2013/tracks/159
> > 
> > FYI, I'm not trying to 'sell' scsi-mq to the larger community yet, but
> > rather interested in getting the right scsi/block/LLD people in the same
> > room at KS for an hour or two to discuss implementation details, given
> > the scope of the effort involved.
> 
> Well, so that's why I think plumbers might be a better venue: we'll have
> more of the actual storage people there.  Usually we get at most 2-3
> storage people to KS compared to the 25 or so we usually have at LSF ...
> that makes KS not a very good venue for storage centric discussions.
> 

The most relevant people for the discussion are Jens, Hannes, Christoph,
Tejun, Martin, Mike, and you.

I know these folks are regular attendees for KS, but typically not for
plumbers, which is why I made this KS topic proposal in the first place.

--nab
