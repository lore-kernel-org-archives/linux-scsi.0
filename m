From: Joe Perches <joe@perches.com>
Subject: [PATCH 05/10] drivers/scsi/arcmsr: Fix continuation line formats
Date: Sun, 31 Jan 2010 12:02:07 -0800
Message-ID: <1a318fa326c6ab2584b9d318bd1538e7f7debbdf.1264967499.git.joe@perches.com>
References: <cover.1264967493.git.joe@perches.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754408Ab0AaUEf@vger.kernel.org>
In-Reply-To: <cover.1264967493.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

String constants that are continued on subsequent lines with \
are not good.
Fix rebulid/rebuild typos

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/arcmsr/arcmsr_hba.c |   49 +++++++++++++++++--------------------
 1 files changed, 23 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 47d5d19..a0378d5 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -585,8 +585,8 @@ static void arcmsr_flush_hba_cache(struct AdapterControlBlock *acb)
 			break;
 		else {
 			retry_count--;
-			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' \
-			timeout, retry count down = %d \n", acb->host->host_no, retry_count);
+			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' timeout, retry count down = %d \n",
+			       acb->host->host_no, retry_count);
 		}
 	} while (retry_count != 0);
 }
@@ -602,8 +602,8 @@ static void arcmsr_flush_hbb_cache(struct AdapterControlBlock *acb)
 			break;
 		else {
 			retry_count--;
-			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' \
-			timeout,retry count down = %d \n", acb->host->host_no, retry_count);
+			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' timeout,retry count down = %d \n",
+			       acb->host->host_no, retry_count);
 		}
 	} while (retry_count != 0);
 }
@@ -732,12 +732,11 @@ static void arcmsr_drain_donequeue(struct AdapterControlBlock *acb, uint32_t fla
 			if (abortcmd) {
 				abortcmd->result |= DID_ABORT << 16;
 				arcmsr_ccb_complete(ccb, 1);
-				printk(KERN_NOTICE "arcmsr%d: ccb ='0x%p' \
-				isr got aborted command \n", acb->host->host_no, ccb);
+				printk(KERN_NOTICE "arcmsr%d: ccb ='0x%p' isr got aborted command \n",
+				       acb->host->host_no, ccb);
 			}
 		}
-		printk(KERN_NOTICE "arcmsr%d: isr get an illegal ccb command \
-				done acb = '0x%p'"
+		printk(KERN_NOTICE "arcmsr%d: isr get an illegal ccb command done acb = '0x%p'"
 				"ccb = '0x%p' ccbacb = '0x%p' startdone = 0x%x"
 				" ccboutstandingcount = %d \n"
 				, acb->host->host_no
@@ -1001,7 +1000,7 @@ static void arcmsr_stop_hba_bgrb(struct AdapterControlBlock *acb)
 
 	if (arcmsr_hba_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE
-			"arcmsr%d: wait 'stop adapter background rebulid' timeout \n"
+			"arcmsr%d: wait 'stop adapter background rebuild' timeout \n"
 			, acb->host->host_no);
 	}
 }
@@ -1014,7 +1013,7 @@ static void arcmsr_stop_hbb_bgrb(struct AdapterControlBlock *acb)
 
 	if (arcmsr_hbb_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE
-			"arcmsr%d: wait 'stop adapter background rebulid' timeout \n"
+			"arcmsr%d: wait 'stop adapter background rebuild' timeout \n"
 			, acb->host->host_no);
 	}
 }
@@ -1709,8 +1708,8 @@ static void arcmsr_get_hba_config(struct AdapterControlBlock *acb)
 
 	writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
 	if (arcmsr_hba_wait_msgint_ready(acb)) {
-		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
-			miscellaneous data' timeout \n", acb->host->host_no);
+		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware miscellaneous data' timeout \n",
+		       acb->host->host_no);
 	}
 
 	count = 8;
@@ -1753,8 +1752,8 @@ static void arcmsr_get_hbb_config(struct AdapterControlBlock *acb)
 
 	writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell_reg);
 	if (arcmsr_hbb_wait_msgint_ready(acb)) {
-		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
-			miscellaneous data' timeout \n", acb->host->host_no);
+		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware miscellaneous data' timeout \n",
+		       acb->host->host_no);
 	}
 
 	count = 8;
