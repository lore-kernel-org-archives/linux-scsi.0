From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 2/2] IB/iser: set max_segment_size
Date: Tue, 12 Apr 2016 07:13:25 -0700
Message-ID: <1460470405-11673-3-git-send-email-hch@lst.de>
References: <1460470405-11673-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460470405-11673-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

So that we don't overflow the number of MR segments allocated because
we have to split on SGL segment into multiple MR segments.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 80b6bed..dc55950 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -623,6 +623,7 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 	shost->max_id = 0;
 	shost->max_channel = 0;
 	shost->max_cmd_len = 16;
+	shost->max_segment_size = SIZE_4K;
 
 	/*
 	 * older userspace tools (before 2.0-870) did not pass us
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
