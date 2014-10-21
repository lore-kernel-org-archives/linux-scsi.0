From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v2 04/12] scsi_tcq.h: Add support for multiple hardware
 queues
Date: Tue, 21 Oct 2014 01:49:52 -0700
Message-ID: <20141021084952.GC10407@infradead.org>
References: <5433E43D.3010107@acm.org>
 <5433E4C4.4030104@acm.org>
 <5443E2DF.1040605@dev.mellanox.co.il>
 <5444F995.5080407@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5444F995.5080407-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Robert Elliott <Elliott-VXdhtT5mjnY@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 20, 2014 at 02:01:25PM +0200, Bart Van Assche wrote:
> On 10/19/14 18:12, Sagi Grimberg wrote:
> >On 10/7/2014 4:04 PM, Bart Van Assche wrote:
> >>-            req = blk_queue_find_tag(sdev->request_queue, tag);
> >>+        req = blk_queue_find_tag(sdev->request_queue, tag);
> >
> >Why is this line different?
> 
> This is because the indentation has been modified from "8x<space><tab>" into
> "<tab><tab>". I can leave out that change if you want.

Please keep it.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
