From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] scsi-mq prototype discussion
Date: Thu, 11 Jul 2013 18:33:35 -0700
Message-ID: <1373592815.7397.477.camel@haakon3.risingtidesystems.com>
References: <1373588612.7397.447.camel@haakon3.risingtidesystems.com>
	 <20130712010223.GA15673@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130712010223.GA15673@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: ksummit-2013-discuss@lists.linuxfoundation.org, Jens Axboe <axboe@kernel.dk>, James Smart <James.Smart@Emulex.Com>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, kmo@daterainc.com, target-devel <target-devel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>, scameron@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

On Thu, 2013-07-11 at 18:02 -0700, Greg KH wrote:
> On Thu, Jul 11, 2013 at 05:23:32PM -0700, Nicholas A. Bellinger wrote:
> > Drilling down the work items ahead of a real mainline push is high on
> > priority list for discussion.
> > 
> > The parties to be included in such a discussion are:
> > 
> >   - Jens Axboe (blk-mq author)
> >   - James Bottomley (scsi maintainer)
> >   - Christoph Hellwig (scsi)
> >   - Martin Petersen (scsi)
> >   - Tejun Heo (block + libata)
> >   - Hannes Reinecke (scsi error recovery)
> >   - Kent Overstreet (block, per-cpu ida)
> >   - Stephen Cameron (scsi-over-pcie driver)
> >   - Andrew Vasquez (qla2xxx LLD)
> >   - James Smart (lpfc LLD)
> 
> Isn't this something that should have been discussed at the storage
> mini-summit a few months ago?

The scsi-mq prototype, along with blk-mq (in it's current form) did not
exist a few short months ago.  ;)

>  It seems very specific to one subsystem to be a kernel summit topic,
> don't you think?

It's no more subsystem specific than half of the other proposals so far,
and given it's reach across multiple subsystems (block, scsi, target),
and the amount of off-list interest on the topic, I think it would make
a good candidate for discussion.

Thanks,

--nab 
