Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5E021255A;
	Fri, 24 Apr 2026 06:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777012644; cv=none; b=D94RTQHktNOJR1g1+uPtkrHYKWm/oi3kKLm4Ar45Dp1ctKgYSOStHCBiSHhPlN80GaZDo76egrAFO6qHKGQwLz+NYTAEyLTVYME4cnCSNW0wooNQQufKlar4UEwAyzUrwKF8qFDIn6seRBC/A3P5X6t7XNpHkysZw2Ta7zJGcO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777012644; c=relaxed/simple;
	bh=dz23iN3CJBRhxrlutVcASQIdeY3mJbCJA+zXkRwtnPI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YQatwqnlYCq+ZT6s44J2aVmHepnhT6LGlCf8/qRFvLVeFc3bz9eWO5E2h991lYSVC7Oz2IcSPvFkXj/Y2UKaUmnGRapcAmyur0/MAUr+0neStOLFGGgwmkqZMLOAO5eUUzhNe2L0CoUgLcOWfWvQK6DovR9cNydfjQehNZrh+LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=NvhB94Iy; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="NvhB94Iy"
X-UUID: 08ced5b43fa811f19781c1a04af40193-20260424
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=ZykPdAha4NPT9VYizZPytw0N8+6UcZsOK/5u+ZCHSTU=;
	b=NvhB94IyKRtXtcAP+Fn/BQJkYrbizGILFYMCKfGjop6GBhe5BzDBfQyheWtaIbVa5UjMvy8UsWrDl6kDrJtTXt4lDRJ4FmVo2rQ/R3DKWpM2SSRxUgY1B2x42H/GMZqbZ7pwSFT/YFGtFtqB/RP+ViNv/nHManH8y56yJvzc8cQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:69e4991d-9044-4195-92c7-0c56bca32393,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:e7bac3a,CLOUDID:374261be-65a8-4b41-ac18-3671578a914d,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102|123|836|865|888|898,TC:-5,Conten
	t:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,O
	SI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 08ced5b43fa811f19781c1a04af40193-20260424
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <ed.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1290462069; Fri, 24 Apr 2026 14:37:16 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 24 Apr 2026 14:37:14 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 24 Apr 2026 14:37:14 +0800
From: <ed.tsai@mediatek.com>
To: <ed.tsai@mediatek.com>, Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
	<avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mediatek@lists.infradead.org>, <wsd_upstream@mediatek.com>,
	<peter.wang@mediatek.com>, <alice.chao@mediatek.com>,
	<naomi.chu@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<linux-scsi@vger.kernel.org>
Subject: [PATCH 1/1] Revert "scsi: ufs: Use pre-calculated offsets in ufshcd_init_lrb()"
Date: Fri, 24 Apr 2026 14:35:55 +0800
Message-ID: <20260424063603.382328-2-ed.tsai@mediatek.com>
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

This reverts commit d5130c5a093257aa4542aaded8034ef116a7624a.

The offsets stored in utp_transfer_req_desc are in double words on
hosts without UFSHCD_QUIRK_PRDT_BYTE_GRAN, using them directly to
compute ucd_rsp_dma_addr and ucd_prdt_dma_addr results in incorrect
DMA addresses. The manual offsetof(struct utp_transfer_cmd_desc, ...)
calculations always yield correct byte offsets regardless of the quirk
and should be used instead.

Note that these DMA addresses are only used in ufshcd_print_tr() for
error logging, so the impact is limited to misleading error logs.

Fixes: d5130c5a0932 ("scsi: ufs: Use pre-calculated offsets in ufshcd_init_lrb()")
Signed-off-by: Ed Tsai <ed.tsai@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 4805e40ed4d7..3df2b44111cc 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2971,8 +2971,9 @@ static void ufshcd_init_lrb(struct ufs_hba *hba, struct scsi_cmnd *cmd)
 	struct utp_transfer_req_desc *utrdlp = hba->utrdl_base_addr;
 	dma_addr_t cmd_desc_element_addr =
 		hba->ucdl_dma_addr + i * ufshcd_get_ucd_size(hba);
-	u16 response_offset = le16_to_cpu(utrdlp[i].response_upiu_offset);
-	u16 prdt_offset = le16_to_cpu(utrdlp[i].prd_table_offset);
+	u16 response_offset = offsetof(struct utp_transfer_cmd_desc,
+				       response_upiu);
+	u16 prdt_offset = offsetof(struct utp_transfer_cmd_desc, prd_table);
 	struct ufshcd_lrb *lrb = scsi_cmd_priv(cmd);
 
 	lrb->utr_descriptor_ptr = utrdlp + i;
-- 
2.45.2

