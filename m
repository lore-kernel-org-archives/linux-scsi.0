From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 03/13] irq_poll: fold irq_poll_sched_prep into
	irq_poll_sched
Date: Wed, 30 Dec 2015 10:42:53 +0100
Message-ID: <20151230094253.GB12904@lst.de>
References: <1449521512-22921-1-git-send-email-hch@lst.de> <1449521512-22921-4-git-send-email-hch@lst.de> <5682584A.5030708@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5682584A.5030708-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 29, 2015 at 10:54:18AM +0100, Bart Van Assche wrote:
> After having applied these changes the SRP initiator didn't receive any 
> RDMA completions anymore. I could remedy that by changing 
> "!test_and_set_bit()" into "test_and_set_bit()":

Yes.  I actually had this bug earlier, fixed it and managed to get
it back during a rebase, d'oh.

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Can you resend it with a proper signoff?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
