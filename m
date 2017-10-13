From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH V7 4/6] blk-mq: introduce .get_budget and .put_budget in
 blk_mq_ops
Date: Fri, 13 Oct 2017 10:33:40 -0600
Message-ID: <f2a74e2c-31ac-e366-83d1-9837531daddf@kernel.dk>
References: <20171012183704.22326-1-ming.lei@redhat.com>
 <20171012183704.22326-5-ming.lei@redhat.com>
 <9a741c03-90a3-e583-ddde-0ed71c8570a2@kernel.dk>
 <20171013001919.GA24715@ming.t460p>
 <6efdb459-8746-562d-06dc-5b3e172076e1@kernel.dk>
 <20171013160731.GA30899@ming.t460p> <1507912260.13345.0.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1507912260.13345.0.camel@wdc.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "tom81094@gmail.com" <tom81094@gmail.com>, "paolo.valente@linaro.org" <paolo.valente@linaro.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "john.garry@huawei.com" <john.garry@huawei.com>, "osandov@fb.com" <osandov@fb.com>, "loberman@redhat.com" <loberman@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 10/13/2017 10:31 AM, Bart Van Assche wrote:
> On Sat, 2017-10-14 at 00:07 +0800, Ming Lei wrote:
>> Actually it is in hot path, for example, lpfc and qla2xx's queue depth is 3,
> 
> Sorry but I doubt whether that is correct. More in general, I don't know any modern
> storage HBA for which the default queue depth is so low.

That does seem insanely low. BTW, even a low depth isn't an issue, as long as
we know what it roughly is.


-- 
Jens Axboe
