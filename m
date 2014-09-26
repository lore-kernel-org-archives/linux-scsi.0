From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 2/8] scsi-mq: Add support for multiple hardware queues
Date: Fri, 26 Sep 2014 08:02:02 -0600
Message-ID: <542571DA.9020701@acm.org>
References: <541C27BF.6070609@acm.org>	<541C281E.9090206@acm.org>	<CAF9gx6JfP2bGyMauB6LzepZP_vKEvrd-sPZc5CRuOrtgQ_UCSw@mail.gmail.com> <CACVXFVMiYsW=dszQ6mE-o_L8fEDdkO59vJ5qeHKch5c33K_QXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACVXFVMiYsW=dszQ6mE-o_L8fEDdkO59vJ5qeHKch5c33K_QXw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Robert Elliott <Elliott-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 26/09/2014 5:08, Ming Lei wrote:
>
> I suggest to apply this patch and related scsi-mq multi hw-queue
> enablement patches first, so that any scsi drivers capable of
> multi hw-queue can go without waiting for passing hctx
> patches which may take a bit long since lots of drivers are involved,
> as Jens said, the mapping from req to hctx is quite cheap.

Hello Ming,

This week I have been traveling. I hope to find more time next week or 
the week after next week to rework this patch series and to address the 
feedback I have received from you, Jens, Christoph and Sagi.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
