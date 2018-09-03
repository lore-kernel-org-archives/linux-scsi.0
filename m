From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH trivial] scsi: arcmsr: Spelling s/rebulid/rebuild/
Date: Mon,  3 Sep 2018 19:35:29 +0200
Message-ID: <20180903173529.7865-1-geert+renesas@glider.be>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Jiri Kosina <trivial@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/scsi/arcmsr/arcmsr_hba.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 12316ef4c8931853..cc0be46511281050 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1798,7 +1798,7 @@ static void arcmsr_hbaA_stop_bgrb(struct AdapterControlBlock *acb)
 	writel(ARCMSR_INBOUND_MESG0_STOP_BGRB, &reg->inbound_msgaddr0);
 	if (!arcmsr_hbaA_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE
-			"arcmsr%d: wait 'stop adapter background rebulid' timeout\n"
+			"arcmsr%d: wait 'stop adapter background rebuild' timeout\n"
 			, acb->host->host_no);
 	}
 }
@@ -1811,7 +1811,7 @@ static void arcmsr_hbaB_stop_bgrb(struct AdapterControlBlock *acb)
 
 	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE
-			"arcmsr%d: wait 'stop adapter background rebulid' timeout\n"
+			"arcmsr%d: wait 'stop adapter background rebuild' timeout\n"
 			, acb->host->host_no);
 	}
 }
@@ -1824,7 +1824,7 @@ static void arcmsr_hbaC_stop_bgrb(struct AdapterControlBlock *pACB)
 	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);
 	if (!arcmsr_hbaC_wait_msgint_ready(pACB)) {
 		printk(KERN_NOTICE
-			"arcmsr%d: wait 'stop adapter background rebulid' timeout\n"
+			"arcmsr%d: wait 'stop adapter background rebuild' timeout\n"
 			, pACB->host->host_no);
 	}
 	return;
@@ -1837,7 +1837,7 @@ static void arcmsr_hbaD_stop_bgrb(struct AdapterControlBlock *pACB)
 	pACB->acb_flags &= ~ACB_F_MSG_START_BGRB;
 	writel(ARCMSR_INBOUND_MESG0_STOP_BGRB, reg->inbound_msgaddr0);
 	if (!arcmsr_hbaD_wait_msgint_ready(pACB))
-		pr_notice("arcmsr%d: wait 'stop adapter background rebulid' "
+		pr_notice("arcmsr%d: wait 'stop adapter background rebuild' "
 			"timeout\n", pACB->host->host_no);
 }
 
@@ -1850,7 +1850,7 @@ static void arcmsr_hbaE_stop_bgrb(struct AdapterControlBlock *pACB)
 	pACB->out_doorbell ^= ARCMSR_HBEMU_DRV2IOP_MESSAGE_CMD_DONE;
 	writel(pACB->out_doorbell, &reg->iobound_doorbell);
 	if (!arcmsr_hbaE_wait_msgint_ready(pACB)) {
-		pr_notice("arcmsr%d: wait 'stop adapter background rebulid' "
+		pr_notice("arcmsr%d: wait 'stop adapter background rebuild' "
 			"timeout\n", pACB->host->host_no);
 	}
 }
@@ -3927,7 +3927,7 @@ static void arcmsr_hbaA_start_bgrb(struct AdapterControlBlock *acb)
 	writel(ARCMSR_INBOUND_MESG0_START_BGRB, &reg->inbound_msgaddr0);
 	if (!arcmsr_hbaA_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background \
-				rebulid' timeout \n", acb->host->host_no);
+				rebuild' timeout \n", acb->host->host_no);
 	}
 }
 
@@ -3938,7 +3938,7 @@ static void arcmsr_hbaB_start_bgrb(struct AdapterControlBlock *acb)
 	writel(ARCMSR_MESSAGE_START_BGRB, reg->drv2iop_doorbell);
 	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background \
-				rebulid' timeout \n",acb->host->host_no);
+				rebuild' timeout \n",acb->host->host_no);
 	}
 }
 
@@ -3950,7 +3950,7 @@ static void arcmsr_hbaC_start_bgrb(struct AdapterControlBlock *pACB)
 	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &phbcmu->inbound_doorbell);
 	if (!arcmsr_hbaC_wait_msgint_ready(pACB)) {
 		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background \
-				rebulid' timeout \n", pACB->host->host_no);
+				rebuild' timeout \n", pACB->host->host_no);
 	}
 	return;
 }
@@ -3963,7 +3963,7 @@ static void arcmsr_hbaD_start_bgrb(struct AdapterControlBlock *pACB)
 	writel(ARCMSR_INBOUND_MESG0_START_BGRB, pmu->inbound_msgaddr0);
 	if (!arcmsr_hbaD_wait_msgint_ready(pACB)) {
 		pr_notice("arcmsr%d: wait 'start adapter "
-			"background rebulid' timeout\n", pACB->host->host_no);
+			"background rebuild' timeout\n", pACB->host->host_no);
 	}
 }
 
@@ -3977,7 +3977,7 @@ static void arcmsr_hbaE_start_bgrb(struct AdapterControlBlock *pACB)
 	writel(pACB->out_doorbell, &pmu->iobound_doorbell);
 	if (!arcmsr_hbaE_wait_msgint_ready(pACB)) {
 		pr_notice("arcmsr%d: wait 'start adapter "
-			"background rebulid' timeout \n", pACB->host->host_no);
+			"background rebuild' timeout \n", pACB->host->host_no);
 	}
 }
 
-- 
2.17.1
