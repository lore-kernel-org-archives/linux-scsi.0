Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9152A2BE642;
	Tue,  9 Jun 2026 10:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781001546; cv=none; b=cZoOtjviKuO0apYYfTOd7s1/8COJoWjvCLHkHl+MlydSnx3+1FxIzAzcQdiEoTFos9TzCb4VcGZqjtVBq++ih/WRxTO49l3+64Fod9LCfEL3oLjKCUwMaRKHzWYxnHnYY4dDHU100I0UR+YYk5xP5NTAofMFsAB0W0WJIQtMMS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781001546; c=relaxed/simple;
	bh=z4WIGmsFqxNo2S+OL+Wo5vx5GqD113+EG1J2kmkMzBc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aJHdv0c5veIEyCj0s8DH9Rv75vkGECv+sQXK0Ee7Iai5t9zpl1azBd5WubWjz7EFzULJ0fpkpPeGHjvhMOP3zOpyYydzhMehBGksF1MV9/dvMOAlCaogzeVBG502taA/Dc32A4rj+hPR22A/M3DNsAZR0FMMRcpnAlEO97idBOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=cva/7Keq; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="cva/7Keq"
X-UUID: 6d29f5be63ef11f1b1788b6acf885367-20260609
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=AWWhb6Kkd8/3T2vcT+Lmqw/r3hhdc1FF4fcO9m1e+oQ=;
	b=cva/7KeqYsKL1trLxKOVgF9W5ed0qC6V/W/852Rk98pGXmLUmnUxqlz8Kko0Fav0htCpjNuJsIJhvkEK+OW5YJ4uHAQQe5CLj8EX1jLaKhnBMh4/VOoduRMTeaEMFbDKAOUkN926fFrz7WMvo7XSMf2zZuIVrBbvQB/JZ8IYjmU=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.15,REQID:6b16e134-58d6-40b5-b80c-46bdc4c9be9f,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:e276073,CLOUDID:3cb5dba4-9ef7-4489-861a-e83b251ece46,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|123|836|865|888|898,TC:-5,
	Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,C
	OL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6d29f5be63ef11f1b1788b6acf885367-20260609
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
	(envelope-from <ed.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1875318083; Tue, 09 Jun 2026 18:39:00 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Jun 2026 18:38:59 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 9 Jun 2026 18:38:59 +0800
From: <ed.tsai@mediatek.com>
To: <alim.akhtar@samsung.com>, <avri.altman@wdc.com>, <bvanassche@acm.org>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mediatek@lists.infradead.org>, <wsd_upstream@mediatek.com>,
	<peter.wang@mediatek.com>, <alice.chao@mediatek.com>,
	<naomi.chu@mediatek.com>, <chun-hung.wu@mediatek.com>, Ed Tsai
	<ed.tsai@mediatek.com>
Subject: [PATCH 2/2] ufs: mediatek: Implement get_hba_nortt callback for RTT capability
Date: Tue, 9 Jun 2026 18:38:56 +0800
Message-ID: <20260609103856.676222-3-ed.tsai@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260609103856.676222-1-ed.tsai@mediatek.com>
References: <20260609103856.676222-1-ed.tsai@mediatek.com>
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

