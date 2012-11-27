From: David Dillow <dillowda@ornl.gov>
Subject: Re: [PATCH 00/11] First pass at merging Bart's HA work
Date: Mon, 26 Nov 2012 23:04:01 -0500
Message-ID: <1353989041.28917.24.camel@obelisk.thedillows.org>
References: <cover.1353903448.git.dillowda@ornl.gov>
	 <CAL1RGDU+b4GxEoY0TOvkyJjr0yx=5tFNmAVZ27hVjOOx=n=yJg@mail.gmail.com>
	 <1353957308.2681.5.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from matrix.voodoobox.net ([75.127.97.206]:50790 "EHLO
	matrix.voodoobox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933156Ab2K0EEV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Nov 2012 23:04:21 -0500
In-Reply-To: <1353957308.2681.5.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Roland Dreier <roland@purestorage.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Bart Van Assche <bvanassche@acm.org>, fujita.tomonori@lab.ntt.co.jp, rcj@linux.vnet.ibm.com

On Mon, 2012-11-26 at 23:15 +0400, James Bottomley wrote:
> On Mon, 2012-11-26 at 10:50 -0800, Roland Dreier wrote:
> >  - I think the srp_transport stuff should go through linux-scsi /
> > James B.
> >    instead of my tree, esp. since it's shared with the IBM vscsi stuff
> > (I think)
> >  - I see Bart had a few comments about a few of your patches, I'll
> > wait
> >    for you guys to hash that out.
> 
> I'm amenable to that, but we do need an agreed patch set, as Roland
> says.  I also hate to apply the pressure, but I suspect -rc7 was the
> last -rc, so I'm expecting the merge window to open on 2/12.

We can push it through James's tree if need be, but Bart's code is
pretty self-contained, and going through the SCSI tree will introduce
merge dependencies. It'd be much easier to push it all through the RDMA
tree, especially if we want to get this landed for 3.8.

I'd want Fujita Tomonori, Robert Jennings, and James to ack the changes
the SRP transport code, though they've been pending for a long time w/o
comment so perhaps silence is consent?
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

