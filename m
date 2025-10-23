Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2C934E74A;
	Thu, 23 Oct 2025 19:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761249191; cv=pass; b=CkHH3Pd4ROt8/yfvHJoFpmeoGj6AP+CjXYRrjIbb86buB+lOebj4mhoEx59JzIfCIQe+kcZcY7y2wKJybX/Nze6ItSvpTeylvH4ryEr7/htnSpwNuJyJT5irZx9p3iYmKC4NBYzN4TTWZP/UWrqKdXnXwaAm5g+jX/icrMKO8PU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761249191; c=relaxed/simple;
	bh=o1TvjoihnRAbox+LWz+sl8f3Tnuapjv05AjOE7DYgwg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=e/waetuwDLHPjTKNL4trbNpwP7ZH2KojwixhRNjnXkml++F9rFeCmpsKeMv+UHCmlAUBidiAVbOAFhzJDVKnHx0TI6q477f1p3UZVedwhqL0eMFKI79TTTVdpiORIubGJ/jt6LnjcZG4hTfmG3+rWmay29c4M+hlmYtVx97fuyc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=WJRUPPwN; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="WJRUPPwN"
ARC-Seal: i=1; a=rsa-sha256; t=1761249162; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=VDR01vSCP6/d2x3JWBeIXcm/obWd21GdvcoOT1oDD3u1LpCOExNV2RVCtyjZzxEoer+JwQLN76ABjNzNKhrR24GbLeCYCFlt5DOuvdkhF49oeNHVETaUx0HODTPXHDYKb+/EVcxQB1BA32scoLtZMsWuex4ZkVppWyKcBQ9L9bk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1761249162; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=uqLnB78neSi6OXDSm/nO57Oj4cmBaz+P1PW4hSeUDCY=; 
	b=hJCURP6gO9NAdmEcVyWowbmXcSerqqJ0BKwBHOZFa0MIJ49OJdESThMh/j7c15csbkx17X89NDoiwZ2msC4vBkKPPSPLpUGFd3xhcvWpPZHS6CqqaEwrKGDLdmwVPV9b8fI1h8fnbiNkQNXkXwcLSs9BHHNGMMl8VrX9UEnhUyQ=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1761249162;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=uqLnB78neSi6OXDSm/nO57Oj4cmBaz+P1PW4hSeUDCY=;
	b=WJRUPPwNg+Itu0vdCkczL1rirjBcaDYTIy3Cr/Q3QDob5UYk6/nr8oj8kQDwmiPT
	EgJ3Dgu1BnJB5zGUc81d/NmVot3XscJpseC8nAb8v59Xs6o+yNmH9F54vdvn7JYycGa
	iObirYkGSTQ2KLTLTD85XuyGVQ3WkSiCX9yUza3o=
Received: by mx.zohomail.com with SMTPS id 1761249161979886.3318559681989;
	Thu, 23 Oct 2025 12:52:41 -0700 (PDT)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Thu, 23 Oct 2025 21:49:42 +0200
Subject: [PATCH v3 24/24] scsi: ufs: mediatek: Add MT8196 compatible,
 update copyright
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-mt8196-ufs-v3-24-0f04b4a795ff@collabora.com>
References: <20251023-mt8196-ufs-v3-0-0f04b4a795ff@collabora.com>
In-Reply-To: <20251023-mt8196-ufs-v3-0-0f04b4a795ff@collabora.com>
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
 Mark Brown <broonie@kernel.org>
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

Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 932d1fdfdc65..49ab92acf3db 100644
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
@@ -2202,10 +2204,15 @@ static const struct ufs_mtk_soc_data mt8183_data = {
 	.has_avdd09 = true,
 };
 
+static const struct ufs_mtk_soc_data mt8196_data = {
+	.has_avdd09 = true,
+};
+
 static const struct of_device_id ufs_mtk_of_match[] = {
 	{ .compatible = "mediatek,mt8183-ufshci", .data = &mt8183_data },
 	{ .compatible = "mediatek,mt8192-ufshci" },
 	{ .compatible = "mediatek,mt8195-ufshci" },
+	{ .compatible = "mediatek,mt8196-ufshci", .data = &mt8196_data },
 	{},
 };
 MODULE_DEVICE_TABLE(of, ufs_mtk_of_match);

-- 
2.51.1.dirty

