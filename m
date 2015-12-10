From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 03/13] irq_poll: fold irq_poll_sched_prep into
 irq_poll_sched
Date: Thu, 10 Dec 2015 10:41:54 -0800
Message-ID: <5669C772.6070305@sandisk.com>
References: <1449521512-22921-1-git-send-email-hch@lst.de>
 <1449521512-22921-4-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1449521512-22921-4-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-rdma@vger.kernel.org
Cc: sagig@dev.mellanox.co.il, bart.vanassche@sandisk.com, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12/07/2015 12:51 PM, Christoph Hellwig wrote:
> @@ -58,7 +62,7 @@ EXPORT_SYMBOL(__irq_poll_complete);
>    * Description:
>    *     If a driver consumes less than the assigned budget in its run of the
>    *     iopoll handler, it'll end the polled mode by calling this function. The
> - *     iopoll handler will not be invoked again before irq_poll_sched_prep()
> + *     iopoll handler will not be invoked again before irq_poll_schedp()
>    *     is called.
>    **/
>   void irq_poll_complete(struct irq_poll *iop)

Is that a typo at the end of the modified line ("schedp") ? If this gets 
addressed:

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
