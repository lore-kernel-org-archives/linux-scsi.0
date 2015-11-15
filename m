From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 7/9] IB/iser: Use a dedicated descriptor for login
Date: Sun, 15 Nov 2015 11:14:13 +0200
Message-ID: <56484CE5.7050609@mellanox.com>
References: <1447422410-20891-1-git-send-email-hch@lst.de>
 <1447422410-20891-8-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447422410-20891-8-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 11/13/2015 3:46 PM, Christoph Hellwig wrote:
> From: Sagi Grimberg<sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> Makes better sense and we'll need it later with CQ abstraction.
> iser switch login bufs to void

Sagi, few quick comments on this patch, please address for next version..

The 2nd sentence of the change-log needs better phrasing.

also multiple checkpatch hits on the patch, please fix

CHECK: Please don't use multiple blank lines
#26: FILE: drivers/infiniband/ulp/iser/iscsi_iser.h:329:

+

WARNING: __packed is preferred over __attribute__((packed))
#42: FILE: drivers/infiniband/ulp/iser/iscsi_iser.h:345:
+} __attribute__((packed));

CHECK: Please don't use multiple blank lines
#44: FILE: drivers/infiniband/ulp/iser/iscsi_iser.h:347:
+
+

CHECK: Alignment should match open parenthesis
#161: FILE: drivers/infiniband/ulp/iser/iser_initiator.c:209:
+       if (ib_dma_mapping_error(device->ib_device,
+                               desc->req_dma))

CHECK: Alignment should match open parenthesis
#172: FILE: drivers/infiniband/ulp/iser/iser_initiator.c:220:
+       if (ib_dma_mapping_error(device->ib_device,
+                               desc->rsp_dma))






--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
