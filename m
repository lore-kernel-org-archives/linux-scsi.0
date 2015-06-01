From: Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH v2 3/3] megaraid_sas : fix whitespace errors
Date: Mon, 01 Jun 2015 10:40:17 -0500
Message-ID: <20150601154017.23309.87065.stgit@bhelgaas-glaptop2.roam.corp.google.com>
References: <20150601153240.23309.73917.stgit@bhelgaas-glaptop2.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150601153240.23309.73917.stgit@bhelgaas-glaptop2.roam.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kashyap Desai <kashyap.desai@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>
Cc: megaraidlinux.pdl@avagotech.com, "James E.J. Bottomley" <JBottomley@odin.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Fix whitespace and indentation errors.  No code change.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index a8c512f..e002efd 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1458,7 +1458,7 @@ megasas_dump_pending_frames(struct megasas_instance *instance)
 	dev_err(&instance->pdev->dev, "megasas[%d]: Pending OS cmds in FW : \n",instance->host->host_no);
 	for (i = 0; i < max_cmd; i++) {
 		cmd = instance->cmd_list[i];
-		if(!cmd->scmd)
+		if (!cmd->scmd)
 			continue;
 		dev_err(&instance->pdev->dev, "megasas[%d]: Frame addr :0x%08lx : ",instance->host->host_no,(unsigned long)cmd->frame_phys_addr);
 		if (megasas_cmd_type(cmd->scmd) == READ_WRITE_LDIO) {
@@ -1470,8 +1470,7 @@ megasas_dump_pending_frames(struct megasas_instance *instance)
 			instance->host->host_no, cmd->frame_count, ldio->cmd, ldio->target_id,
 			le32_to_cpu(ldio->start_lba_lo), le32_to_cpu(ldio->start_lba_hi),
 			le32_to_cpu(ldio->sense_buf_phys_addr_lo), sgcount);
-		}
-		else {
+		} else {
 			pthru = (struct megasas_pthru_frame *) cmd->frame;
 			mfi_sgl = &pthru->sgl;
 			sgcount = pthru->sge_count;
@@ -1481,16 +1480,16 @@ megasas_dump_pending_frames(struct megasas_instance *instance)
 			pthru->lun, pthru->cdb_len, le32_to_cpu(pthru->data_xfer_len),
 			le32_to_cpu(pthru->sense_buf_phys_addr_lo), sgcount);
 		}
-	if(megasas_dbg_lvl & MEGASAS_DBG_LVL){
-		for (n = 0; n < sgcount; n++){
-			if (IS_DMA64)
-				dev_err(&instance->pdev->dev, "sgl len : 0x%x, sgl addr : 0x%llx\n",
-					le32_to_cpu(mfi_sgl->sge64[n].length),
-					le64_to_cpu(mfi_sgl->sge64[n].phys_addr));
-			else
-				dev_err(&instance->pdev->dev, "sgl len : 0x%x, sgl addr : 0x%x\n",
-					le32_to_cpu(mfi_sgl->sge32[n].length),
-					le32_to_cpu(mfi_sgl->sge32[n].phys_addr));
+		if (megasas_dbg_lvl & MEGASAS_DBG_LVL) {
+			for (n = 0; n < sgcount; n++) {
+				if (IS_DMA64)
+					dev_err(&instance->pdev->dev, "sgl len : 0x%x, sgl addr : 0x%llx\n",
+						le32_to_cpu(mfi_sgl->sge64[n].length),
+						le64_to_cpu(mfi_sgl->sge64[n].phys_addr));
+				else
+					dev_err(&instance->pdev->dev, "sgl len : 0x%x, sgl addr : 0x%x\n",
+						le32_to_cpu(mfi_sgl->sge32[n].length),
+						le32_to_cpu(mfi_sgl->sge32[n].phys_addr));
 			}
 		}
 	} /*for max_cmd*/
@@ -1499,9 +1498,8 @@ megasas_dump_pending_frames(struct megasas_instance *instance)
 
 		cmd = instance->cmd_list[i];
 
-		if(cmd->sync_cmd == 1){
+		if (cmd->sync_cmd == 1)
 			dev_err(&instance->pdev->dev, "0x%08lx : ", (unsigned long)cmd->frame_phys_addr);
-		}
 	}
 	dev_err(&instance->pdev->dev, "megasas[%d]: Dumping Done.\n\n",instance->host->host_no);
 }
