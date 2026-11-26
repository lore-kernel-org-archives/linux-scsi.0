Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795654426;
	b=ZjJaqcVf2kYYqJ58IyqxN+lZa24bCO1L+WH3cUCDCiZ6BwhgigSaJzR1WbQTOcDUURZf
	 blRoRFsHu1ARFnQ+WlL2tMAAL8Stt2Zt/DGQphaFymAN/TMUwHJ2OCXhWUPl25oM4bLDf
	 sndjNds+Fq88cxEZtWrYRAPULX2hUwi8zcvda0i2jjnNtctOHTmS2bvBCaUfZ3KBVd3p0
	 UJMU7BLRsyLhpckUCBVTtIefcwemlcJJHnxWq4qasnsuCIbZyMNVeLdigxlvSR+tazqU1
	 5Q7EBoXKxnC/+XiuWswNUNItYPGq63gdsAb4mSGKXouECScIiCoAU3AGyzsyZ+sybCw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795654426;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-Id:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=mbwR7pFzsMlSflXFj+MFOyV2kETMAX7EmTdAVrfOIZQ=;
	b=ujiNasjieIgfen9+DCX/3xyUjuZ4LS61yAWrqI6lzxlFjjHMNltQbYb7sYDu830rM2O0
	 4P1f6wggWlD8rcpAXFHTSm4PTrSw4f4Fp6IZk3ScC7uaGq5DABbC7mUH7q89Slg7zSgJE
	 jPpPrkuWYXkXpBAGTGSp/hgmeg26Q72ynG9iFt76m/YRq+YEFJU87c8RWIvyunN6KRIw4
	 JEvgpGpLyIkkk3+tWFxH4OEA1jCSJzZK3Uo7ZpfAJii104mRbhoBthD8Vr0ChJ2yH4nFB
	 ioS/3fMOAMk89wU5sO+965muUt8HrgXNNc5LkfV/0D/Mf8LNjWqbTVi6dX9d8X1Qcbg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YPFYTn0j;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84CD3606A330;
	Thu, 26 Nov 2026 00:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YPFYTn0j
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795654426;
	b=gW6ewdjPWO05WYQoBEVQoO06SwChh69WFslXGpcFzkXqEvHgdUG/Qw2vAhm9qw6eNghP
	 3v0l4+Q1YTDsXO96UeFU8RPrAW9LrZRNdBQV4xSpWZa3ACM16vnIrhBBVVxaJAzp5wX9f
	 JxzD93ut0c/SOL0Ra+5/bp0aH6IQqK0af/ZdZaBGiV2W718CUD+tci3EO/KhScFdLvPFS
	 id3s5BsilMVTEeWno+gyEvqXcnVIO5+mwSwxQkM9OyJRb/hyY9fntD1TJWONHV7RSeDEU
	 7HWDbOk3BlgI6/E7qP4K7/50YQuQvTKL9o/XQ/3HKKGYAVF9lLp26MVIfsZ+djek2SA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795654426;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-Id:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=mbwR7pFzsMlSflXFj+MFOyV2kETMAX7EmTdAVrfOIZQ=;
	b=MXh1XIf4VUqYZC6DczfzGiaHzzs6OWWIT9HqqZM2kwgZa17tKN1v7kT/XuegX7as5VIk
	 HxFWu7UYz7DdPZ0XBohUgq8z/yfkKcG1+py823oZ6gU51OB/GeSpD1vjaHNWqGJx9YmwA
	 Rqwkxjr7rXW6a5XB+PGtdgK3EPs033cYmVvIWUKxU2aRt0PhKWjcFr7pUdu8zah8/0b2+
	 Pqt6IXV8ewHOMSjsMxKnkW80j5YzwuURZGqZUJGMqLXLWsqK6UG177ORCRLHGaNsH3BLA
	 d/2VcGt3i3TMykCf4wxpIk1g1y1mfLDyZvx574kWN1BozBGqtG2erucwHOjbM/xAM9A==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 5FFBC1F000C0;
	Thu, 26 Nov 2026 00:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795654426;
	bh=mbwR7pFzsMlSflXFj+MFOyV2kETMAX7EmTdAVrfOIZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To;
	b=YPFYTn0jPliDqbozyY1dPcK8k7HSbiMguwiBCG52VaK3sDwOnkd+cFt+//fDalChK
	 cNIk0LvE1z73CxO50Xi2aBe6hKRVDnMALFJVD8Kr+hGOxKuIBvHt3AMEG0vLxrzhmn
	 2Vu5t4tL8in+EM7cpuQ/ILt5zMI6E8tOPRYygqkHVXk0oyYjJ/j86g0fA/1aCLSzZl
	 wQPv4Ryc27lrlSlVhCkEyQhILDQgw+FkhAN1TwLIFi1WMpUleT0ggRUAaCBGMhm/eB
	 VLKQWLkUx2J8xg0qJ3V0/dbVErO53RlEXIa1+Mm8Wmj6E4YsPbXe6gJcVP0NomfcU9
	 9pouB/CfxJCJA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id A89784D15B;
	Thu, 26 Nov 2026 00:53:30 +0000 (UTC)
From: Ilia Snezhkov via B4 Relay <devnull+iasnezhkov.gmail.com@kernel.org>
To: peter.wang@mediatek.com, stanley.chu@mediatek.com, 
 martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com
Cc: matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com, 
 louisalexis.eyraud@collabora.com, linux-scsi@vger.kernel.org, 
 linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] scsi: ufs: mediatek: allow clock scaling when ufs_fde
 is absent
Date: Thu, 26 Nov 2026 00:53:31 +0000
Message-Id: <20261126005329.72010-3-iasnezhkov@gmail.com>
In-Reply-To: <20261126005329.72010-1-iasnezhkov@gmail.com>
References: <20261126005329.72010-1-iasnezhkov@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795654409; l=1626;
 i=iasnezhkov@gmail.com; s=mindone2026; h=from:subject:message-id;
 bh=8OS3QXdomVEfbjWk/ztdyTyuzUidpcMVUWrDaQs9DOU=;
 b=2Pi9eTfJLrBrCMBMGVAB7PZAVFxl78WCWdOWzMEBS0E4kVAKG1/ryG4svfqrjRMoWs2zeIRja
 C5lVPSHgrS7B8e9gudrXs5xjXY6ssrC2H7oT2fsR5v3TigDwRZnsjcF
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

Found on hardware and drafted with an AI coding assistant.

Fixes: 5e5976f5242d ("scsi: ufs: host: mediatek: Support FDE (AES) clock scaling")
Signed-off-by: Ilia Snezhkov <iasnezhkov@gmail.com>
---
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



