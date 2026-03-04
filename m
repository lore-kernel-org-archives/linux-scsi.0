Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA3A3B3C1C;
	Wed,  4 Mar 2026 14:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772636173; cv=pass; b=qmhLNwqZ+7OePrJ55bYki5hmlOyT30HQW8UNLtHsN+CAS16xplVhopLr38fAcdSFpEbrxD+6b43Pw0Tc+BcOjgUVHd/R0340v0cvl6iaH/t6CvjwM7cEM5c8mxrX16xY0GgBH7iPzoWPRAojSbBAb90I+woKMGFqThj37FTKMVc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772636173; c=relaxed/simple;
	bh=GjFf63axbaazfur7KNFjfv9PwinzFu/ZI3jq7p25c4k=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=frrSrSahvi16Pu2RSRuUaFDlUI+Ghpf9yKBAmNnVpVPNt0xzcEmTYiVjW/Nt8xMsuBuEZsCWyOmrsaTNouCbLlfCQYk6fUayNiIKUxQBwmJ4/3Udmr2sYBTkfl0Ktm6CExNvkVSCM5/ilRRRk7vwWVqr/MZof1URidsS0eqCgvU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=CAIVtC2j; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="CAIVtC2j"
ARC-Seal: i=1; a=rsa-sha256; t=1772636138; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=AU0dfGiZJIbbK19p+MDgaZqtm2R8hFunuv7hkxWvN6CN/Aehq1IiXkufMjjxOL+R25jcZDVaPiMZfBItqQtx75t42UPS+/GgGnRIUqfkplF11c4ihG1S3X30yatO7evq/t4n+4V9xSku8D16cGIyjOQjw1ZXk7afzaTo/2Wioi0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1772636138; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=4zl1V74JjZEQ00igJg/pKn4t3Auq4QD7fJPZAoJSVfA=; 
	b=gVlxjpgtsUFSiDmVuH1dHsCkCcvn3hhWRu2pjJvqKFZCevfTZPYhmUGpobIh2sCnRq5Ciu2SyjLfO2x2zY+ACJIK50SV4Tu6LB37FnyUkfRyeK8DvH8WZgw/P0gQXQnvxefRett//bTBNB0uM98T6uHy9eUegPTQ0uQeSDSJYQg=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1772636138;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=4zl1V74JjZEQ00igJg/pKn4t3Auq4QD7fJPZAoJSVfA=;
	b=CAIVtC2jK4y+72dTp8PKmASE6jlKNXnPR7+5yTnczVfwQIxsAE1s+eZp8CUQsKwR
	yq+31FkI+NLA2Im8mXncAY/VPyFUzIYORcdaORlxoEp3lwIhNDnB5dRaiVH8AYe3ip1
	cK3jtSiLDlRxqgwnoELj0W8RVGgyqMCy/Vq86t0g=
Received: by mx.zohomail.com with SMTPS id 177263613629493.10029857824361;
	Wed, 4 Mar 2026 06:55:36 -0800 (PST)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Wed, 04 Mar 2026 15:53:28 +0100
Subject: [PATCH v8 23/23] scsi: ufs: mediatek: Add MT8196 compatible,
 update copyright
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260304-mt8196-ufs-v8-23-5b0eac23314f@collabora.com>
References: <20260304-mt8196-ufs-v8-0-5b0eac23314f@collabora.com>
In-Reply-To: <20260304-mt8196-ufs-v8-0-5b0eac23314f@collabora.com>
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Chunfeng Yun <chunfeng.yun@mediatek.com>, Vinod Koul <vkoul@kernel.org>, 
 Kishon Vijay Abraham I <kishon@kernel.org>, 
 Peter Wang <peter.wang@mediatek.com>, Stanley Jhu <chu.stanley@gmail.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Philipp Zabel <p.zabel@pengutronix.de>, Liam Girdwood <lgirdwood@gmail.com>, 
 Mark Brown <broonie@kernel.org>, Chaotian Jing <Chaotian.Jing@mediatek.com>, 
 Neil Armstrong <neil.armstrong@linaro.org>
Cc: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>, 
 kernel@collabora.com, linux-scsi@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, 
 linux-phy@lists.infradead.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
X-Mailer: b4 0.14.3

THe MT8196's UFS controller has a new compatible. Add the necessary
struct definitions to support it.

Also update the copyrights and authors, without tabs following spaces to
avoid checkpatch errors, to list myself as having contributed to this
driver after the preceding rework patches.

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 6292c943ef99..a9e8641e6f29 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1,9 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2019 MediaTek Inc.
+ * Copyright (C) 2025 Collabora Ltd.
  * Authors:
- *	Stanley Chu <stanley.chu@mediatek.com>
- *	Peter Wang <peter.wang@mediatek.com>
+ *      Stanley Chu <stanley.chu@mediatek.com>
+ *      Peter Wang <peter.wang@mediatek.com>
+ *      Nicolas Frattaroli <nicolas.frattaroli@collabora.com> (Major cleanups)
  */
 
 #include <linux/arm-smccc.h>
@@ -2200,6 +2202,10 @@ static const char *const ufs_mtk_regs_avdd12_ckbuf_avdd18[] = {
 	"avdd12", "avdd12-ckbuf", "avdd18"
 };
 
+static const char *const ufs_mtk_regs_avdd12_ckbuf[] = {
+	"avdd12", "avdd12-ckbuf"
+};
+
 static const struct ufs_mtk_soc_data mt8183_data = {
 	.has_avdd09 = true,
 	.reg_names = ufs_mtk_regs_avdd12_avdd18,
@@ -2212,10 +2218,17 @@ static const struct ufs_mtk_soc_data mt8192_8195_data = {
 	.num_reg_names = ARRAY_SIZE(ufs_mtk_regs_avdd12_ckbuf_avdd18),
 };
 
+static const struct ufs_mtk_soc_data mt8196_data = {
+	.has_avdd09 = true,
+	.reg_names = ufs_mtk_regs_avdd12_ckbuf,
+	.num_reg_names = ARRAY_SIZE(ufs_mtk_regs_avdd12_ckbuf),
+};
+
 static const struct of_device_id ufs_mtk_of_match[] = {
 	{ .compatible = "mediatek,mt8183-ufshci", .data = &mt8183_data },
 	{ .compatible = "mediatek,mt8192-ufshci", .data = &mt8192_8195_data },
 	{ .compatible = "mediatek,mt8195-ufshci", .data = &mt8192_8195_data },
+	{ .compatible = "mediatek,mt8196-ufshci", .data = &mt8196_data },
 	{},
 };
 MODULE_DEVICE_TABLE(of, ufs_mtk_of_match);

-- 
2.53.0

