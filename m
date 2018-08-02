From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH V2 0/2] blk-mq: fix fix blk_mq_tagset_busy_iter
Date: Thu, 2 Aug 2018 14:47:41 -0600
Message-ID: <5d0d3e30-ac78-5a84-48b5-5e558c3e7eaa@kernel.dk>
References: <20180802174937.15444-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180802174937.15444-1-ming.lei@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: linux-block@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, Guenter Roeck <linux@roeck-us.net>, Mark Brown <broonie@kernel.org>, Matt Hart <matthew.hart@linaro.org>, Johannes Thumshirn <jthumshirn@suse.de>, John Garry <john.garry@huawei.com>, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 8/2/18 11:49 AM, Ming Lei wrote:
> Hi Jens,
> 
> The two patches fixes boot hang issue in lots of test vm system.
> And the cause is in blk_mq_tagset_busy_iter().
> 
> V2:
> 	- move blk_mq_request_started() into header file as suggested by
> 	  James

I'd be fine with moving that into a header, if the target of this
was 4.19. But it's not, so there's absolutely no point to include
that in this series.

I'm going to apply 2/2 for 4.18.

-- 
Jens Axboe
