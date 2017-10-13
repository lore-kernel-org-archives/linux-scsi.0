From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V7 4/6] blk-mq: introduce .get_budget and .put_budget in
 blk_mq_ops
Date: Sat, 14 Oct 2017 00:45:20 +0800
Message-ID: <20171013164519.GF30899@ming.t460p>
References: <20171012183704.22326-1-ming.lei@redhat.com>
 <20171012183704.22326-5-ming.lei@redhat.com>
 <9a741c03-90a3-e583-ddde-0ed71c8570a2@kernel.dk>
 <20171013001919.GA24715@ming.t460p>
 <6efdb459-8746-562d-06dc-5b3e172076e1@kernel.dk>
 <20171013160731.GA30899@ming.t460p>
 <1507912260.13345.0.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1507912260.13345.0.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "tom81094@gmail.com" <tom81094@gmail.com>, "paolo.valente@linaro.org" <paolo.valente@linaro.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "john.garry@huawei.com" <john.garry@huawei.com>, "osandov@fb.com" <osandov@fb.com>, "loberman@redhat.com" <loberman@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Oct 13, 2017 at 04:31:04PM +0000, Bart Van Assche wrote:
> On Sat, 2017-10-14 at 00:07 +0800, Ming Lei wrote:
> > Actually it is in hot path, for example, lpfc and qla2xx's queue depth is 3,
> 
> Sorry but I doubt whether that is correct. More in general, I don't know any modern
> storage HBA for which the default queue depth is so low.

You can grep:

[ming@ming linux]$ git grep -n cmd_per_lun ./drivers/scsi/ | grep -E "qla2xxx|lpfc"

Even SRP/IB isn't big too, just 32.

-- 
Ming
