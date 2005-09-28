From: Andre Hedrick <andre@linux-ide.org>
Subject: Re: I request inclusion of SAS Transport Layer and AIC-94xx into
 the kernel
Date: Wed, 28 Sep 2005 12:45:20 -0700 (PDT)
Message-ID: <Pine.LNX.4.10.10509281227570.19896-100000@master.linux-ide.org>
References: <20050928162712.GA7615@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750755AbVI1T6h@vger.kernel.org>
In-Reply-To: <20050928162712.GA7615@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Luben Tuikov <ltuikov@yahoo.com>, Jeff Garzik <jgarzik@pobox.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Hi Patrick,

You have hit on one of the key word of my downfall.

Specifications!!!

I believe in them and they are the inflexable state machine which all OSes
are required to address.  Linux has a very bad history of avoiding the
boundary conditions related to storage.

I am for following the rules of the spec, and will bet Linus would now
agree more so than before.  The problem is SCSI is a strange beast without
a formal FSM.  It is more of a BusPhase psuedo stated transport.  It is
smart enough to laugh at bad software designs and keep going.  Sheesh,
look at M$'s miniport.

This leads me to a point where a similar (but smarter) miniport could look
interesting.  However, this is also where the transport classes have their
bases, afaics.  Anyone please correct me where I have mistated (other than
Linus, :-p).

Luben, I have a vested interest in seeing SAS run via SCSI.  So this means
you have one ex-demi-god from the world of maintainers looking to pull you
have towards the current path and open to ideas and willing to back a
better design and push it.

Cheers,

Andre Hedrick
LAD Storage Consulting Group

On Wed, 28 Sep 2005, Patrick Mansfield wrote:

> On Wed, Sep 28, 2005 at 04:37:03AM -0700, Luben Tuikov wrote:
> 
> > never ever going in.  Why else do you think IBM-ers agree with him that
> > Linux SCSI doesn't need 64 bit LUNS?
> 
> Please stop repeating that, no one said we should *not* implement a 64 bit
> LUN in linux scsi, and James posted a patch for 64 bit LUN. I posted a
> clarification in response to your earlier postings, you seem to have
> ignored or forgotten this post:
> 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=112671847228275&w=2
> 
> I said:
> 
> "I am talking about the scsi spec, not the code. IMO linux scsi code
> should support W_LUN and 64 bit LUN."
> 
> -- Patrick Mansfield
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
