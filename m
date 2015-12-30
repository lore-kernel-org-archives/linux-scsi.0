From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 08/13] IB/srpt: chain RDMA READ/WRITE requests
Date: Wed, 30 Dec 2015 10:43:32 +0100
Message-ID: <20151230094332.GC12904@lst.de>
References: <1449521512-22921-1-git-send-email-hch@lst.de> <1449521512-22921-9-git-send-email-hch@lst.de> <56825940.5070404@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56825940.5070404-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 29, 2015 at 10:58:24AM +0100, Bart Van Assche wrote:
> On 12/07/2015 09:51 PM, Christoph Hellwig wrote:
> > Remove struct rdma_iu and instead allocate the struct ib_rdma_wr array
> > early and fill out directly.  This allows us to chain the WRs, and thus
> > archive both less lock contention on the HCA workqueue as well as much
> > simpler error handling.
> 
> Please consider folding the patch below into this patch.

Looks fine,

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
