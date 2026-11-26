Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795662626;
	b=3AvUFY4J2CB/DcnxVwiDnzgSh01HRVfm+bn24ws0dj3JiqOB4egKCB3GMEfdaiUiw3QW
	 SVhjN7DbOmh12L61dZaPNwRrZho3hmtSkQbX8rZht8VZ1kw1Os4RG/3FWi62YG8+6jRIo
	 ZCyzNykBVmkGc40hCqTPrhBXVCAgccU4ehMWl2iJjEM7xE5v/wHFHTlkxE8d9tCDeYH9S
	 HrYOifePnPMyoc1AJsDtOgIrQILh5PdGBIQHKSKTJxsByu7UQ8IlDeG4zp4RrjXnN+5O3
	 pcLRO7dtM9KhTzYXK/wFnWUiwVeLKyII9thoUtABb4hkLJt4AdlyLRgmVSr63qqD6ew==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795662626;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-Id:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=4lG89XlZpENs4zeOK9AgQPwgrP8/MDI8XqvYIIzJlLQ=;
	b=dRhMdKJBp//WA7ER14+PA8lArI+pTitE+HtUf1GJcjmQpEDCY4aDpGnHCNNXJ2odhfgb
	 bvyc/O5ZTp9GpoS+uc1iHy2WoDIgw5m3x0N4o1IOVKN/apXw0k54Ja3SdtV0O2WQqTdCn
	 Nyjm13ma/03tvuV7oT07nDR9RO2i2z96sB5S6v3WiwgSDJ5kGBHe8IqJxwA4W9AaRhx7z
	 o1sT++QIcJfgVw4aAb4+meoFnCq0qdczrDv8wYussXKJrKUHPuWvp+BldgJvc9oMETgd3
	 Gmq+/Xxxcl9pCtD5xmBwmPtX2n6JSg731QyQ9YRMLfmcYbCrvgLEn28M0NueoAo8rQw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CFlj7F9h;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526EC606A32E;
	Thu, 26 Nov 2026 03:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CFlj7F9h
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795662625;
	b=ruMEuNhGqaYyJWXuJrOcvzOvoyoe11W+FqlzyHPsaNlF27ntRT77L8B1y6QQGNTgP0Qy
	 MPyEm/cvKRtwpfbpCWKfqVnuBr+7F7fXNucd4J8wH3/BzOgBaTpHAy4epNSUprfYJQdX4
	 f5R4NrnGBczZ/8z0f21cBGPKDCIXpbFz1mDAVupfI1zKbLw+lGqpl3+LphSVDHLaOOmo/
	 FbcTYkWQKJp/HnmhnkHx905qc6ND7qryYZzs1ong/fTqJcCZcuObzdv907CLVn1MCx79l
	 VENUW2/cZh0LkTf5+31nPwYktJZZ1C9zOWgUkY/mXuu1CdyUC3Bfx40WV+lKxXxw9uw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795662625;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-Id:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=4lG89XlZpENs4zeOK9AgQPwgrP8/MDI8XqvYIIzJlLQ=;
	b=tdv6I+xMBwMoRb/RQLgntPs5aJLIXwLqdVDFHkUYtBtRCoBVXb6STYPgo5lwafRglVzy
	 HGbc2TPW9QnAM2bYWJlKHojgm4aIUpspLVqGqDeZDSz5l5p/7bu9C637B99zamBNDWc4Q
	 Gof8hRGDxmU/KCMcroke6cpiTSvmDIjkDZf/U9PovpkW86ljjd09tqAb0rVbQECki3uMT
	 NwmlWDpq1tgwMgaUyJDyIalVN+jqGEUp0V1UQ47XKDkQm8efLSGlm9IlDay6V2loVUxdk
	 LaD9KN95qnwGyY0pZTrelVsGigL+Vw+arSQI7KBWh3rZ248PEoadyWzgIIzUHnUkBQQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 5BF961F000D8;
	Thu, 26 Nov 2026 03:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795662625;
	bh=4lG89XlZpENs4zeOK9AgQPwgrP8/MDI8XqvYIIzJlLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To;
	b=CFlj7F9hoQIW2QayZZ0MLnnUVKbHhRDLOdrsXmkpgB3T6jRLnUeIFa6dfx3DLC5xN
	 QDgk0AayYAGuCaXV9BFLA+ulzGKx4998cuhLs5mFugjzIGqsEYGCcgQTMJ2Yqeg+ae
	 E744hp4ndLnBlVkTKP74/u/0voDTA6RRGSx3ff5pZBp1hBEhy/QUVO6uIB2YUkonzY
	 JRa26t+nDvFR11s6+PfymfdVGFoYhhQnYJynBCChhMrF5IRhsA2Hfg+mBqg3ytgZNM
	 5D2wVtt1QRJ/JM1U03F8DXbT/ginHE5MsopD9wM4vqG8Z0trZLmQh2pCqWIEFaQiXJ
	 HRgJcE0D5KQhg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id BE8194D1F0;
	Thu, 26 Nov 2026 03:10:09 +0000 (UTC)
