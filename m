From: Andre Hedrick <andre@linux-ide.org>
Subject: Re: [PATCH] SAM-3 status codes
Date: Thu, 23 Jan 2003 00:24:28 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.10.10301230007110.20139-100000@master.linux-ide.org>
References: <20030123074845.GS910@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030123074845.GS910@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Douglas Gilbert <dougg@torque.net>, linux-scsi@vger.kernel.org


Jens,

One of the problems is chasing down all the  variations of SAM and pre
SAM.  I do not know, and maybe Doug can help, but did bit0 become
obsoleted in the age of SASI's transformation to SCSI ?

I can not find anything about it, and my knowledge in the history of SCSI
is vastly weaker then ATA during the X3 split.

The naming issue is what stopped me in the process of working on a
bus-phase rewrite to convert scsi to a logical state machine.  Dealing
with all the issues related to the HBA's was more than any mad man could
attempt, much less a sane one.

Comments on fixing 2.5 to use proper status values?

Cheers,

Andre Hedrick
LAD Storage Consulting Group

On Thu, 23 Jan 2003, Jens Axboe wrote:

> On Thu, Jan 23 2003, Douglas Gilbert wrote:
> > The perverse CHECK_CONDITION in include/scsi/scsi.h seems
> > to have struck again (see "Can't burn DVD under 2.5.59 with
> > ide-cd" thread on the linux kernel list). Most users of
> > CHECK_CONDITION found out to their surprise that it is
> > shifted 1 bit (right) from those values found in the
> > standards.
> > 
> > The attachment marks the orginal list of SCSI status codes
> > as deprecated and supplies defines taken from the most
> > recent SAM-3 draft.
> > 
> > The patch is against 2.5.59 but may also be suitable for
> > the lk 2.4 tree.
> 
> Thanks Doug, the old defines were really sick, dunno who was smoking
> what. I not so sure I like the naming, though. The old ones still have
> the most obvious naming :(
> 
> -- 
> Jens Axboe
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

