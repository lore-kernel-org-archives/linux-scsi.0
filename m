From: Joe Perches <joe@perches.com>
Subject: [PATCH 7/9] drivers/scsi: Fix continuation lines
Date: Fri, 26 Mar 2010 19:27:56 -0700
Message-ID: <f5bb022bd07fa7fef29c9c4cebae250f7bf7a059.1269655922.git.joe@perches.com>
References: <cover.1269655208.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1269655208.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/arcmsr/arcmsr_hba.c |   50 +++++++++++++++++++-------------------
 drivers/scsi/qla2xxx/qla_attr.c  |   18 +++++++-------
 drivers/scsi/qla2xxx/qla_os.c    |    6 ++--
 3 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 47d5d19..07a9fd6 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -585,8 +585,8 @@ static void arcmsr_flush_hba_cache(struct AdapterControlBlock *acb)
 			break;
 		else {
 			retry_count--;
-			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' \
-			timeout, retry count down = %d \n", acb->host->host_no, retry_count);
+			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' "
+			"timeout, retry count down = %d\n", acb->host->host_no, retry_count);
 		}
 	} while (retry_count != 0);
 }
@@ -602,8 +602,8 @@ static void arcmsr_flush_hbb_cache(struct AdapterControlBlock *acb)
 			break;
 		else {
 			retry_count--;
-			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' \
-			timeout,retry count down = %d \n", acb->host->host_no, retry_count);
+			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' "
+			"timeout,retry count down = %d\n", acb->host->host_no, retry_count);
 		}
 	} while (retry_count != 0);
 }
@@ -732,14 +732,14 @@ static void arcmsr_drain_donequeue(struct AdapterControlBlock *acb, uint32_t fla
 			if (abortcmd) {
 				abortcmd->result |= DID_ABORT << 16;
 				arcmsr_ccb_complete(ccb, 1);
-				printk(KERN_NOTICE "arcmsr%d: ccb ='0x%p' \
-				isr got aborted command \n", acb->host->host_no, ccb);
+				printk(KERN_NOTICE "arcmsr%d: ccb ='0x%p' "
+				"isr got aborted command\n", acb->host->host_no, ccb);
 			}
 		}
-		printk(KERN_NOTICE "arcmsr%d: isr get an illegal ccb command \
-				done acb = '0x%p'"
-				"ccb = '0x%p' ccbacb = '0x%p' startdone = 0x%x"
-				" ccboutstandingcount = %d \n"
+		printk(KERN_NOTICE "arcmsr%d: isr get an illegal ccb command "
+				"done acb = '0x%p' "
+				"ccb = '0x%p' ccbacb = '0x%p' startdone = 0x%x "
+				"ccboutstandingcount = %d\n"
 				, acb->host->host_no
 				, acb
 				, ccb
@@ -1709,8 +1709,8 @@ static void arcmsr_get_hba_config(struct AdapterControlBlock *acb)
 
 	writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
 	if (arcmsr_hba_wait_msgint_ready(acb)) {
-		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
-			miscellaneous data' timeout \n", acb->host->host_no);
+		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware "
+		       "miscellaneous data' timeout\n", acb->host->host_no);
 	}
 
 	count = 8;
@@ -1753,8 +1753,8 @@ static void arcmsr_get_hbb_config(struct AdapterControlBlock *acb)
 
 	writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell_reg);
 	if (arcmsr_hbb_wait_msgint_ready(acb)) {
-		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
-			miscellaneous data' timeout \n", acb->host->host_no);
+		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware "
+		       "miscellaneous data' timeout\n", acb->host->host_no);
 	}
 
 	count = 8;
