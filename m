Return-Path: <SRS0=73BN=CK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 817E1C433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 11:23:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F0B0206C0
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 11:23:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgIALWi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Sep 2020 07:22:38 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:47606 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726285AbgIALTu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 1 Sep 2020 07:19:50 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 5F488E04F8117BC3CBA4;
        Tue,  1 Sep 2020 19:17:07 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Tue, 1 Sep 2020 19:17:00 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linuxarm@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, Luo Jiaxing <luojiaxing@huawei.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 8/8] scsi: hisi_sas: Some very minor tidying
Date:   Tue, 1 Sep 2020 19:13:10 +0800
Message-ID: <1598958790-232272-9-git-send-email-john.garry@huawei.com>
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

From: Luo Jiaxing <luojiaxing@huawei.com>

We found an extra blank line at the end of some functions, so delete them.

And add spaces around some operators.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 1 -
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 2 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 4 +---
 3 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index f5ad8e662b4b..f18452942508 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1430,7 +1430,6 @@ static void hisi_sas_rescan_topology(struct hisi_hba *hisi_hba, u32 state)
 		} else {
 			hisi_sas_phy_down(hisi_hba, phy_no, 0);
 		}
-
 	}
 }
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 68d07a4f8422..b57177b52fac 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -1202,7 +1202,7 @@ static void init_reg_v2_hw(struct hisi_hba *hisi_hba)
 	hisi_sas_write32(hisi_hba, ENT_INT_SRC_MSK3, 0x7ffe20fe);
 	hisi_sas_write32(hisi_hba, SAS_ECC_INTR_MSK, 0xfff00c30);
 	for (i = 0; i < hisi_hba->queue_count; i++)
-		hisi_sas_write32(hisi_hba, OQ0_INT_SRC_MSK+0x4*i, 0);
+		hisi_sas_write32(hisi_hba, OQ0_INT_SRC_MSK + 0x4 * i, 0);
 
 	hisi_sas_write32(hisi_hba, AXI_AHB_CLK_CFG, 1);
 	hisi_sas_write32(hisi_hba, HYPER_STREAM_ID_EN_CFG, 1);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 397846388e85..87bda037303f 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -596,7 +596,7 @@ static void init_reg_v3_hw(struct hisi_hba *hisi_hba)
 	hisi_sas_write32(hisi_hba, AWQOS_AWCACHE_CFG, 0xf0f0);
 	hisi_sas_write32(hisi_hba, ARQOS_ARCACHE_CFG, 0xf0f0);
 	for (i = 0; i < hisi_hba->queue_count; i++)
-		hisi_sas_write32(hisi_hba, OQ0_INT_SRC_MSK+0x4*i, 0);
+		hisi_sas_write32(hisi_hba, OQ0_INT_SRC_MSK + 0x4 * i, 0);
 
 	hisi_sas_write32(hisi_hba, HYPER_STREAM_ID_EN_CFG, 1);
 
@@ -1350,7 +1350,6 @@ static void prep_smp_v3_hw(struct hisi_hba *hisi_hba,
 
 	hdr->cmd_table_addr = cpu_to_le64(req_dma_addr);
 	hdr->sts_buffer_addr = cpu_to_le64(hisi_sas_status_buf_addr_dma(slot));
-
 }
 
 static void prep_ata_v3_hw(struct hisi_hba *hisi_hba,
@@ -1456,7 +1455,6 @@ static void prep_abort_v3_hw(struct hisi_hba *hisi_hba,
 	/* dw7 */
 	hdr->dw7 = cpu_to_le32(tag_to_abort << CMD_HDR_ABORT_IPTT_OFF);
 	hdr->transfer_tags = cpu_to_le32(slot->idx);
-
 }
 
 static irqreturn_t phy_up_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
-- 
2.26.2

