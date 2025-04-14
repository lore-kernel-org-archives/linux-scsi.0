Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A96258CC6;
	Mon, 14 Apr 2025 08:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744618132; cv=none; b=pO9YXEuGY6qVxDAjZi1QKCT7hC65+Em63PR8RUoWysIlTz5uRcC2cLDI6q0teuaen0+nb19vlh8Xcz5KsZeP9Td5TVg7rHSvpKyGOJ/SaFjtKzBzI50HJWAbct5S7xF8e3YsybA5GA0qpD0Vqln03fKOSuR4kxu9jNfHBV0dC40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744618132; c=relaxed/simple;
	bh=DxIkP2FGqZHZivO6iWOA6+iQlVG7NGP+Fzm7t71Dc5U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DBn93ToQim8UnetPYF4f8EXOKgtl5wl7WUSHvYr5ePcV2Ufg9F2z2Q8zk/J/eL9gU0wOpaCodXZiqXV4gk1j9DkkcrQTtWTtw+QHTAqA5QvwMjHMYs7Cx/z0YepplF3oKPUSFmp0I5ul/KGMbPR7yvhUPOd3B8JsvkHNU6BlJ/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Zbfzg1GPDz13LPq;
	Mon, 14 Apr 2025 16:07:59 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 706F0180B4B;
	Mon, 14 Apr 2025 16:08:46 +0800 (CST)
Received: from localhost.localdomain (10.50.165.33) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 14 Apr 2025 16:08:46 +0800
From: Yihang Li <liyihang9@huawei.com>
To: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@huawei.com>, <liuyonglong@huawei.com>,
	<prime.zeng@hisilicon.com>
Subject: [PATCH v3 2/4] scsi: hisi_sas: Code style cleanup
Date: Mon, 14 Apr 2025 16:08:43 +0800
Message-ID: <20250414080845.1220997-3-liyihang9@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250414080845.1220997-1-liyihang9@huawei.com>
References: <20250414080845.1220997-1-liyihang9@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemf100013.china.huawei.com (7.185.36.179)

Here are some useless blank lines and symbols, remove them and add spaces
around operators.

Signed-off-by: Yihang Li <liyihang9@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  8 ++++----
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 11 +++--------
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  6 +++---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 15 ++++++---------
 5 files changed, 17 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 99ca26b96df2..1323ed8aa717 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -359,7 +359,7 @@ struct hisi_sas_hw {
 	const struct scsi_host_template *sht;
 };
 
-#define HISI_SAS_MAX_DEBUGFS_DUMP (50)
+#define HISI_SAS_MAX_DEBUGFS_DUMP 50
 #define HISI_SAS_DEFAULT_DEBUGFS_DUMP 1
 
 struct hisi_sas_debugfs_cq {
@@ -460,12 +460,12 @@ struct hisi_hba {
 	dma_addr_t sata_breakpoint_dma;
 	struct hisi_sas_slot	*slot_info;
 	unsigned long flags;
-	const struct hisi_sas_hw *hw;	/* Low level hw interface */
+	const struct hisi_sas_hw *hw; /* Low level hw interface */
 	unsigned long sata_dev_bitmap[BITS_TO_LONGS(HISI_SAS_MAX_DEVICES)];
 	struct work_struct rst_work;
 	u32 phy_state;
-	u32 intr_coal_ticks;	/* Time of interrupt coalesce in us */
-	u32 intr_coal_count;	/* Interrupt count to coalesce */
+	u32 intr_coal_ticks; /* Time of interrupt coalesce in us */
+	u32 intr_coal_count; /* Interrupt count to coalesce */
 
 	int cq_nvecs;
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 6326644ac9f6..d7f9d1d853cf 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -124,12 +124,10 @@ u8 hisi_sas_get_ata_protocol(struct sas_task *task)
 		}
 
 	default:
-	{
 		if (direction == DMA_NONE)
 			return HISI_SAS_SATA_PROTOCOL_NONDATA;
 		return hisi_sas_get_ata_protocol_from_tf(qc);
 	}
-	}
 }
 EXPORT_SYMBOL_GPL(hisi_sas_get_ata_protocol);
 
