From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 01/11] blk-mq: Add blk_mq_unique_tag()
Date: Wed, 5 Nov 2014 10:54:00 -0800
Message-ID: <20141105185400.GA17425@infradead.org>
References: <545240AE.6060009@acm.org>
 <545240E7.5030206@acm.org>
 <20141104141432.GA446@infradead.org>
 <545A19FA.40706@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <545A19FA.40706-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Robert Elliott <Elliott-VXdhtT5mjnY@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 05, 2014 at 01:37:14PM +0100, Bart Van Assche wrote:
> That's strange. I have compared the patches that are already in your tree
> with the patches I had posted myself with a diff tool. These patches look
> identical to what I had posted except for one CC tag that has been left out.
> If I try to apply the three patches that have not yet been included in your
> tree (9/11..11/11) on top the drivers-for-3.19 branch then these patches
> apply fine. Anyway, I have rebased my tree on top of your drivers-for-3.19
> branch, added a few other patches (including one block layer patch that has
> not yet been posted) and retested the SRP initiator driver against the
> traditional SCSI core and also against the scsi-mq core. The result can be
> found here: https://github.com/bvanassche/linux/commits/srp-multiple-hwq-v4.
> Can you please retry to apply patches 9/11..11/11 apply on top of the
> drivers-for-3.19 branch ?

I've pulled in the three remaining patches from the series from that
tree.  If you want me to pull in the remaining trivial srp patch as well
please give me a Reviewed-by: and I'll also pull it in.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
