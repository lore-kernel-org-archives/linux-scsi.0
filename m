Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1982FDC5C;
	Sat, 24 Jan 2026 12:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769256273; cv=pass; b=RGCWWK2PlnmehHjS80DEX8hsVhidlYdy1+Gvn2gdm6UDdzSYSFCnVUmg/va9cfs6TVK9Te5iPuX1uQyKVlYkixQOWw4hPIm3YPGJ+mBakjAZOhFh1KbEnnf/w1aS0EULClSPs3pNw8BGagwG+vGNBGMNtIU4Q/m8+UHg4E+M2AM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769256273; c=relaxed/simple;
	bh=ymW4BpyME1X2O1TrkGsy7Yvv62Hi7pyk1DGYNHJlEdc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=abrW0gshsQuUAnwK69STkza34z1QdHJ3zwdWDRoD3Ld+eEgDy1J4hYEzZtHR9XjfpGjlzMFrcbZyE3L3xeC6L6BdZAUXBXnsDwONi7tfTDh++wSqx6TBWc+qiGJSG4myCBoZIci1bEFhNRXa9ruQJEZ+h/q+gwZsNKaBshyflb4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=TcFOVL4X; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="TcFOVL4X"
ARC-Seal: i=1; a=rsa-sha256; t=1769256227; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Clmph66c94IkTIeFRDIF8uqQCZD0OX5C0zjCSQHa+E8HMyrlBFuZIO55+iCftY2FNeBSohKO1e1M+pvXO90Z66QKDuW+K6OXWXD27kDHjcAZoJpPbbSwNypSKmM06FZI1hF/N+RH10DMfnZVP5+pZ47Mm1TMOKd4t6SnWAJDgKM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1769256227; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=LSb03+iC1nJjGHi21/8jtlMcWILa2md04bWqw4bZO+g=; 
	b=A7NzvSP43SjlBOsqyqsh6tWWEfIDkwKvQATp/CMxU93a8LNMMF+yHj7D8rC2PXpi5lxP8blrvQnK28TvgNlNmFU7WgVN7Fmjj2ilzulFZlqvrv/pwofSXTETTFdfJ63PDBBnTZoqdrn3LmT6XmE6VO7NM3mvIFIdwjHqKSRwOks=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1769256227;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=LSb03+iC1nJjGHi21/8jtlMcWILa2md04bWqw4bZO+g=;
	b=TcFOVL4XNUY/+o8oOD0KIVHFBvmpnR947eGoY4oX42HJxfgpk0RuImS4IPSQLC6W
	5oJxuaiJBeIgWNXJm2152499ITSDkK+nfEWGNan+Asnc3ywcpRcS6iqeXSqPpRqrSfm
	EaMg1JFRIbqJTQ0uDNXzCJ/D6acaqxHQl6+4KQ7g=
Received: by mx.zohomail.com with SMTPS id 1769256226151691.4301652673644;
	Sat, 24 Jan 2026 04:03:46 -0800 (PST)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Sat, 24 Jan 2026 13:01:10 +0100
Subject: [PATCH v6 24/24] scsi: ufs: mediatek: Add MT8196 compatible,
 update copyright
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260124-mt8196-ufs-v6-24-e7c005b60028@collabora.com>
References: <20260124-mt8196-ufs-v6-0-e7c005b60028@collabora.com>
In-Reply-To: <20260124-mt8196-ufs-v6-0-e7c005b60028@collabora.com>
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
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index dfa104207cc6..122bc741294d 100644
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
2.52.0

