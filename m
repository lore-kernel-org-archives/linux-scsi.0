Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A91F37FF71;
	Thu, 11 Jun 2026 23:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781220419; cv=none; b=IQYdasxknc2obEhMgJkf6OHCh5eSOLYYzPL4h0tOX0zcoVPPBltYsFk4NskU2tFIA9jlzl7A6CGrjNUBISyBEdHx6O8nYloYKMdfrA5tVWUTDdDM80HcjqUa1X86EM3UdzcvdCdZeGDB/GHyg4E+yDCYPDX9QDKMWj0R9oqmHsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781220419; c=relaxed/simple;
	bh=yQRUHhQ/GUdBIWZZWZd8rfP9NUEUKOMOnTy9i0aOAoE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qIC84dKoeaqMMbjadw8ZzErt6I9snte8wkbFm8+6JwqZcC8m/kB5d/aiiko6Qf7Au3neuYz/hkdCAP4Jl1nSZsO3+cH0tnZLp9cUOoM+1qJ5PQh3t1GO+6ZuW5MDk6sNvgFO+LDZ70hJCf23T4xqzySBrr7/uZv2x0WcKSYVkkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=EuMYz3CQ; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="EuMYz3CQ"
X-UUID: 02e8531c65ed11f18dc8c9802ae25ab1-20260612
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=8OvMGtIsGsOtMQl2xAttiCfpDCXCMY4lw0XAc8MsG7s=;
	b=EuMYz3CQrP8J56OFx50gM5in58b9DaacnbTJANb2twW05j8XoD1rljRWCs2oYcB40qvWxtAF7PrST5hCKybLw6Uv2Mfioi/oM3SfW0IeGg6Xntr/xR7EvMsIu0SfkQI8Bj1q+KJGCQZ1qY13sVuudIlnvHiITfCSQXsyO8SBj74=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.15,REQID:dc8eff2a-d96f-4925-bc9a-c099c7fc6538,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:e276073,CLOUDID:6301ae30-7784-4a77-a538-47ed6151d81b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|123|836|865|888|898,TC:-5,
	Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,C
	OL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 02e8531c65ed11f18dc8c9802ae25ab1-20260612
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw02.mediatek.com
	(envelope-from <ed.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1359894672; Fri, 12 Jun 2026 07:26:45 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 12 Jun 2026 07:26:45 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 12 Jun 2026 07:26:45 +0800
From: <ed.tsai@mediatek.com>
To: <alim.akhtar@samsung.com>, <avri.altman@wdc.com>, <bvanassche@acm.org>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mediatek@lists.infradead.org>, <wsd_upstream@mediatek.com>,
	<peter.wang@mediatek.com>, <alice.chao@mediatek.com>,
	<naomi.chu@mediatek.com>, <chun-hung.wu@mediatek.com>, Ed Tsai
	<ed.tsai@mediatek.com>
Subject: [PATCH v2 2/3] ufs: mediatek: Implement get_hba_nortt callback for RTT capability
Date: Fri, 12 Jun 2026 07:26:31 +0800
Message-ID: <20260611232632.2324422-3-ed.tsai@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260611232632.2324422-1-ed.tsai@mediatek.com>
References: <20260611232632.2324422-1-ed.tsai@mediatek.com>
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

Implement the get_hba_nortt callback to handle platform-specific RTT
capability differences:

- For legacy platforms and IP versions before MT6995 B0, the RTT
  capability from host controller register is problematic, so limit
  it to 2 (MTK_MAX_NUM_RTT_LEGACY).

- For MT6995 B0 and later platforms, the issue is fixed and the
  value from host controller capability register can be used directly.

This replaces the previous max_num_rtt field in ufs_hba_variant_ops
with dynamic platform-specific logic.

Signed-off-by: Ed Tsai <ed.tsai@mediatek.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/host/ufs-mediatek.c | 12 +++++++++++-
 drivers/ufs/host/ufs-mediatek.h |  4 ++--
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 3991a51263a6..58701ca95edd 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -2183,6 +2183,16 @@ static int ufs_mtk_clk_scale_notify(struct ufs_hba *hba, bool scale_up,
 	return 0;
 }
 
+static int ufs_mtk_get_hba_nortt(struct ufs_hba *hba)
+{
+	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
+
+	if (host->legacy_ip_ver || host->ip_ver < IP_VER_MT6995_B0)
+		return MTK_MAX_NUM_RTT_LEGACY;
+
+	return FIELD_GET(MASK_NUMBER_OUTSTANDING_RTT, hba->capabilities) + 1;
+}
+
 static int ufs_mtk_get_hba_mac(struct ufs_hba *hba)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
@@ -2322,7 +2332,6 @@ static void ufs_mtk_config_scsi_dev(struct scsi_device *sdev)
  */
 static const struct ufs_hba_variant_ops ufs_hba_mtk_vops = {
 	.name                = "mediatek.ufshci",
-	.max_num_rtt         = MTK_MAX_NUM_RTT,
 	.init                = ufs_mtk_init,
 	.get_ufs_hci_version = ufs_mtk_get_ufs_hci_version,
 	.setup_clocks        = ufs_mtk_setup_clocks,
@@ -2339,6 +2348,7 @@ static const struct ufs_hba_variant_ops ufs_hba_mtk_vops = {
 	.event_notify        = ufs_mtk_event_notify,
 	.config_scaling_param = ufs_mtk_config_scaling_param,
 	.clk_scale_notify    = ufs_mtk_clk_scale_notify,
+	.get_hba_nortt       = ufs_mtk_get_hba_nortt,
 	/* mcq vops */
 	.get_hba_mac         = ufs_mtk_get_hba_mac,
 	.op_runtime_config   = ufs_mtk_op_runtime_config,
diff --git a/drivers/ufs/host/ufs-mediatek.h b/drivers/ufs/host/ufs-mediatek.h
index 8547a6f04990..73cdc726f290 100644
--- a/drivers/ufs/host/ufs-mediatek.h
+++ b/drivers/ufs/host/ufs-mediatek.h
@@ -203,8 +203,8 @@ struct ufs_mtk_host {
 /* MTK delay of autosuspend: 500 ms */
 #define MTK_RPM_AUTOSUSPEND_DELAY_MS 500
 
-/* MTK RTT support number */
-#define MTK_MAX_NUM_RTT 2
+/* MTK RTT support number for platforms before MT6995 B0 */
+#define MTK_MAX_NUM_RTT_LEGACY 2
 
 /* UFSHCI MTK ip version value */
 enum {
-- 
2.45.2

