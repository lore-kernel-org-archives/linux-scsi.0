From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH V8 1/7] blk-mq-sched: fix scheduler bad performance
Date: Fri, 13 Oct 2017 11:30:16 -0600
Message-ID: <a6bbbd2d-3469-129e-2bae-82fa7efb29f1@kernel.dk>
References: <20171013172459.1376-1-ming.lei@redhat.com>
 <20171013172459.1376-2-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171013172459.1376-2-ming.lei@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Tom Nguyen <tom81094@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On 10/13/2017 11:24 AM, Ming Lei wrote:
> When hw queue is busy, we shouldn't take requests from
> scheduler queue any more, otherwise it is difficult to do
> IO merge.
> 
> This patch fixes the awful IO performance on some
> SCSI devices(lpfc, qla2xxx, ...) when mq-deadline/kyber
> is used by not taking requests if hw queue is busy.

This looks fine to me, but needs a much better patch title.
"fix scheduler bad performance" tells you nothing.

-- 
Jens Axboe
