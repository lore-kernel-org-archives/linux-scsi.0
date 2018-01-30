From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v5] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Tue, 30 Jan 2018 15:12:12 -0500
Message-ID: <20180130201212.GA16284@redhat.com>
References: <20180130142459.52668-1-snitzer@redhat.com>
 <43ac2314-c98d-bb76-0dfb-171d15cc5fd8@wdc.com>
 <20180130193323.GA15943@redhat.com>
 <1517341349.2589.35.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1517341349.2589.35.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 30 2018 at  2:42pm -0500,
Bart Van Assche <Bart.VanAssche@wdc.com> wrote:

> On Tue, 2018-01-30 at 14:33 -0500, Mike Snitzer wrote:
> > On Tue, Jan 30 2018 at 12:52pm -0500,
> > Bart Van Assche <bart.vanassche@wdc.com> wrote:
> > 
> > > - This patch does not fix any bugs nor makes block drivers easier to
> > >   read or to implement. So why is this patch considered useful?
> > 
> > It enables blk-mq core to own the problem that individual drivers should
> > have no business needing to worry about.  Period.
> 
> Thanks for having confirmed that this patch is an API-change only and does
> not fix any bugs.

No, it is an API change that enables blk-mq drivers to make forward
progress without compromising the potential benefits associated with
blk-mq's SCHED_RESTART functionality.

(If we're going to beat this horse to death it might as well be with
precision)
