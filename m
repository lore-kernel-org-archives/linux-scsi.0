Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4320C9443;
	Tue, 10 Mar 2026 00:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773104125; cv=none; b=hnesp5gXMBrt3ZRNacNyb9K5XoQvRcffOPrKsE7i2ZID8p1NTmuHlz3Y4M7zeSbd+KbBHJQRDjmBu6Ch3DoK2RAHdgYXSfZ5fngIHNGhYjkp5oSF+AC/ShCz7NVdnk1rWvIRqmFH7po2ddjw4E1MuhtEVzcHEDPf7zgh1JXCqkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773104125; c=relaxed/simple;
	bh=SuXR0Y6/zQydvg5tqHXSdnnVXgFUIAQ1jadgZdhuTYs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hQHfiHBtFmm1CqVXALoHCgaztoyGoJ2trUfJmjG95vktUXwmNZRsLW26m9vvWwjqHjhR2KyVIXnmxW5o73TKZL468hmO+CrsOTMyHq8XT2txtDvCLAbqcVZRRtf1hvj2a/49Hk9Ew0+CtUvEhQoEqrg3IsaH+qn2BxmYkCV7o1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=ndT/5ptx; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ndT/5ptx"
X-UUID: cd5201141c1b11f1a39cd589f645bc18-20260310
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=U1F0aD+CzjJwe4XQ5783eJK+juRpKEbGlXhwX8wPolo=;
	b=ndT/5ptxiBIT6feVvAtTWMDVvoTf6PdX++UVQgm9TfSyryXJYbxNFIbOvr5IcLMjqtyH6rMOmolpvnOwJlYsKGIDRjFqW0wRTSl8XKnXDQFEe8Ivj62MC/lENLg8HtTun9PHjIwpM1/R2+D1rbBvyeO8R/r6VzZhKSr7zNjLIWM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:e183be2c-945d-4e68-b4db-e46395140958,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:72070d5c-a957-4259-bcca-d3af718d7034,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|123|836|888|898,TC:-5,Cont
	ent:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0
	,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: cd5201141c1b11f1a39cd589f645bc18-20260310
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <ed.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2104375953; Tue, 10 Mar 2026 08:55:15 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 10 Mar 2026 08:55:14 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 10 Mar 2026 08:55:14 +0800
From: <ed.tsai@mediatek.com>
To: <bvanassche@acm.org>, Peter Wang <peter.wang@mediatek.com>, Chaotian Jing
	<chaotian.jing@mediatek.com>, Stanley Jhu <chu.stanley@gmail.com>, "James
 E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mediatek@lists.infradead.org>, <wsd_upstream@mediatek.com>,
	<alice.chao@mediatek.com>, <naomi.chu@mediatek.com>,
	<chun-hung.wu@mediatek.com>, Ed Tsai <ed.tsai@mediatek.com>,
	<linux-scsi@vger.kernel.org>
Subject: [PATCH v2 2/2] ufs: host: mediatek: Add VCC on delay for stability
Date: Tue, 10 Mar 2026 08:52:30 +0800
Message-ID: <20260310005230.4001904-6-ed.tsai@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260310005230.4001904-2-ed.tsai@mediatek.com>
References: <20260310005230.4001904-2-ed.tsai@mediatek.com>
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

Introduce a delay after enabling UFS5 VCC for MT6995 to ensure
voltage stability before refclk activation.

Signed-off-by: Ed Tsai <ed.tsai@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 11 +++++++++++
 drivers/ufs/host/ufs-mediatek.h |  4 ++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index b3daaa07e925..4618d7834414 100644
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
+	 * Add a delay after enabling UFS5 VCC to ensure the voltage
+	 * is stable before the refclk is enabled.
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

