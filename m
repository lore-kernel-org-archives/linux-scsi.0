Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4239362154;
	Mon, 27 Apr 2026 03:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777262401; cv=none; b=GatUAwoV5O1iq7pYl7CFW7m3TVcH/YGuatasEr9cngMUbjOOVx+FviE2qIvR2ylg7LXcC8ezdirb1qafcvvCUfDECgKXm0+0FTGtSY7n39YSGEFuB4dJ/+OoZjpFc8dPVtmucKxGWyzenvop7fvMnHWm0zm1B6UkJXScq2AMNbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777262401; c=relaxed/simple;
	bh=nNuZPMQoVpPQeuMTX7IqQVkKdKmGKIfoGkiXy1++kJA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=HwblJ3hgrnBfjtlneAyMOqPe5b0d3vEkhP+f8LWTgTyGU8ZKqogM1D7xxx2TIioV+vFQVe72su86nL+Dwc5qPsaWfJQQfCv7NS6RFFrTOBebjCXhW5LjR5vXTM4PXuIBbXBVqCarYcgNHpgWpfKDm8hAWjNIVLTLK3CYNRr/olw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=uODj5HGn; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="uODj5HGn"
X-UUID: 8c9de93841ed11f19a16598d5ca7f8ec-20260427
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=HLfP7RQwgpPifnMM74MC5Zii/CVwx7iM9Oh2BZUeh4k=;
	b=uODj5HGn0m42tVVvtlDYuEQIpMyjh7Ys85E5eQCX9J5wsA3LFeaA2usK6L7h28Q+d8k2xnIPOnj72LZqVFySAjjBQAbQxB0v7OKQMFv4K6HAvtsF52OyK3X4qzyIv9zDhYOkutqMUcJDTtuN9iqizRg0anlG56nE3UNG27w9K6o=;
X-CID-CACHE: Type:Local,Time:202604271157+08,HitQuantity:2
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:a768fb8b-e66e-4b00-96c2-fb4a38329217,IP:0,U
	RL:0,TC:0,Content:-25,EDM:-25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACT
	ION:release,TS:-50
