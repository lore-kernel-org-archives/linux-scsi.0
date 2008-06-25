From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [DO NOT APPLY] sd take advantage of rotation speed
Date: Wed, 25 Jun 2008 20:01:50 +0200
Message-ID: <20080625180149.GG20851@kernel.dk>
References: <20080619160342.GJ4392@parisc-linux.org> <20080625134705.GZ20851@kernel.dk> <4862552A.5010900@gmail.com> <48627184.9010609@panasas.com> <20080625165759.GC20851@kernel.dk> <20080625172015.GR4392@parisc-linux.org> <20080625172638.GE20851@kernel.dk> <20080625173444.GS4392@parisc-linux.org> <1214415830.5674.30.camel@localhost.localdomain> <20080625175303.GT4392@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:16358 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbYFYSBw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jun 2008 14:01:52 -0400
Content-Disposition: inline
In-Reply-To: <20080625175303.GT4392@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, Ric Wheeler <ricwheeler@gmail.com>, linux-scsi@vger.kernel.org

On Wed, Jun 25 2008, Matthew Wilcox wrote:
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

Dude, get a grip, your line is reasoning is getting silly. By that
logic, as long as something is exported you can use it from wherever you
want? Uhm right.

-- 
Jens Axboe

