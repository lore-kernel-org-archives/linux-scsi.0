From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH V3] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Sat, 27 Jan 2018 19:23:56 -0500
Message-ID: <20180128002356.GA25933@redhat.com>
References: <20180123161613.14214-1-ming.lei@redhat.com>
 <1516724659.3339.7.camel@sandisk.com>
 <20180123163717.GE13277@ming.t460p>
 <1516726653.3339.20.camel@wdc.com>
 <20180124033109.GA15945@ming.t460p>
 <20180127190920.GA24759@redhat.com>
 <1517091161.3055.7.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1517091161.3055.7.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "ming.lei@redhat.com" <ming.lei@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "loberman@redhat.com" <loberman@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, Jan 27 2018 at  5:12pm -0500,
Bart Van Assche <Bart.VanAssche@wdc.com> wrote:

> On Sat, 2018-01-27 at 14:09 -0500, Mike Snitzer wrote:
> > Ming let me know that he successfully tested this V3 patch using both
> > your test (fio to both mpath and underlying path) and Bart's (02-mq with
> > can_queue in guest).
> > 
> > Would be great if you'd review and verify this fix works for you too.
> > 
> > Ideally we'd get a fix for this regression staged for 4.16 inclusion.
> > This V3 patch seems like the best option we have at this point.
> 
> Hello Mike,
> 
> There are several issues with the patch at the start of this thread:
> - It is an unnecessary change of the block layer API. Queue stalls can
>   already be addressed with the current block layer API, namely by inserting
>   a blk_mq_delay_run_hw_queue() call before returning BLK_STS_RESOURCE.
> - The patch at the start of this thread complicates code further that is
>   already too complicated, namely the blk-mq core.

The above says _nothing_ of substance.  You talk so loudly against
Ming's work that it has gotten to the point where nothing you say
against Ming's work can be taken seriously.

> - The patch at the start of this thread introduces a regression in the
>   SCSI core, namely a queue stall if a request completion occurs concurrently
>   with the newly added BLK_MQ_S_SCHED_RESTART test in the blk-mq core.

And why is this supposed race unique to SCSI core?  

Fact is Ming dutifully implemented what Jens suggested.  And he verified
it to work.  What have you done other than play the antagonist?

> As a kernel maintainer one of your responsibilities is to help keeping the
> quality of the kernel code high. So I think that you, as a kernel maintainer,
> should tell Ming to discard this patch instead of
> asking to merge it upstream
> given all the disadvantages of this patch.

Your contributions do _not_ make up for your inability to work well with
others.  Tiresome doesn't begin to describe these interactions.

Life is too short to continue enduring your bullshit.

But do let us know when you have something of substance to contribute
(hint: code talks).
