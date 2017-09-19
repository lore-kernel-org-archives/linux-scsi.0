From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/5] block: don't call blk_mq_delay_run_hw_queue() in
 case of BLK_STS_RESOURCE
Date: Tue, 19 Sep 2017 12:03:13 -0400
Message-ID: <20170919160312.GC22809@redhat.com>
References: <20170915164456.9803-1-ming.lei@redhat.com>
 <20170915164456.9803-2-ming.lei@redhat.com>
 <1505498249.3420.15.camel@wdc.com>
 <20170917124000.GB6289@ming.t460p>
 <1505747894.2685.6.camel@wdc.com>
 <20170919054308.GA2517@ming.t460p>
 <20170919154823.GA22809@redhat.com>
 <1505836356.2671.21.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1505836356.2671.21.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "ming.lei@redhat.com" <ming.lei@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "sagi@grimberg.me" <sagi@grimberg.me>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "loberman@redhat.com" <loberman@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 19 2017 at 11:52am -0400,
Bart Van Assche <Bart.VanAssche@wdc.com> wrote:

> On Tue, 2017-09-19 at 11:48 -0400, Mike Snitzer wrote:
> > This thread proves that it is definitely brittle to be relying on fixed
> > delays like this:
> > https://patchwork.kernel.org/patch/9703249/
> 
> Hello Mike,
> 
> Sorry but I think that's a misinterpretation of my patch. I came up with that
> patch before I had found and fixed the root cause of the high system load.
> These fixes are upstream (kernel v4.13) which means that that patch is now
> obsolete.

OK, fair point.

Though fixed magic values for delay aren't going to stand the test of
time.
