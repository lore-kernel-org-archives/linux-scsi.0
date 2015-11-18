From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 5/9] srpt: use the new CQ API
Date: Wed, 18 Nov 2015 15:03:15 +0100
Message-ID: <20151118140315.GF18820@lst.de>
References: <1447422410-20891-1-git-send-email-hch@lst.de> <1447422410-20891-6-git-send-email-hch@lst.de> <564B8248.7050407@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <564B8248.7050407-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 17, 2015 at 11:38:48AM -0800, Bart Van Assche wrote:
> On 11/13/2015 05:46 AM, Christoph Hellwig wrote:
>> [ ... ]
>
> This patch contains two logical changes:
> - Conversion to the new CQ API.
> - Removal of the ib_srpt_compl thread.
>
> Had it been considered to implement these changes as two separate patches ?

It's intentional.  I want the new style completions to happen from
a controlled environment, so I don't want to allow calling them from
random context.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