X-CID-META: VersionHash:e7bac3a,CLOUDID:7e35a564-469e-4eb6-aeb8-4b21454b0f32,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102|123|836|865|888|898,TC:-5,Conten
	t:0|15|50,EDM:2,IP:nil,URL:99|1,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0
	,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 8c9de93841ed11f19a16598d5ca7f8ec-20260427
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
	(envelope-from <ed.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 801184413; Mon, 27 Apr 2026 11:59:54 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 27 Apr 2026 11:59:53 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 27 Apr 2026 11:59:53 +0800
From: <ed.tsai@mediatek.com>
To: <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
	<avri.altman@wdc.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mediatek@lists.infradead.org>, <wsd_upstream@mediatek.com>,
	<peter.wang@mediatek.com>, <alice.chao@mediatek.com>,
	<naomi.chu@mediatek.com>, <chun-hung.wu@mediatek.com>, Ed Tsai
	<ed.tsai@mediatek.com>, <stable@vger.kernel.org>,
	<linux-scsi@vger.kernel.org>
Subject: [PATCH 1/1] scsi: ufs: remove ucd_rsp_dma_addr and ucd_prdt_dma_addr from ufshcd_lrb
Date: Mon, 27 Apr 2026 11:58:41 +0800
Message-ID: <20260427035856.1610363-1-ed.tsai@mediatek.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

From: Ed Tsai <ed.tsai@mediatek.com>

The offsets stored in utp_transfer_req_desc are in double words on
hosts without UFSHCD_QUIRK_PRDT_BYTE_GRAN, using them directly to
compute ucd_rsp_dma_addr and ucd_prdt_dma_addr results in incorrect
DMA addresses.

Since these fields are only used for error logging, remove them from
struct ufshcd_lrb and compute directly in ufshcd_print_tr() using
offsetof(struct utp_transfer_cmd_desc, ...) instead.

Fixes: d5130c5a0932 ("scsi: ufs: Use pre-calculated offsets in ufshcd_init_lrb()")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20260424063603.382328-2-ed.tsai@mediatek.com/
Signed-off-by: Ed Tsai <ed.tsai@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 10 ++++------
 include/ufs/ufshcd.h      |  4 ----
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 4805e40ed4d7..02fa61322e77 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -621,7 +621,8 @@ static void ufshcd_print_tr(struct ufs_hba *hba, struct scsi_cmnd *cmd,
 	ufshcd_hex_dump("UPIU REQ: ", lrbp->ucd_req_ptr,
 			sizeof(struct utp_upiu_req));
 	dev_err(hba->dev, "UPIU[%d] - Response UPIU phys@0x%llx\n", tag,
-		(u64)lrbp->ucd_rsp_dma_addr);
+		(u64)(lrbp->ucd_req_dma_addr +
+		offsetof(struct utp_transfer_cmd_desc, response_upiu)));
 	ufshcd_hex_dump("UPIU RSP: ", lrbp->ucd_rsp_ptr,
 			sizeof(struct utp_upiu_rsp));
 
@@ -633,7 +634,8 @@ static void ufshcd_print_tr(struct ufs_hba *hba, struct scsi_cmnd *cmd,
 	dev_err(hba->dev,
 		"UPIU[%d] - PRDT - %d entries  phys@0x%llx\n",
 		tag, prdt_length,
-		(u64)lrbp->ucd_prdt_dma_addr);
+		(u64)(lrbp->ucd_req_dma_addr +
+		offsetof(struct utp_transfer_cmd_desc, prd_table)));
 
 	if (pr_prdt)
 		ufshcd_hex_dump("UPIU PRDT: ", lrbp->ucd_prdt_ptr,
@@ -2971,8 +2973,6 @@ static void ufshcd_init_lrb(struct ufs_hba *hba, struct scsi_cmnd *cmd)
 	struct utp_transfer_req_desc *utrdlp = hba->utrdl_base_addr;
 	dma_addr_t cmd_desc_element_addr =
 		hba->ucdl_dma_addr + i * ufshcd_get_ucd_size(hba);
-	u16 response_offset = le16_to_cpu(utrdlp[i].response_upiu_offset);
-	u16 prdt_offset = le16_to_cpu(utrdlp[i].prd_table_offset);
 	struct ufshcd_lrb *lrb = scsi_cmd_priv(cmd);
 
 	lrb->utr_descriptor_ptr = utrdlp + i;
@@ -2981,9 +2981,7 @@ static void ufshcd_init_lrb(struct ufs_hba *hba, struct scsi_cmnd *cmd)
 	lrb->ucd_req_ptr = (struct utp_upiu_req *)cmd_descp->command_upiu;
 	lrb->ucd_req_dma_addr = cmd_desc_element_addr;
 	lrb->ucd_rsp_ptr = (struct utp_upiu_rsp *)cmd_descp->response_upiu;
-	lrb->ucd_rsp_dma_addr = cmd_desc_element_addr + response_offset;
 	lrb->ucd_prdt_ptr = (struct ufshcd_sg_entry *)cmd_descp->prd_table;
-	lrb->ucd_prdt_dma_addr = cmd_desc_element_addr + prdt_offset;
 }
 
 static void __ufshcd_setup_cmd(struct ufs_hba *hba, struct scsi_cmnd *cmd,
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index cfbc75d8df83..8cb845534e63 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -158,8 +158,6 @@ struct ufs_pm_lvl_states {
  * @ucd_rsp_ptr: Response UPIU address for this command
  * @ucd_prdt_ptr: PRDT address of the command
  * @utrd_dma_addr: UTRD dma address for debug
- * @ucd_prdt_dma_addr: PRDT dma address for debug
- * @ucd_rsp_dma_addr: UPIU response dma address for debug
  * @ucd_req_dma_addr: UPIU request dma address for debug
  * @scsi_status: SCSI status of the command
  * @command_type: SCSI, UFS, Query.
@@ -182,8 +180,6 @@ struct ufshcd_lrb {
 
 	dma_addr_t utrd_dma_addr;
 	dma_addr_t ucd_req_dma_addr;
-	dma_addr_t ucd_rsp_dma_addr;
-	dma_addr_t ucd_prdt_dma_addr;
 
 	int scsi_status;
 
-- 
2.45.2

