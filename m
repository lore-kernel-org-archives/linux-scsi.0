Return-Path: <SRS0=73BN=CK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 166E5C433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 11:35:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAE09206EF
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 11:35:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgIALe7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Sep 2020 07:34:59 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:44774 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726789AbgIALea (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 1 Sep 2020 07:34:30 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 4ADCB44067A7C855BD8A;
        Tue,  1 Sep 2020 19:17:07 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Tue, 1 Sep 2020 19:17:00 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linuxarm@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "John Garry" <john.garry@huawei.com>
Subject: [PATCH 7/8] scsi: hisi_sas: Add carriage returns to some prints
Date:   Tue, 1 Sep 2020 19:13:09 +0800
Message-ID: <1598958790-232272-8-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1598958790-232272-1-git-send-email-john.garry@huawei.com>
References: <1598958790-232272-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

There is no carriage return for some prints, so add carriage returns for
them.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 24 ++++++++++++------------
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  2 +-
 4 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 6d1e42389cd6..f5ad8e662b4b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -335,7 +335,7 @@ static int hisi_sas_dma_map(struct hisi_hba *hisi_hba,
 	}
 
 	if (*n_elem > HISI_SAS_SGE_PAGE_CNT) {
-		dev_err(dev, "task prep: n_elem(%d) > HISI_SAS_SGE_PAGE_CNT",
+		dev_err(dev, "task prep: n_elem(%d) > HISI_SAS_SGE_PAGE_CNT\n",
 			*n_elem);
 		rc = -EINVAL;
 		goto err_out_dma_unmap;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 7922a9bb1b28..45e866cb9164 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -752,7 +752,7 @@ static int hw_init_v1_hw(struct hisi_hba *hisi_hba)
 
 	rc = reset_hw_v1_hw(hisi_hba);
 	if (rc) {
-		dev_err(dev, "hisi_sas_reset_hw failed, rc=%d", rc);
+		dev_err(dev, "hisi_sas_reset_hw failed, rc=%d\n", rc);
 		return rc;
 	}
 
@@ -1166,7 +1166,7 @@ static void slot_err_v1_hw(struct hisi_hba *hisi_hba,
 	case SAS_PROTOCOL_STP:
 	case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:
 	{
-		dev_err(dev, "slot err: SATA/STP not supported");
+		dev_err(dev, "slot err: SATA/STP not supported\n");
 	}
 		break;
 	default:
@@ -1218,35 +1218,35 @@ static void slot_complete_v1_hw(struct hisi_hba *hisi_hba,
 		u32 info_reg = hisi_sas_read32(hisi_hba, HGC_INVLD_DQE_INFO);
 
 		if (info_reg & HGC_INVLD_DQE_INFO_DQ_MSK)
-			dev_err(dev, "slot complete: [%d:%d] has dq IPTT err",
+			dev_err(dev, "slot complete: [%d:%d] has dq IPTT err\n",
 				slot->cmplt_queue, slot->cmplt_queue_slot);
 
 		if (info_reg & HGC_INVLD_DQE_INFO_TYPE_MSK)
-			dev_err(dev, "slot complete: [%d:%d] has dq type err",
+			dev_err(dev, "slot complete: [%d:%d] has dq type err\n",
 				slot->cmplt_queue, slot->cmplt_queue_slot);
 
 		if (info_reg & HGC_INVLD_DQE_INFO_FORCE_MSK)
-			dev_err(dev, "slot complete: [%d:%d] has dq force phy err",
+			dev_err(dev, "slot complete: [%d:%d] has dq force phy err\n",
 				slot->cmplt_queue, slot->cmplt_queue_slot);
 
 		if (info_reg & HGC_INVLD_DQE_INFO_PHY_MSK)
-			dev_err(dev, "slot complete: [%d:%d] has dq phy id err",
+			dev_err(dev, "slot complete: [%d:%d] has dq phy id err\n",
 				slot->cmplt_queue, slot->cmplt_queue_slot);
 
 		if (info_reg & HGC_INVLD_DQE_INFO_ABORT_MSK)
-			dev_err(dev, "slot complete: [%d:%d] has dq abort flag err",
+			dev_err(dev, "slot complete: [%d:%d] has dq abort flag err\n",
 				slot->cmplt_queue, slot->cmplt_queue_slot);
 
 		if (info_reg & HGC_INVLD_DQE_INFO_IPTT_OF_MSK)
-			dev_err(dev, "slot complete: [%d:%d] has dq IPTT or ICT err",
+			dev_err(dev, "slot complete: [%d:%d] has dq IPTT or ICT err\n",
 				slot->cmplt_queue, slot->cmplt_queue_slot);
 
 		if (info_reg & HGC_INVLD_DQE_INFO_SSP_ERR_MSK)
-			dev_err(dev, "slot complete: [%d:%d] has dq SSP frame type err",
+			dev_err(dev, "slot complete: [%d:%d] has dq SSP frame type err\n",
 				slot->cmplt_queue, slot->cmplt_queue_slot);
 
 		if (info_reg & HGC_INVLD_DQE_INFO_OFL_MSK)
-			dev_err(dev, "slot complete: [%d:%d] has dq order frame len err",
+			dev_err(dev, "slot complete: [%d:%d] has dq order frame len err\n",
 				slot->cmplt_queue, slot->cmplt_queue_slot);
 
 		ts->stat = SAS_OPEN_REJECT;
@@ -1294,7 +1294,7 @@ static void slot_complete_v1_hw(struct hisi_hba *hisi_hba,
 	case SAS_PROTOCOL_SATA:
 	case SAS_PROTOCOL_STP:
 	case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:
-		dev_err(dev, "slot complete: SATA/STP not supported");
+		dev_err(dev, "slot complete: SATA/STP not supported\n");
 		break;
 
 	default:
@@ -1417,7 +1417,7 @@ static irqreturn_t int_bcast_v1_hw(int irq, void *p)
 	irq_value = hisi_sas_phy_read32(hisi_hba, phy_no, CHL_INT2);
 
 	if (!(irq_value & CHL_INT2_SL_RX_BC_ACK_MSK)) {
-		dev_err(dev, "bcast: irq_value = %x not set enable bit",
+		dev_err(dev, "bcast: irq_value = %x not set enable bit\n",
 			irq_value);
 		res = IRQ_NONE;
 		goto end;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 043f47ba3600..68d07a4f8422 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -1382,7 +1382,7 @@ static int hw_init_v2_hw(struct hisi_hba *hisi_hba)
 
 	rc = reset_hw_v2_hw(hisi_hba);
 	if (rc) {
-		dev_err(dev, "hisi_sas_reset_hw failed, rc=%d", rc);
+		dev_err(dev, "hisi_sas_reset_hw failed, rc=%d\n", rc);
 		return rc;
 	}
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 8522f693033f..397846388e85 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -909,7 +909,7 @@ static int hw_init_v3_hw(struct hisi_hba *hisi_hba)
 
 	rc = reset_hw_v3_hw(hisi_hba);
 	if (rc) {
-		dev_err(dev, "hisi_sas_reset_hw failed, rc=%d", rc);
+		dev_err(dev, "hisi_sas_reset_hw failed, rc=%d\n", rc);
 		return rc;
 	}
 
-- 
2.26.2

