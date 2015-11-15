From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 9/9] IB/iser: Convert to CQ abstraction
Date: Sun, 15 Nov 2015 11:21:08 +0200
Message-ID: <56484E84.6040904@mellanox.com>
References: <1447422410-20891-1-git-send-email-hch@lst.de>
 <1447422410-20891-10-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447422410-20891-10-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 11/13/2015 3:46 PM, Christoph Hellwig wrote:
> From: Sagi Grimberg<sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Care to sparse some text here to assist a reviewer and future bisections?!

I have asked multiple times to avoid empty change-logs for patches in 
this driver.

>
> Signed-off-by: Sagi Grimberg<sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Christoph Hellwig<hch-jcswGhMUV9g@public.gmane.org>
> ---
>   drivers/infiniband/ulp/iser/iscsi_iser.h     |  68 ++++---
>   drivers/infiniband/ulp/iser/iser_initiator.c | 142 ++++++++++-----
>   drivers/infiniband/ulp/iser/iser_memory.c    |  21 ++-
>   drivers/infiniband/ulp/iser/iser_verbs.c     | 258 ++++++---------------------
>   4 files changed, 209 insertions(+), 280 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
