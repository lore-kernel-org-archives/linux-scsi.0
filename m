From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 2/2] IB/iser: set max_segment_size
Date: Tue, 12 Apr 2016 17:27:58 +0200
Message-ID: <20160412152758.GA7896@lst.de>
References: <1460414846-29540-1-git-send-email-hch@lst.de> <1460414846-29540-3-git-send-email-hch@lst.de> <570CD26E.70502@grimberg.me> <1460471256.2338.5.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1460471256.2338.5.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 12, 2016 at 07:27:36AM -0700, James Bottomley wrote:
> > In iser we sorta rely on 4k pages so we avoid
> > PAGE_SIZE but rather set SIZE_4K for these sort
> > of things (like we did in the virt_boundary).
> 
> So you still want only 4k segments even on PPC where the PAGE_SIZE is
> 16k?

I'll leave the high level question to Sagi and friends, but if virt_boundary
and the MR page size are set to 4k we need to set the segment size
to the same, so this patch needs to be SIZE_4K indeed unless the
other two are changed.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