From: Ilia Snezhkov via B4 Relay <devnull+iasnezhkov.gmail.com@kernel.org>
To: peter.wang@mediatek.com, stanley.chu@mediatek.com, 
 martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com
Cc: matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com, 
 louisalexis.eyraud@collabora.com, linux-scsi@vger.kernel.org, 
 linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] scsi: ufs: mediatek: allow clock scaling when
 ufs_fde is absent
Date: Thu, 26 Nov 2026 03:10:10 +0000
Message-Id: <20261126031008.27506-3-iasnezhkov@gmail.com>
In-Reply-To: <20261126031008.27506-1-iasnezhkov@gmail.com>
References: <20261126031008.27506-1-iasnezhkov@gmail.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795662608; l=1692;
 i=iasnezhkov@gmail.com; s=mindone2026; h=from:subject:message-id;
 bh=JrSCC6bqmjDSayjLVPuM/lqnbwzNiJ316tX4mC55cw0=;
 b=WlJ6RSWIlNpmwPCJm9rOCp74Wf4sAwQyre/FuX8xHvV2Wb1+gnofB6HT01qI3BxFab/QSk/hk
 T5xVyGu9vKxASqXffTcrtdDdaR1GyjXEyN/3ew8a14trS8Y3MznGiAW
X-Developer-Key: i=iasnezhkov@gmail.com; a=ed25519;
 pk=hQgXfiWi4ukk2jh4BHu1vRVhg9BUivo//AFp50AKMag=
X-Endpoint-Received: by B4 Relay for iasnezhkov@gmail.com/mindone2026 with
 auth_id=1643
X-Original-From: Ilia Snezhkov <iasnezhkov@gmail.com>
Reply-To: iasnezhkov@gmail.com
Content-Transfer-Encoding: 7bit

From: Ilia Snezhkov <iasnezhkov@gmail.com>

ufs_mtk_is_clk_scale_ready() enables UFSHCD_CAP_CLK_SCALING whenever
ufs_sel, ufs_sel_max_src, and ufs_sel_min_src are present, treating the
FDE (AES) clock as optional. However, _ufs_mtk_clk_scale() bails out
early on !fde_clki, so on SoCs without a ufs_fde clock (such as MT6789)
ufshcd believes scaling succeeded and updates clki->curr_freq while the
ufs_sel mux never switches parents.

Only require clki (ufs_sel) in _ufs_mtk_clk_scale(), and gate
clk_fde_scale on fde_clki being non-NULL alongside its min/max parents.

Fixes: 5e5976f5242d ("scsi: ufs: host: mediatek: Support FDE (AES) clock scaling")
Signed-off-by: Ilia Snezhkov <iasnezhkov@gmail.com>
---
Changes since v1:
- Moved AI coding assistant note below ---.
- Found on hardware and drafted with an AI coding assistant.

 drivers/ufs/host/ufs-mediatek.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 38d05ac..09b7993 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -2059,7 +2059,7 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up)
 	if (!hba->clk_scaling.is_initialized)
 		return;
 
-	if (!clki || !fde_clki)
+	if (!clki)
 		return;
 
 	reg = host->mclk.reg_vcore;
@@ -2067,7 +2067,7 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up)
 	if (reg && volt != 0)
 		clk_bind_vcore = true;
 
-	if (mclk->ufs_fde_max_clki && mclk->ufs_fde_min_clki)
+	if (fde_clki && mclk->ufs_fde_max_clki && mclk->ufs_fde_min_clki)
 		clk_fde_scale = true;
 
 	ret = clk_prepare_enable(clki->clk);
-- 
2.54.0 (Apple Git-157)


