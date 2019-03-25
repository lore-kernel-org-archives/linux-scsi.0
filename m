From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] Avoid that a kernel warning appears during system resume
Date: Sun, 24 Mar 2019 21:47:04 -0700
Message-ID: <bab5e39f-205f-3b53-d3e5-e28f1e41b3af@acm.org>
References: <20190315232758.221199-1-bvanassche@acm.org>
 <20190325003830.8BA272147C@mail.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190325003830.8BA272147C@mail.kernel.org>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Sasha Levin <sashal@kernel.org>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Ming Lei <ming.lei@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>, Oleksandr Natalenko <oleksandr@natalenko.name>, Martin Steigerwald <martin@lichtvoll.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 3/24/19 5:38 PM, Sasha Levin wrote:
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: 3a0a529971ec block, scsi: Make SCSI quiesce and resume work reliably.
> 
> The bot has tested the following trees: v5.0.3, v4.19.30.
> 
> v5.0.3: Build OK!
> v4.19.30: Failed to apply! Possible dependencies:
>      cd84a62e0078 ("block, scsi: Change the preempt-only flag into a counter")
> 
> 
> How should we proceed with this patch?

I think if you want to backport that patch that you will also have to 
backport commit cd84a62e0078 ("block, scsi: Change the preempt-only flag 
into a counter") (kernel v4.20).

Bart.
