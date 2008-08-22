From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: in 2.6.23-rc3-git7 in do_cciss_intr
Date: Thu, 21 Aug 2008 17:26:53 -0700
Message-ID: <20080821172653.3e3e855c.randy.dunlap@oracle.com>
References: <48AD02B2.7020004@oracle.com>
	<0F5B06BAB751E047AB5C87D1F77A778835116209D3@GVW0547EXC.americas.hpqcorp.net>
	<20080821084333.c471b439.randy.dunlap@oracle.com>
	<0F5B06BAB751E047AB5C87D1F77A7788351181004C@GVW0547EXC.americas.hpqcorp.net>
	<20080821091514.8f56e2d5.randy.dunlap@oracle.com>
	<0F5B06BAB751E047AB5C87D1F77A778835118100D6@GVW0547EXC.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:52392 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbYHVA0z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Aug 2008 20:26:55 -0400
In-Reply-To: <0F5B06BAB751E047AB5C87D1F77A778835118100D6@GVW0547EXC.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: lkml <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, akpm <akpm@linux-foundation.org>

On Thu, 21 Aug 2008 16:25:24 +0000 Miller, Mike (OS Dev) wrote:

> > >
> > > Randy,
> > > We know of a race condition in cciss_init_one. It's fixed
> > in 2.6.26 I believe. Here's the patch:
> > >
> > >
> > http://groups.google.com/group/linux.kernel/browse_thread/thread/7b39f
> > > 2b77622ab03/4f5f45c008655ca1?hl=en&lnk=gst&q=cciss#4f5f45c008655ca1
> >
> >
> > Mike,
> > Sorry, but my fingers have typoed the $subject.  My bad.
> > Kernel is 2.6.27-rc3-git7 (from above):
> >
> > > > > > Modules linked in: cciss(+) ehci_hcd ohci_hcd uhci_hcd
> > > > > > Pid: 0, comm: swapper Not tainted 2.6.27-rc3-git7 #1
> > > > > > RIP: 0010:[<ffffffffa001bb68>]  [<ffffffffa001bb68>]
> > > > > > do_cciss_intr+0x627/0xa6c [cciss]
> >
> Hmmmmm, let me know what happens from your retest. I'll look at this as soon as I finish what I'm doing now. We trying to spin for our test teams but I have something hopelessly broken. :(

It didn't BUG in the retest.  That just means that it's more difficult
to find/fix, right?

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