@@ -141,7 +139,7 @@ void hisi_sas_sata_done(struct sas_task *task,
 	struct hisi_sas_status_buffer *status_buf =
 			hisi_sas_status_buf_addr_mem(slot);
 	u8 *iu = &status_buf->iu[0];
-	struct dev_to_host_fis *d2h =  (struct dev_to_host_fis *)iu;
+	struct dev_to_host_fis *d2h = (struct dev_to_host_fis *)iu;
 
 	resp->frame_len = sizeof(struct dev_to_host_fis);
 	memcpy(&resp->ending_fis[0], d2h, sizeof(struct dev_to_host_fis));
@@ -1926,12 +1924,9 @@ static int hisi_sas_lu_reset(struct domain_device *device, u8 *lun)
 	hisi_sas_dereg_device(hisi_hba, device);
 
 	if (dev_is_sata(device)) {
-		struct sas_phy *phy;
-
-		phy = sas_get_local_phy(device);
+		struct sas_phy *phy = sas_get_local_phy(device);
 
 		rc = sas_phy_reset(phy, true);
-
 		if (rc == 0)
 			hisi_sas_release_task(hisi_hba, device);
 		sas_put_local_phy(phy);
@@ -2115,7 +2110,7 @@ void hisi_sas_phy_down(struct hisi_hba *hisi_hba, int phy_no, int rdy,
 		hisi_sas_bytes_dmaed(hisi_hba, phy_no, gfp_flags);
 		hisi_sas_port_notify_formed(sas_phy);
 	} else {
-		struct hisi_sas_port *port  = phy->port;
+		struct hisi_sas_port *port = phy->port;
 
 		if (test_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags) ||
 		    phy->in_reset) {
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 6621d633b2cc..6d97339371fb 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1759,7 +1759,7 @@ static const struct scsi_host_template sht_v1_hw = {
 	.sg_tablesize		= HISI_SAS_SGE_PAGE_CNT,
 	.sdev_init		= hisi_sas_sdev_init,
 	.shost_groups		= host_v1_hw_groups,
-	.host_reset             = hisi_sas_host_reset,
+	.host_reset		= hisi_sas_host_reset,
 };
 
 static const struct hisi_sas_hw hisi_sas_v1_hw = {
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index a1fc400ab4c3..61377039ce71 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2766,7 +2766,7 @@ static irqreturn_t int_phy_updown_v2_hw(int irq_no, void *p)
 	irq_msk = (hisi_sas_read32(hisi_hba, HGC_INVLD_DQE_INFO)
 		   >> HGC_INVLD_DQE_INFO_FB_CH0_OFF) & 0x1ff;
 	while (irq_msk) {
-		if (irq_msk  & 1) {
+		if (irq_msk & 1) {
 			u32 reg_value = hisi_sas_phy_read32(hisi_hba, phy_no,
 					    CHL_INT0);
 
@@ -3106,7 +3106,7 @@ static irqreturn_t fatal_axi_int_v2_hw(int irq_no, void *p)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t  cq_thread_v2_hw(int irq_no, void *p)
+static irqreturn_t cq_thread_v2_hw(int irq_no, void *p)
 {
 	struct hisi_sas_cq *cq = p;
 	struct hisi_hba *hisi_hba = cq->hisi_hba;
@@ -3494,7 +3494,7 @@ static int write_gpio_v2_hw(struct hisi_hba *hisi_hba, u8 reg_type,
 			 * numbered drive in the fourth byte.
 			 * See SFF-8485 Rev. 0.7 Table 24.
 			 */
-			void __iomem  *reg_addr = hisi_hba->sgpio_regs +
+			void __iomem *reg_addr = hisi_hba->sgpio_regs +
 					reg_index * 4 + phy_no;
 			int data_idx = phy_no + 3 - (phy_no % 4) * 2;
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index e3e99bc5bbdf..15f1d5d783cb 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1348,8 +1348,8 @@ static void prep_ssp_v3_hw(struct hisi_hba *hisi_hba,
 	/* map itct entry */
 	dw1 |= sas_dev->device_id << CMD_HDR_DEV_ID_OFF;
 
-	dw2 = (((sizeof(struct ssp_command_iu) + sizeof(struct ssp_frame_hdr)
-	      + 3) / BYTE_TO_DW) << CMD_HDR_CFL_OFF) |
+	dw2 = (((sizeof(struct ssp_command_iu) + sizeof(struct ssp_frame_hdr) +
+	         3) / BYTE_TO_DW) << CMD_HDR_CFL_OFF) |
 	      ((HISI_SAS_MAX_SSP_RESP_SZ / BYTE_TO_DW) << CMD_HDR_MRFL_OFF) |
 	      (HDR_SG_MOD << CMD_HDR_SG_MOD_OFF);
 	hdr->dw2 = cpu_to_le32(dw2);
@@ -1740,7 +1740,7 @@ static irqreturn_t int_phy_up_down_bcast_v3_hw(int irq_no, void *p)
 	irq_msk = hisi_sas_read32(hisi_hba, CHNL_INT_STATUS)
 				& 0x11111111;
 	while (irq_msk) {
-		if (irq_msk  & 1) {
+		if (irq_msk & 1) {
 			u32 irq_value = hisi_sas_phy_read32(hisi_hba, phy_no,
 							    CHL_INT0);
 			u32 phy_state = hisi_sas_read32(hisi_hba, PHY_STATE);
@@ -1963,8 +1963,7 @@ static irqreturn_t int_chnl_int_v3_hw(int irq_no, void *p)
 	u32 irq_msk;
 	int phy_no = 0;
 
-	irq_msk = hisi_sas_read32(hisi_hba, CHNL_INT_STATUS)
-		  & CHNL_INT_STS_MSK;
+	irq_msk = hisi_sas_read32(hisi_hba, CHNL_INT_STATUS) & CHNL_INT_STS_MSK;
 
 	while (irq_msk) {
 		if (irq_msk & (CHNL_INT_STS_INT0_MSK << (phy_no * CHNL_WIDTH)))
@@ -2609,7 +2608,6 @@ static int interrupt_preinit_v3_hw(struct hisi_hba *hisi_hba)
 	if (vectors < 0)
 		return -ENOENT;
 
-
 	hisi_hba->cq_nvecs = vectors - BASE_VECTORS_V3_HW - hisi_hba->iopoll_q_cnt;
 	shost->nr_hw_queues = hisi_hba->cq_nvecs + hisi_hba->iopoll_q_cnt;
 
@@ -3300,7 +3298,7 @@ static int debugfs_set_bist_v3_hw(struct hisi_hba *hisi_hba, bool enable)
 		/* some preparations before bist test */
 		hisi_sas_bist_test_prep_v3_hw(hisi_hba);
 
-		/* set linkrate of bit test*/
+		/* set linkrate of bit test */
 		reg_val = hisi_sas_phy_read32(hisi_hba, phy_no,
 					      PROG_PHY_LINK_RATE);
 		reg_val &= ~CFG_PROG_OOB_PHY_LINK_RATE_MSK;
@@ -3398,7 +3396,7 @@ static const struct scsi_host_template sht_v3_hw = {
 	.shost_groups		= host_v3_hw_groups,
 	.sdev_groups		= sdev_groups_v3_hw,
 	.tag_alloc_policy_rr	= true,
-	.host_reset             = hisi_sas_host_reset,
+	.host_reset		= hisi_sas_host_reset,
 	.host_tagset		= 1,
 	.mq_poll		= queue_complete_v3_hw,
 };
@@ -3649,7 +3647,6 @@ static void debugfs_print_reg_v3_hw(u32 *regs_val, struct seq_file *s,
 
 		name = debugfs_to_reg_name_v3_hw(off, reg->base_off,
 						 reg->lu);
-
 		if (name)
 			seq_printf(s, "0x%08x 0x%08x %s\n", off,
 				   regs_val[i], name);
-- 
2.33.0