@@ -1889,8 +1888,7 @@ static void arcmsr_polling_hbb_ccbdone(struct AdapterControlBlock *acb,
 			poll_ccb_done = (ccb == poll_ccb) ? 1:0;
 			if ((ccb->acb != acb) || (ccb->startdone != ARCMSR_CCB_START)) {
 				if ((ccb->startdone == ARCMSR_CCB_ABORTED) || (ccb == poll_ccb)) {
-					printk(KERN_NOTICE "arcmsr%d: \
-		scsi id = %d lun = %d ccb = '0x%p' poll command abort successfully \n"
+					printk(KERN_NOTICE "arcmsr%d: scsi id = %d lun = %d ccb = '0x%p' poll command abort successfully \n"
 						,acb->host->host_no
 						,ccb->pcmd->device->id
 						,ccb->pcmd->device->lun
@@ -1958,8 +1956,7 @@ static int arcmsr_iop_confirm(struct AdapterControlBlock *acb)
 			writel(ARCMSR_INBOUND_MESG0_SET_CONFIG, \
 							&reg->inbound_msgaddr0);
 			if (arcmsr_hba_wait_msgint_ready(acb)) {
-				printk(KERN_NOTICE "arcmsr%d: ""set ccb high \
-				part physical address timeout\n",
+				printk(KERN_NOTICE "arcmsr%d: ""set ccb high part physical address timeout\n",
 				acb->host->host_no);
 				return 1;
 			}
@@ -1979,7 +1976,7 @@ static int arcmsr_iop_confirm(struct AdapterControlBlock *acb)
 		reg->doneq_index = 0;
 		writel(ARCMSR_MESSAGE_SET_POST_WINDOW, reg->drv2iop_doorbell_reg);
 		if (arcmsr_hbb_wait_msgint_ready(acb)) {
-			printk(KERN_NOTICE "arcmsr%d:can not set diver mode\n", \
+			printk(KERN_NOTICE "arcmsr%d:can not set diver mode\n",
 				acb->host->host_no);
 			return 1;
 		}
@@ -1999,14 +1996,14 @@ static int arcmsr_iop_confirm(struct AdapterControlBlock *acb)
 
 		writel(ARCMSR_MESSAGE_SET_CONFIG, reg->drv2iop_doorbell_reg);
 		if (arcmsr_hbb_wait_msgint_ready(acb)) {
-			printk(KERN_NOTICE "arcmsr%d: 'set command Q window' \
-			timeout \n",acb->host->host_no);
+			printk(KERN_NOTICE "arcmsr%d: 'set command Q window' timeout \n",
+			       acb->host->host_no);
 			return 1;
 		}
 
 		writel(ARCMSR_MESSAGE_START_DRIVER_MODE, reg->drv2iop_doorbell_reg);
 		if (arcmsr_hbb_wait_msgint_ready(acb)) {
-			printk(KERN_NOTICE "arcmsr%d: 'can not set diver mode \n"\
+			printk(KERN_NOTICE "arcmsr%d: 'can not set diver mode \n"
 			,acb->host->host_no);
 			return 1;
 		}
@@ -2048,8 +2045,8 @@ static void arcmsr_start_hba_bgrb(struct AdapterControlBlock *acb)
 	acb->acb_flags |= ACB_F_MSG_START_BGRB;
 	writel(ARCMSR_INBOUND_MESG0_START_BGRB, &reg->inbound_msgaddr0);
 	if (arcmsr_hba_wait_msgint_ready(acb)) {
-		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background \
-				rebulid' timeout \n", acb->host->host_no);
+		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background rebuild' timeout \n",
+		       acb->host->host_no);
 	}
 }
 
@@ -2059,8 +2056,8 @@ static void arcmsr_start_hbb_bgrb(struct AdapterControlBlock *acb)
 	acb->acb_flags |= ACB_F_MSG_START_BGRB;
 	writel(ARCMSR_MESSAGE_START_BGRB, reg->drv2iop_doorbell_reg);
 	if (arcmsr_hbb_wait_msgint_ready(acb)) {
-		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background \
-				rebulid' timeout \n",acb->host->host_no);
+		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background rebuild' timeout \n",
+		       acb->host->host_no);
 	}
 }
 
-- 
1.6.6.rc0.57.gad7a