@@ -1889,8 +1889,8 @@ static void arcmsr_polling_hbb_ccbdone(struct AdapterControlBlock *acb,
 			poll_ccb_done = (ccb == poll_ccb) ? 1:0;
 			if ((ccb->acb != acb) || (ccb->startdone != ARCMSR_CCB_START)) {
 				if ((ccb->startdone == ARCMSR_CCB_ABORTED) || (ccb == poll_ccb)) {
-					printk(KERN_NOTICE "arcmsr%d: \
-		scsi id = %d lun = %d ccb = '0x%p' poll command abort successfully \n"
+					printk(KERN_NOTICE "arcmsr%d: "
+		"scsi id = %d lun = %d ccb = '0x%p' poll command abort successfully\n"
 						,acb->host->host_no
 						,ccb->pcmd->device->id
 						,ccb->pcmd->device->lun
@@ -1958,8 +1958,8 @@ static int arcmsr_iop_confirm(struct AdapterControlBlock *acb)
 			writel(ARCMSR_INBOUND_MESG0_SET_CONFIG, \
 							&reg->inbound_msgaddr0);
 			if (arcmsr_hba_wait_msgint_ready(acb)) {
-				printk(KERN_NOTICE "arcmsr%d: ""set ccb high \
-				part physical address timeout\n",
+				printk(KERN_NOTICE "arcmsr%d: set ccb high "
+				"part physical address timeout\n",
 				acb->host->host_no);
 				return 1;
 			}
@@ -1999,14 +1999,14 @@ static int arcmsr_iop_confirm(struct AdapterControlBlock *acb)
 
 		writel(ARCMSR_MESSAGE_SET_CONFIG, reg->drv2iop_doorbell_reg);
 		if (arcmsr_hbb_wait_msgint_ready(acb)) {
-			printk(KERN_NOTICE "arcmsr%d: 'set command Q window' \
-			timeout \n",acb->host->host_no);
+			printk(KERN_NOTICE "arcmsr%d: 'set command Q window' "
+			"timeout\n",acb->host->host_no);
 			return 1;
 		}
 
 		writel(ARCMSR_MESSAGE_START_DRIVER_MODE, reg->drv2iop_doorbell_reg);
 		if (arcmsr_hbb_wait_msgint_ready(acb)) {
-			printk(KERN_NOTICE "arcmsr%d: 'can not set diver mode \n"\
+			printk(KERN_NOTICE "arcmsr%d: 'can not set diver mode\n"
 			,acb->host->host_no);
 			return 1;
 		}
@@ -2048,8 +2048,8 @@ static void arcmsr_start_hba_bgrb(struct AdapterControlBlock *acb)
 	acb->acb_flags |= ACB_F_MSG_START_BGRB;
 	writel(ARCMSR_INBOUND_MESG0_START_BGRB, &reg->inbound_msgaddr0);
 	if (arcmsr_hba_wait_msgint_ready(acb)) {
-		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background \
-				rebulid' timeout \n", acb->host->host_no);
+		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background "
+				"rebuild' timeout\n", acb->host->host_no);
 	}
 }
 
@@ -2059,8 +2059,8 @@ static void arcmsr_start_hbb_bgrb(struct AdapterControlBlock *acb)
 	acb->acb_flags |= ACB_F_MSG_START_BGRB;
 	writel(ARCMSR_MESSAGE_START_BGRB, reg->drv2iop_doorbell_reg);
 	if (arcmsr_hbb_wait_msgint_ready(acb)) {
-		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background \
-				rebulid' timeout \n",acb->host->host_no);
+		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background "
+				"rebuild' timeout\n",acb->host->host_no);
 	}
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 90d1e06..ea87ea7 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1946,9 +1946,9 @@ qla2x00_process_els(struct fc_bsg_job *bsg_job)
 	    (rsp_sg_cnt != bsg_job->reply_payload.sg_cnt))
 	{
 		DEBUG2(printk(KERN_INFO
-		    "dma mapping resulted in different sg counts \
-		    [request_sg_cnt: %x dma_request_sg_cnt: %x\
-		    reply_sg_cnt: %x dma_reply_sg_cnt: %x]\n",
+		    "dma mapping resulted in different sg counts "
+		    "[request_sg_cnt: %x dma_request_sg_cnt: %x "
+		    "reply_sg_cnt: %x dma_reply_sg_cnt: %x]\n",
 		    bsg_job->request_payload.sg_cnt, req_sg_cnt,
 		    bsg_job->reply_payload.sg_cnt, rsp_sg_cnt));
 		rval = -EAGAIN;
@@ -2040,9 +2040,9 @@ qla2x00_process_ct(struct fc_bsg_job *bsg_job)
 		(rsp_sg_cnt != bsg_job->reply_payload.sg_cnt))
 	{
 		DEBUG2(qla_printk(KERN_WARNING, ha,
-		    "dma mapping resulted in different sg counts \
-		    [request_sg_cnt: %x dma_request_sg_cnt: %x\
-		    reply_sg_cnt: %x dma_reply_sg_cnt: %x]\n",
+		    "dma mapping resulted in different sg counts "
+		    "[request_sg_cnt: %x dma_request_sg_cnt: %x "
+		    "reply_sg_cnt: %x dma_reply_sg_cnt: %x]\n",
 		    bsg_job->request_payload.sg_cnt, req_sg_cnt,
 		    bsg_job->reply_payload.sg_cnt, rsp_sg_cnt));
 		rval = -EAGAIN;
@@ -2184,9 +2184,9 @@ qla2x00_process_vendor_specific(struct fc_bsg_job *bsg_job)
 	    (elreq.rsp_sg_cnt != bsg_job->reply_payload.sg_cnt))
 	{
 		DEBUG2(printk(KERN_INFO
-		    "dma mapping resulted in different sg counts \
-		    [request_sg_cnt: %x dma_request_sg_cnt: %x\
-		    reply_sg_cnt: %x dma_reply_sg_cnt: %x]\n",
+		    "dma mapping resulted in different sg counts "
+		    "[request_sg_cnt: %x dma_request_sg_cnt: %x "
+		    "reply_sg_cnt: %x dma_reply_sg_cnt: %x]\n",
 		    bsg_job->request_payload.sg_cnt, elreq.req_sg_cnt,
 		    bsg_job->reply_payload.sg_cnt, elreq.rsp_sg_cnt));
 		rval = -EAGAIN;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 46720b2..eccbff3 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -87,9 +87,9 @@ MODULE_PARM_DESC(ql2xiidmaenable,
 int ql2xmaxqueues = 1;
 module_param(ql2xmaxqueues, int, S_IRUGO|S_IRUSR);
 MODULE_PARM_DESC(ql2xmaxqueues,
-		"Enables MQ settings "
-		"Default is 1 for single queue. Set it to number \
-			of queues in MQ mode.");
+		 "Enables MQ settings "
+		 "Default is 1 for single queue. "
+		 "Set it to number of queues in MQ mode.");
 
 int ql2xmultique_tag;
 module_param(ql2xmultique_tag, int, S_IRUGO|S_IRUSR);
-- 
1.7.0.14.g7e948
