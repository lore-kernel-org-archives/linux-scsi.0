Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A484195B5;
	Thu, 30 Jul 2026 09:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785405033; cv=none; b=PdPJvFyonOSQtXK6uZvqiZVrkc/629VorlZ0hO2ULAH6S6JtQS2C3Dm+YFZ33T2GSfqgRNBBpe50o3jIOlkY4/bh3vJz9sB07rZnl2YReqBW/zrpBRVh7E7WkC5P1gkJaFzdQGIltr2z31rTVRlvUVje9W8hxoi3AjiWzOIoM5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785405033; c=relaxed/simple;
	bh=iOuM5MsCzqFgvCcI/Vxsc02Nc4c2nweSsknMPvd2D4Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ArmMKoujUGBEQbFiI1+zIJEXuZ2IIQV++/wsoXh2pqD9z54p7RD3gxfmhtFpXXVrMNDTZ29gIsyOIR14HX45pqRqPo73gi0clFo1vwYinPIYlmbL693I4vjT7kuT7jwyTmXmzwHvvGBc9hN+EwwCu33J6U/03I8+oxU4G+PE2Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=c5pvp92Y; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="c5pvp92Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1785405030;
	bh=iOuM5MsCzqFgvCcI/Vxsc02Nc4c2nweSsknMPvd2D4Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=c5pvp92Y5PZl9x0PRvCOneT/S31iAuVfDfxl/TpLHUEfx76LHldIfN48pehqdBIzS
	 kSkC7ZFFl15lJomJm9LvlUDfE5Ei33YteVP0t7UuTfRyLR7yVna8hUGBEknqb0fT2j
	 OzzJaVCH7Z84Ud5LtXy0OKlr0L64XAvnpkYyyZVD/9g3h0lXPqYZytbemrZY4+RMH2
	 Bc/l6Ta+vDgf7ruCP6i2bXBj8UJB4oeGo1i3+g9e0SMWwzQ3dRoxb/eSrpc+tZfZjm
	 fYYa49HxZ5b+LAJzhowgTwwwdB3VWYaGl1FxpwI4KdR0rN/FMEhMDsE4EZiUzMcM20
	 rFFqoZbLqGtlA==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 0DC6F17E097C;
	Thu, 30 Jul 2026 11:50:29 +0200 (CEST)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Date: Thu, 30 Jul 2026 11:49:19 +0200
Subject: [PATCH v10 23/26] scsi: ufs: mediatek: Add MT8196 compatible,
 update copyright
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-mt8196-ufs-v10-23-bc5ecef202dc@collabora.com>
References: <20260730-mt8196-ufs-v10-0-bc5ecef202dc@collabora.com>
In-Reply-To: <20260730-mt8196-ufs-v10-0-bc5ecef202dc@collabora.com>
To: Chunfeng Yun <chunfeng.yun@mediatek.com>, Vinod Koul <vkoul@kernel.org>, 
 Neil Armstrong <neil.armstrong@linaro.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Peter Wang <peter.wang@mediatek.com>, 
 Chaotian Jing <chaotian.jing@mediatek.com>, 
 Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>, 
 Stanley Jhu <chu.stanley@gmail.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Philipp Zabel <p.zabel@pengutronix.de>, Liam Girdwood <lgirdwood@gmail.com>, 
 Mark Brown <broonie@kernel.org>
Cc: kernel@collabora.com, linux-arm-kernel@lists.infradead.org, 
 linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-scsi@vger.kernel.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>, 
 Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785404993; l=2453;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=0mXF3Fm43959ggl9oBxp2JhbanrvhYp5Kezx6g7GKK0=;
 b=WyYVRy9NAh7Ww+98BTaB4xOs52PWBIoI7Pmsh1vKgCpFIcgnDaj1TWL8yj2COaX9kntFLckVI
 3Nhkldytvv1CiyQVCv2zciWTI3voGTcRxIO0UzYyGUoIcgSds8jYL58
X-Developer-Key: i=louisalexis.eyraud@collabora.com; a=ed25519;
 pk=CHFBDB2Kqh4EHc6JIqFn69GhxJJAzc0Zr4e8QxtumuM=

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

THe MT8196's UFS controller has a new compatible. Add the necessary
struct definitions to support it.

Also update the copyrights and authors, without tabs following spaces to
avoid checkpatch errors, to list myself as having contributed to this
driver after the preceding rework patches.

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 5dd72b826181..decf2f5814b4 100644
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
@@ -2222,6 +2224,10 @@ static const char *const ufs_mtk_regs_avdd12_ckbuf_avdd18[] = {
 	"avdd12", "avdd12-ckbuf", "avdd18"
 };
 
+static const char *const ufs_mtk_regs_avdd12_ckbuf[] = {
+	"avdd12", "avdd12-ckbuf"
+};
+
 static const struct ufs_mtk_soc_data mt8183_data = {
 	.has_avdd09 = true,
 	.reg_names = ufs_mtk_regs_avdd12_avdd18,
@@ -2234,10 +2240,17 @@ static const struct ufs_mtk_soc_data mt8192_8195_data = {
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
2.55.0

