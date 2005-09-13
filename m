From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE 0/2] Serial Attached SCSI (SAS) support for the Linux kernel
Date: Tue, 13 Sep 2005 11:14:09 +0100
Message-ID: <20050913101409.GA30666@infradead.org>
References: <4321E2C1.7080507@adaptec.com> <20050911092030.GA5140@infradead.org> <4325F488.5040304@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:4235 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750730AbVIMKOK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Sep 2005 06:14:10 -0400
Content-Disposition: inline
In-Reply-To: <4325F488.5040304@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Christoph Hellwig <hch@infradead.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Sep 12, 2005 at 05:35:04PM -0400, Luben Tuikov wrote:
> > What's not nice is that it's not intgerating with the
> > SAS transport class I posted,
> 
> I wish there was something I could do.  HP and LSI
> were aware of my efforts since the beginning of the year.

As was I.  And the reason I wrote this upper layer is that you
clearly stated multiple times (at the SAS BOF and in mail) that
you're not interested in this upper layer.

> As well, you had a copy of my code July 14 this year,

That code didn't have anything that overlaps with the code I wrote.

> long before starting your work on your SAS class for LSI and
> HP (so its acceptance is guaranteed), after OLS.

Just in case it was clear:  I'm paid for this transport class by Dell.
I don't have any contractural relationship with LSI or HP, although these
companies (like most sucessfull hardware vendors) know that giving hardware
to linux people active in the area they care about helps to get thos people
actually fixing things about instead of just bitching around..

> We did meet at OLS and we did have the SAS BOF.  I'm not sure
> why you didn't want to work together?

I abosultely want to.  To quote from my first minimal transport class
announcement mail:

"I hope this will integrate nicely with the top-down work Luben has done
once he finally releases it publically, but for now I think we should have
something so SAS drivers can go in the tree."

> > from the SCSI core code, and adding it's own sysfs representation that's
> > very different from the way the SCSI core and transport classes do it.
> 
> Yes, it is time to evolve.
> 
> I've pointed out many times the shortcomings of expanding the
> JB's "transport _attribute_ class" into a "transport layer" in
> recent threads.

We need both a transport class in the original sense aswell as a library
for host-based SAS HBAs, and they need to play together nicely - whatever
term you give to them.

> Overall, MPT is very different in design than a disclosed
> transport.

I know.  And we still want to cover it with a common base for what we
can have common.

