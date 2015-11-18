From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 3/9] IB: add a helper to safely drain a QP
Date: Wed, 18 Nov 2015 15:06:45 +0100
Message-ID: <20151118140645.GI18820@lst.de>
References: <1447422410-20891-1-git-send-email-hch@lst.de> <1447422410-20891-4-git-send-email-hch@lst.de> <564C61C3.3050307@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <564C61C3.3050307-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 18, 2015 at 01:32:19PM +0200, Sagi Grimberg wrote:
> Christoph,
>
> Given the discussion around this patch I think it would
> be a good idea remove it from the patchset since it's not
> mandatory for the CQ abstraction. I think that we should
> take it with Steve to come up with a complete solution for
> this bit.
>
> Thoughts?

Yes, let's drop it for now.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
