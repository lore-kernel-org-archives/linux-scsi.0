From: "Philip R. Auld" <pauld@egenera.com>
Subject: Re: [dm-devel] Re: Is there a grand plan for FC failover?
Date: Sat, 31 Jan 2004 11:59:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040131115903.A4881@vienna.EGENERA.COM>
References: <401521A7.5030808@thekelleys.org.uk> <1075131446.2290.29.camel@mulgrave> <20040128100236.D11527@vienna.EGENERA.COM> <1075309052.2254.6.camel@mulgrave> <20040128130040.E11527@vienna.EGENERA.COM> <20040128124756.A7232@beaverton.ibm.com> <1075328066.2534.10.camel@mulgrave> <20040128165534.A9202@beaverton.ibm.com> <20040130194826.GC31596@reti> <20040131093037.GR11683@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [63.160.166.46] ([63.160.166.46]:31936 "EHLO coyote.egenera.com")
	by vger.kernel.org with ESMTP id S264941AbUAaRBk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 31 Jan 2004 12:01:40 -0500
Content-Disposition: inline
In-Reply-To: <20040131093037.GR11683@suse.de>; from axboe@suse.de on Sat, Jan 31, 2004 at 10:30:37AM +0100
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Joe Thornber <thornber@redhat.com>, dm-devel@sistina.com, James Bottomley <James.Bottomley@steeleye.com>, Simon Kelley <simon@thekelleys.org.uk>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Rumor has it that on Sat, Jan 31, 2004 at 10:30:37AM +0100 Jens Axboe said:
> On Fri, Jan 30 2004, Joe Thornber wrote:
> > It would be great to get some benchmarks to back up these arguments.
> > eg, performance of dm mpath with a simple round robin selector,
> > compared to a scsi layer implementation.  Lifting the elevator (or
> > lowering dm) is a big piece of work that I wont even consider unless
> > there is very good reason; the reason probably needs to be broader
> > than just multipath too.  Even if we did decide to do this, it won't
> > happen in 2.6.
> 
> I suspect the problem really isn't that huge in 2.6, since most
> performance file systems are using mpage or building their own big
> bio's. So in a sense, some of the merging already does happen above dm
> (and the io scheduler).

Out of curiosity, where does raw io fit into that in 2.6?


Thanks,

Phil


-- 
Philip R. Auld, Ph.D.  	        	       Egenera, Inc.    
Principal Software Engineer                   165 Forest St.
(508) 858-2628                            Marlboro, MA 01752
