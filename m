From: Mel Gorman <mgorman@suse.com>
Subject: Re: [LSF/MM TOPIC] Two blk-mq related topics
Date: Tue, 30 Jan 2018 10:50:52 +0000
Message-ID: <20180130105052.gtetsqx3xgsxog7n@novell.com>
References: <20180129154455.GB17176@ming.t460p>
 <1517259390.3969.41.camel@HansenPartnership.com>
 <fc833da8-f9de-d577-e1d3-c46d8c061d35@kernel.dk>
 <mqdzi4vlkv7.fsf@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <mqdzi4vlkv7.fsf@linux-x5ow.site>
Sender: linux-block-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, James Bottomley <James.Bottomley@HansenPartnership.com>, Ming Lei <ming.lei@redhat.com>, lsf-pc@lists.linux-foundation.org, Linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 30, 2018 at 11:08:28AM +0100, Johannes Thumshirn wrote:
> [+Cc Mel]
> Jens Axboe <axboe@kernel.dk> writes:
> > On 1/29/18 1:56 PM, James Bottomley wrote:
> >> On Mon, 2018-01-29 at 23:46 +0800, Ming Lei wrote:
> >> [...]
> >>> 2. When to enable SCSI_MQ at default again?
> >> 
> >> I'm not sure there's much to discuss ... I think the basic answer is as
> >> soon as Christoph wants to try it again.
> >
> > FWIW, internally I've been running various IO intensive workloads on
> > what is essentially 4.12 upstream with scsi-mq the default (with
> > mq-deadline as the scheduler) and comparing IO workloads with a
> > previous 4.6 kernel (without scsi-mq), and things are looking
> > great.
> >
> > We're never going to iron out the last kinks with it being off
> > by default, I think we should attempt to flip the switch again
> > for 4.16.
> 
> The 4.12 sounds interesting. I remember Mel ran some test with 4.12 as
> we where considering to flip the config option for SLES and it showed
> several road blocks.
> 

Mostly due to slow storage and BFQ where mq-deadline was not a universal
win as an alternative default. I don't have current data and I archived
what I had, but it was based on 4.13-rc7 at the time and BFQ has changed
a lot since so it would need to be redone.

> I'm not sure whether he re-evaluated 4.13/4.14 on his grid though.
> 

No, it hasn't. Grid time for performance testing has been tight during
the last few months to say the least.

> But I'm definitively interested in this discussion and can even possibly
> share some benchmark results we did in our FC Lab.
> 

If you remind me, I may be able to re-execute the tests in a 4.16-rcX
before LSF/MM so you have other data to work with.  Unfortunately, I'll
not be able to make LSF/MM this time due to personal commitments that
conflict and are unmovable.

-- 
Mel Gorman
SUSE Labs
