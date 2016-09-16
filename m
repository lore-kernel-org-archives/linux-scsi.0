From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: [PATCH v1] Ibmvscsis: Fixed unused variable
Date: Fri, 16 Sep 2016 09:25:56 -0500
Message-ID: <1474035956-91228-1-git-send-email-bryantly@linux.vnet.ibm.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: nab@linux-iscsi.org, martin.petersen@oracle.com
Cc: mikecyr@linux.vnet.ibm.com, James.Bottomley@HansenPartnership.com, tyreld@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index b29fef9..f8ba2a0 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -3193,8 +3193,6 @@ static int ibmvscsis_rdma(struct ibmvscsis_cmd *cmd, struct scatterlist *sg,
 					 server_ioba);
 		} else {
 			/* write to client */
-			struct srp_cmd *srp = (struct srp_cmd *)iue->sbuf->buf;
-
 			if (!READ_CMD(srp->cdb))
 				print_hex_dump_bytes(" data:", DUMP_PREFIX_NONE,
 						     sg_virt(sgp), buf_len);
-- 
2.5.4 (Apple Git-61)
