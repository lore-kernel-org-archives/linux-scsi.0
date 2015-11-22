From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 2/9] IB: add a proper completion queue abstraction
Date: Sun, 22 Nov 2015 14:23:52 +0100
Message-ID: <20151122132352.GA14154@lst.de>
References: <1447422410-20891-1-git-send-email-hch@lst.de> <1447422410-20891-3-git-send-email-hch@lst.de> <564B697A.2020601@sandisk.com> <564C2F01.6020407@dev.mellanox.co.il> <564CC15E.7030602@sandisk.com> <20151120101644.GC24298@lst.de> <564F4F38.9040505@sandisk.com> <56519011.6060204@dev.mellanox.co.il> <20151122101308.GA12189@lst.de> <56519A90.5010502@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56519A90.5010502-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "axboe-b10kYP2dOMg@public.gmane.org" <axboe-b10kYP2dOMg@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, Nov 22, 2015 at 12:36:00PM +0200, Sagi Grimberg wrote:
>
>> Wouldn't it be a better idea to set the WQ_SYSFS interface and use
>> the standard sysfs interface for specifying cpumasks or node affinity?
>
> I think that bart wants to allow the caller to select cpu affinity
> per CQ. In this case ib_alloc_cq in workqueue mode would need to
> accept a affinity_hint from the caller (default to wild-card 
> WORK_CPU_UNBOUND).

Hmm, true.  How would be set that hint from userspace?  I'd really prefer
to see a practical justification for it first.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
