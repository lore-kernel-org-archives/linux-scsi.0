From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [patch 0/1] Apply segment size and segment boundary to integrity
 data
Date: Wed, 11 Aug 2010 10:07:50 +0200
Message-ID: <20100811080750.GA4722@schmichrtp.mainz.de.ibm.com>
References: <20100715153410.774329000@de.ibm.com>
 <yq1mxtspwab.fsf@sermon.lab.mkp.net>
 <20100716083034.GA7474@schmichrtp.ibm.com>
 <yq1bpa292wy.fsf@sermon.lab.mkp.net>
 <20100720092850.GA4547@schmichrtp.mainz.de.ibm.com>
 <yq1y6d579fy.fsf@sermon.lab.mkp.net>
 <20100802110517.GA4556@schmichrtp.mainz.de.ibm.com>
 <yq1vd7s8ful.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1vd7s8ful.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 03, 2010 at 12:44:50AM -0400, Martin K. Petersen wrote:
> >>>>> "Christof" == Christof Schmitt <christof.schmitt@de.ibm.com> writes:
> 
> Christof> To summarize the limits i see in the zfcp hardware:
> Christof> - Maximum size of 4k per segment
> Christof> - The segments must not cross page boundaries
> Christof> - The number of segments per request is limited
> 
> The interesting thing here is that your hw has a limit for the total
> number of segments whereas other DIX HBAs have separate limits for data
> and integrity scatterlists.

Yes, the hw interface only has a limit for the total number. The best
solution would be an interface that allows reporting this limit to the
block layer. If this is not possible, or deemed too exotic, reporting
seperate limits for integrity segments and data segments would also be
fine with me.

> Christof> What would be the preferred approach for handling the
> Christof> integrity data limits in the block layer? Introduce new queue
> Christof> limits for integrity data, or assume that the limits for
> Christof> integrity data are the same as for user data? I can update my
> Christof> patch accordingly and include a check for the maximum number
> Christof> of segments.
> 
> I've been messing with this tonight.  It's not entirely trivial because
> of the housekeeping involved, having to accomodate different types of
> hardware, having to avoid breaking existing setups, and having to work
> with integrity compiled and without.
> 
> My first attempt at this got quite messy.  I think I have found a way
> but it's bedtime here.  Give me a day or two to get back to you with
> something that'll hopefully work for everyone.

Ok, when you have something, i can have a look at it and see if it
matches the requirements here.

Thanks,

Christof
