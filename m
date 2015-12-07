From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: completion queue abstraction V2
Date: Mon,  7 Dec 2015 12:51:39 -0800
Message-ID: <1449521512-22921-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

This series adds a new RDMA core abstraction that insulated the
ULPs from the nitty gritty details of CQ polling.  See the individual
patches for more details.

Note that this series should be applied on top of my
"IB: merge struct ib_device_attr into struct ib_device" patch and the
MR cleanups.

A git tree is also available:

	git://git.infradead.org/users/hch/rdma.git rdma-cq

As well as gitweb:
	http://git.infradead.org/users/hch/rdma.git/shortlog/refs/heads/rdma-cq

Changes since V1:
 - rebased
 - some additional irq_work cleanups
 - early exit from the polling loop (Jason)
 - changed ib_process_cq_direct API (Sagi / Jason / Bart)
 - dropped the ib_drain_qp helper for now, to be revisited later
 - cosmetic iser cleanups (or)
 - cosmetic srp changes (Bart)
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
