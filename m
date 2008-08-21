From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: RE: in 2.6.23-rc3-git7 in do_cciss_intr
Date: Thu, 21 Aug 2008 16:25:24 +0000
Message-ID: <0F5B06BAB751E047AB5C87D1F77A778835118100D6@GVW0547EXC.americas.hpqcorp.net>
References: <48AD02B2.7020004@oracle.com>
	<0F5B06BAB751E047AB5C87D1F77A778835116209D3@GVW0547EXC.americas.hpqcorp.net>
	<20080821084333.c471b439.randy.dunlap@oracle.com>
	<0F5B06BAB751E047AB5C87D1F77A7788351181004C@GVW0547EXC.americas.hpqcorp.net>
 <20080821091514.8f56e2d5.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:22835 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486AbYHUQ0D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Aug 2008 12:26:03 -0400
In-Reply-To: <20080821091514.8f56e2d5.randy.dunlap@oracle.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, akpm <akpm@linux-foundation.org>

> >
> > Randy,
> > We know of a race condition in cciss_init_one. It's fixed
> in 2.6.26 I believe. Here's the patch:
> >
> >
> http://groups.google.com/group/linux.kernel/browse_thread/thread/7b39f
> > 2b77622ab03/4f5f45c008655ca1?hl=en&lnk=gst&q=cciss#4f5f45c008655ca1
>
>
> Mike,
> Sorry, but my fingers have typoed the $subject.  My bad.
> Kernel is 2.6.27-rc3-git7 (from above):
>
> > > > > Modules linked in: cciss(+) ehci_hcd ohci_hcd uhci_hcd
> > > > > Pid: 0, comm: swapper Not tainted 2.6.27-rc3-git7 #1
> > > > > RIP: 0010:[<ffffffffa001bb68>]  [<ffffffffa001bb68>]
> > > > > do_cciss_intr+0x627/0xa6c [cciss]
>
Hmmmmm, let me know what happens from your retest. I'll look at this as soon as I finish what I'm doing now. We trying to spin for our test teams but I have something hopelessly broken. :(

-- mikem
