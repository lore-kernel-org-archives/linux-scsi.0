Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE7A374724;
	Thu,  5 Mar 2026 08:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772699788; cv=none; b=abq04kMYHWZjkmU/lfc4k8oLXp1+WPBn7i2l2ku90ATDerYLTJqLrDMaREir2q5DJsmUralg5dlwha27bzFxqt9gML9xq52EdBxNv5eFskBLPGWhbzFUDfzHY1iSqRt2WtZ5hyxVa64MNqpP/SInRxYvBAHEn8h2i1b29TPEsYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772699788; c=relaxed/simple;
	bh=gAGnqsFGNlzQ4m1NFZbwF/xIyQytJmXdbf/lQP4a8lw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tRinu/y0e3AFvppm7Och6c9bTKg8FNA8Jo8YwnzOaw5N1AtrZEmoSq6qn8UX+7J16U1xavAMi5uv3Yys0ZF1bpwWOC0o0ugTC71Nvmzg1J4sNjM30oEvwnGVftIjFqioIvL+whNNZlOgAjBkpXoMDSviVJln1laxOzA0CVYFjWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Tdlsf0Sp; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Tdlsf0Sp"
X-UUID: 6294b994186e11f1bcd7499a721e883d-20260305
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=sO3PHAXEthLTTVgRRTRR8lgRQjQwsnb19jUyvaCx/sk=;
	b=Tdlsf0SphbBYkV++DkIdD1TnGfoP5TMLwrFxowZRPrPF8v5MsFMeeHbCPFOpOQuWrOhZRlk/fH6w5rBDNoNtDD7I8EUvutVXEEOGXRhGQCM7d7tLNdO8xAFgw86s85rJw4neuoj8d25hiY68RtkKsC7ElBQW88nR5hd14+CdaKQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:5eafc9ab-e012-4cfe-8df7-46f39480b3fa,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:940046ea-ef90-4382-9c6f-55f2a0689a6b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|123|836|888|898,TC:-5,Cont
	ent:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0
	,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6294b994186e11f1bcd7499a721e883d-20260305
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
	(envelope-from <ed.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 632924527; Thu, 05 Mar 2026 16:36:20 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 5 Mar 2026 16:36:19 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Thu, 5 Mar 2026 16:36:19 +0800
From: <ed.tsai@mediatek.com>
To: Peter Wang <peter.wang@mediatek.com>, Chaotian Jing
	<chaotian.jing@mediatek.com>, Stanley Jhu <chu.stanley@gmail.com>, "James
 E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
CC: Ed Tsai <ed.tsai@mediatek.com>, <linux-scsi@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 2/2] ufs: host: mediatek: Add VCC on delay for stability
Date: Thu, 5 Mar 2026 16:29:15 +0800
Message-ID: <20260305083610.2672344-3-ed.tsai@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260305083610.2672344-1-ed.tsai@mediatek.com>
References: <20260305083610.2672344-1-ed.tsai@mediatek.com>
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

Introduced a delay after enabling UFS5 VCC for MT6995 to ensure
voltage stability before refclk activation.

Signed-off-by: Ed Tsai <ed.tsai@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 11 +++++++++++
 drivers/ufs/host/ufs-mediatek.h |  4 ++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index b3daaa07e925..020302f8fbdf 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1960,6 +1960,8 @@ static int ufs_mtk_apply_dev_quirks(struct ufs_hba *hba)
 
 static void ufs_mtk_fixup_dev_quirks(struct ufs_hba *hba)
 {
+	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
+
 	ufshcd_fixup_dev_quirks(hba, ufs_mtk_dev_fixups);
 
 	if (ufs_mtk_is_broken_vcc(hba) && hba->vreg_info.vcc) {
@@ -1971,6 +1973,15 @@ static void ufs_mtk_fixup_dev_quirks(struct ufs_hba *hba)
 		hba->dev_quirks &= ~UFS_DEVICE_QUIRK_DELAY_BEFORE_LPM;
 	}
 
+	/*
+	 * Add a delay after enable UFS5 VCC to ensure the voltage is
+	 * stable before the refclk enable.
+	 */
+	if (hba->dev_info.wspecversion >= 0x0500 &&
+	    (host->ip_ver == IP_VER_MT6995_A0 ||
+	     host->ip_ver == IP_VER_MT6995_B0))
+		hba->quirks |= UFSHCD_QUIRK_VCC_ON_DELAY;
+
 	ufs_mtk_vreg_fix_vcc(hba);
 	ufs_mtk_vreg_fix_vccqx(hba);
 	ufs_mtk_fix_ahit(hba);
diff --git a/drivers/ufs/host/ufs-mediatek.h b/drivers/ufs/host/ufs-mediatek.h
index 9747277f11e8..8547a6f04990 100644
--- a/drivers/ufs/host/ufs-mediatek.h
+++ b/drivers/ufs/host/ufs-mediatek.h
@@ -220,6 +220,10 @@ enum {
 	IP_VER_MT6991_B0 = 0x10470000,
 	IP_VER_MT6993    = 0x10480000,
 
+	/* UFSHCI 5.0 */
+	IP_VER_MT6995_A0 = 0x10490000,
+	IP_VER_MT6995_B0 = 0x10500000,
+
 	IP_VER_NONE      = 0xFFFFFFFF
 };
 
-- 
2.45.2

