From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [DO NOT APPLY] sd take advantage of rotation speed
Date: Wed, 25 Jun 2008 13:06:55 -0500
Message-ID: <1214417215.5674.36.camel@localhost.localdomain>
References: <20080619160342.GJ4392@parisc-linux.org>
	 <20080625134705.GZ20851@kernel.dk> <4862552A.5010900@gmail.com>
	 <48627184.9010609@panasas.com> <20080625165759.GC20851@kernel.dk>
	 <20080625172015.GR4392@parisc-linux.org> <20080625172638.GE20851@kernel.dk>
	 <20080625173444.GS4392@parisc-linux.org>
	 <1214415830.5674.30.camel@localhost.localdomain>
	 <20080625175303.GT4392@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:53206 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752477AbYFYSG7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jun 2008 14:06:59 -0400
In-Reply-To: <20080625175303.GT4392@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jens Axboe <jens.axboe@oracle.com>, Boaz Harrosh <bharrosh@panasas.com>, Ric Wheeler <ricwheeler@gmail.com>, linux-scsi@vger.kernel.org

On Wed, 2008-06-25 at 11:53 -0600, Matthew Wilcox wrote:
> On Wed, Jun 25, 2008 at 12:43:50PM -0500, James Bottomley wrote:
> > On Wed, 2008-06-25 at 11:34 -0600, Matthew Wilcox wrote:
> > > On Wed, Jun 25, 2008 at 07:26:39PM +0200, Jens Axboe wrote:
> > > > Uhm, but it IS "a blatant layering violation", it's doing things from
> > > > the wrong side up :-)
> > > 
> > > That's just "doing things from a spot Jens doesn't approve of".  A
> > > layering violation would be SCSI knowing how elevators work.
> > 
> > When it was setting particular elevators, it was a layering violation
> > (as I said at the time).  If it's just setting a seek cost hint, that's
> > acceptable.
> 
> You're both being silly.  Interacting with a subsystem via its exposed
> interfaces is not a layering violation.

It depends on the interface: sys_open is an exposed interface, but any
SCSI driver trying to use it will be caught and shot for egregious
layering violations.

The elevator setting interface is a policy interface designed for users,
not for lower layers of the I/O stack.

> > I don't think there is any IDE work to do ... the last I heard from the
> > manufacturers, they were all not going to bother with PATA interfaces to
> > SSDs ... unless this has changed?
> 
> There are people with PATA->SATA adapters.  I think there's one in your
> P7120 (or is that one a PATA->SATA adapter?)

No ... it's using an IHC6 with two interfaces, one SATA and one PATA.

>   In any case, I don't think
> we need to do anything until someone complains.

Agreed.

James


