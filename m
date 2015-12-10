From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 01/13] irq_poll: make blk-iopoll available outside the
 block layer
Date: Thu, 10 Dec 2015 10:41:41 -0800
Message-ID: <5669C765.8030109@sandisk.com>
References: <1449521512-22921-1-git-send-email-hch@lst.de>
 <1449521512-22921-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1449521512-22921-2-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-rdma@vger.kernel.org
Cc: sagig@dev.mellanox.co.il, bart.vanassche@sandisk.com, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12/07/2015 12:51 PM, Christoph Hellwig wrote:
> -enum {
> -	IOPOLL_F_SCHED		= 0,
> -	IOPOLL_F_DISABLE	= 1,
> -};

[ ... ]

> +enum {
> +	IRQ_POLL_F_SCHED		= 0,
> +	IRQ_POLL_F_DISABLE	= 1,
> +};

A nitpick: the values of these constants were aligned in the original 
code but no longer in the new code. Whether or not this gets addressed:

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
