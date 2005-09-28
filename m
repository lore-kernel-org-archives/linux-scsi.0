From: Andre Hedrick <andre@linux-ide.org>
Subject: Re: I request inclusion of SAS Transport Layer and AIC-94xx into
 the kernel
Date: Wed, 28 Sep 2005 15:43:41 -0700 (PDT)
Message-ID: <Pine.LNX.4.10.10509281530190.19896-100000@master.linux-ide.org>
References: <433B0374.4090100@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from astound-64-85-224-245.ca.astound.net ([64.85.224.245]:62988
	"EHLO master.linux-ide.org") by vger.kernel.org with ESMTP
	id S1751150AbVI1W5F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Sep 2005 18:57:05 -0400
In-Reply-To: <433B0374.4090100@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Luben Tuikov <ltuikov@yahoo.com>, Jeff Garzik <jgarzik@pobox.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>


On Wed, 28 Sep 2005, Luben Tuikov wrote:

> On 09/28/05 15:45, Andre Hedrick wrote:
> > Luben, I have a vested interest in seeing SAS run via SCSI.  So this means
> > you have one ex-demi-god from the world of maintainers looking to pull you
> > have towards the current path and open to ideas and willing to back a
> > better design and push it.
> 
> Ok, thanks Andre.  Much appreciated.

Luben,

I have a vested interest in the improvement of the Linux SCSI Core and
wider adoption and support for SATA II and SAS controllers with their
associated domains and transport.

> You are the first person to back me up _publicly_.  Now if we
> can find a person from "the community" to do that, and get all
> the other people who've written me _privately_, we'd be in
> good shape.

Proving a better design with a migration path for integration is the key
for success; however, I am not the person to be the political voice in the
process.  People will disagree in the process and the only counter to
remove blockage/adoption is in code.

James is king of the hill, and is reasonable to a point.  James also
follows a model of generalization v/s specific design.  Argh, this is not
going to be an easy one to explain or back away from now.  Erm, inclusive
API design is where I am wanting to go with this thought.

Have you and company considered the approach of mapping to a library of
sorts?

Cheers,

Andre

