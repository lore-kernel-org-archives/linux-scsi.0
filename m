From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V10 0/8] blk-mq-sched: improve sequential I/O performance
Date: Sun, 15 Oct 2017 07:16:28 +0800
Message-ID: <20171014231627.GA17485@ming.t460p>
References: <20171014092232.13943-1-ming.lei@redhat.com>
 <7774487.lQXyKRvAUb@natalenko.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7774487.lQXyKRvAUb@natalenko.name>
Sender: linux-block-owner@vger.kernel.org
To: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, Tom Nguyen <tom81094@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, Oct 14, 2017 at 07:38:29PM +0200, Oleksandr Natalenko wrote:
> Hi.
> 
> By any chance, could this be backported to 4.14? I'm confused with "SCSI: 
> allow to pass null rq to scsi_prep_state_check()" since it uses refactored 
> flags.
> 
> ===
> if (req && !(req->rq_flags & RQF_PREEMPT))
> ===
> 
> Is it safe to revert to REQ_PREEMPT here, or rq_flags should also be replaced 
> with cmd_flags?

Hi Oleksandr,

Inside scsi_mq_get_budget(), req is passed as null, and RQF_PREEMPT
won't be checked at all.

Thanks,
Ming
