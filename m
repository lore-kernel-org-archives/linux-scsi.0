From: Jens Axboe <axboe@suse.de>
Subject: Re: [dm-devel] Re: Is there a grand plan for FC failover?
Date: Sat, 31 Jan 2004 10:30:37 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040131093037.GR11683@suse.de>
References: <401521A7.5030808@thekelleys.org.uk> <1075131446.2290.29.camel@mulgrave> <20040128100236.D11527@vienna.EGENERA.COM> <1075309052.2254.6.camel@mulgrave> <20040128130040.E11527@vienna.EGENERA.COM> <20040128124756.A7232@beaverton.ibm.com> <1075328066.2534.10.camel@mulgrave> <20040128165534.A9202@beaverton.ibm.com> <20040130194826.GC31596@reti>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:40618 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S264278AbUAaJbK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 31 Jan 2004 04:31:10 -0500
Content-Disposition: inline
In-Reply-To: <20040130194826.GC31596@reti>
List-Id: linux-scsi@vger.kernel.org
To: Joe Thornber <thornber@redhat.com>
Cc: dm-devel@sistina.com, James Bottomley <James.Bottomley@steeleye.com>, "Philip R. Auld" <pauld@egenera.com>, Simon Kelley <simon@thekelleys.org.uk>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Jan 30 2004, Joe Thornber wrote:
> On Wed, Jan 28, 2004 at 04:55:34PM -0800, Patrick Mansfield wrote:
> > > We had the "where does the elevator go" discussion at the OLS bof.  I
> > > think I heard agreement that the current situation of between dm and
> > > block is suboptimal and that we'd like a true coalescing elevator above
> > > dm with a vestigial one for the mid-layer to use for queueing below.  I
> > > think this is a requirement for dm multipath to work well, but it's not
> > > a requirement for it actually to work.
> > 
> > If the performance is bad enough, it doesn't matter if it works.
> 
> It would be great to get some benchmarks to back up these arguments.
> eg, performance of dm mpath with a simple round robin selector,
> compared to a scsi layer implementation.  Lifting the elevator (or
> lowering dm) is a big piece of work that I wont even consider unless
> there is very good reason; the reason probably needs to be broader
> than just multipath too.  Even if we did decide to do this, it won't
> happen in 2.6.

I suspect the problem really isn't that huge in 2.6, since most
performance file systems are using mpage or building their own big
bio's. So in a sense, some of the merging already does happen above dm
(and the io scheduler).

-- 
Jens Axboe

