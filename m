From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V7 5/6] blk-mq-sched: improve dispatching from sw queue
Date: Fri, 13 Oct 2017 08:20:37 +0800
Message-ID: <20171013002036.GB24715@ming.t460p>
References: <20171012183704.22326-1-ming.lei@redhat.com>
 <20171012183704.22326-6-ming.lei@redhat.com>
 <2852603f-ce98-9f8e-8d86-1d601445a1ff@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2852603f-ce98-9f8e-8d86-1d601445a1ff@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Tom Nguyen <tom81094@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 12, 2017 at 11:48:22AM -0700, Bart Van Assche wrote:
> On 10/12/17 11:37, Ming Lei wrote:
> > [ ... ]
> > 
> > This patch improves dispatching from sw queue by using the callback of
> > .get_budget and .put_budget
> > 
> > Reviewed-by: Omar Sandoval <osandov@fb.com>
> > Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> > 
> > Jens/Omar, once .get_budget is introduced, it can be unusual to
> > return busy from .queue_rq, so we can't use the approach discussed
> > to decide to take one by one or flush all. Then this patch
> > simply checks if .get_budget is implemented, looks it is reasonable,
> > and in future it is even possible to take more requests by getting
> > enough budget first.
> > [ ... ]
> 
> Version 7 of this patch differs significantly from the version I reviewed so
> I think you should remove my Reviewed-by tag.

OK, no problem, the only difference is on the introduced .get_budget().

-- 
Ming
