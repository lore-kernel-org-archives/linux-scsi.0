From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH resend] scsi: fc: drop residual tsk_mgmt_response and it_nexus_response
Date: Wed, 21 Jun 2017 10:48:30 +0800
Message-ID: <1498013310-29253-1-git-send-email-wangkefeng.wang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Kefeng Wang <wangkefeng.wang@huawei.com>
List-Id: linux-scsi@vger.kernel.org

After commit 556e26a70b64 ("scsi: remove tsk_mgmt_response and
it_nexus_response transport methods"), the target driver support
was removed totally. Drop the residua.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 include/scsi/scsi_transport_fc.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index 6e208bb..e308cd5 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -658,10 +658,6 @@ struct fc_function_template {
 	int	(*vport_disable)(struct fc_vport *, bool);
 	int  	(*vport_delete)(struct fc_vport *);
 
-	/* target-mode drivers' functions */
-	int     (* tsk_mgmt_response)(struct Scsi_Host *, u64, u64, int);
-	int     (* it_nexus_response)(struct Scsi_Host *, u64, int);
-
 	/* bsg support */
 	int	(*bsg_request)(struct bsg_job *);
 	int	(*bsg_timeout)(struct bsg_job *);
-- 
1.7.12.4
