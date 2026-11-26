Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795662624;
	b=HgqFt2J4Vd/WKzccGVahcnuhbXQl4N9G5d9i8TTsZArt5m61x2ADZKu89mXk6eutmYga
	 xhi1WAF+DeN8Xeh0TwQzyg6fCuxAYrO1apW9mgFOS4DPDZWraWzL3aRznfKpiI5zfF0QB
	 lZEToMlPE03rWpLQYMLFeZKJAPBahJ76ljk+zGs4/i6LWoYNdjBIfXuO9gkDi5j/66bie
	 rGQcd5NzM5go5mC17iFdGh6Mgsv75VcoWDfggqBzsWCJdHHrRjgtcgVw9cKuTJrBy83or
	 hw4x9FSUQrr1DDjksplRD/LrlfSqb2y9SB+E3jNnDuqjxFXGd2E6a3zuteYub7pMxnw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795662624;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-Id:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=1U1SzihIC60Wh5zi5DUA6SQRG4RcpzYL9izpFwzLS6Q=;
	b=yjRQk6o6qdXQSCFQZCfW5JSTlw0EWGSVEFrxvfFSZPlscQi407u1kRkjqnexexSmOmFl
	 n9fgbMlp1cuftNBZcdpSrpxAz1K6QDFhsWaOEBiSxu4sliZ4pUbIHXnBthVWlUEXzfgbN
	 DUl5U3pQFKnmNP4p3/OZDvhsWSXGgiOSvQwikfIKkjhe2uOJo0xPQvDtXDKqynoP1E+eP
	 T3mx04IAkCrI+8yyylSnonAzKz1KVFyoXjGE5hJTUK5Gmax009RBpw7ux8GBdkLqWXTWn
	 wDzSIu/LTDZafx2negUgh7kgTFyDuO1yMLHVwM2c6fLDdFaeW6H0jd81VvSGVK/SVCg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JuTAmrgA;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4015606A31E;
	Thu, 26 Nov 2026 03:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JuTAmrgA
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795662623;
	b=axNnO/pJ4Ebq6RMcnwbw6GpQn1TEIv6hO4jrSkOhe9Ci1PBeXGh8XpuLF9loSpQV50CY
	 Tqg/xdMoDwDTF7Sjwgm8o0ffUQSckHDLUTL+mKFevkjkeZM7Hxl6D2CGnXBDmZIxGczSl
	 CM8DRhKndKRl/Rs6LTyUlDf/EF1ZH47oZEJfIMEghMV12z9XXi/iEhBxRiFmusaybKj6X
	 VV2ydP9P0KKrRcZazKyb1x1yDAFvARHNVPpsMjDzvBDY95cvFMNEsxsPV5lfRe357QyaB
	 A3f4lkc15BLJewOwz6tzUbo8iMjEmxd515oZtzRcK5hL1NcVTt3s9G1d0z600VLJCHg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795662623;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-Id:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=1U1SzihIC60Wh5zi5DUA6SQRG4RcpzYL9izpFwzLS6Q=;
	b=u5mxauxKOXwLBZu7cXfaFjV57ULZWidoof6FAxa2PkVfWbTDDDZDsX6HR6LpCIWKUGzD
	 nqn5Nt1ob71KWgMgSua6dWbOJ/um4WUHr2J6ZcpJ5wmCoyK5bDlhSEgcvyoEG5L5j6zGN
	 Ni+sK1qqBmfSpjo1dNJ1EmrBJzkyxsv+nrsZC4roHrSaJZfyu7sraIbaM1JgPFkMY2myp
	 6BA1dNW2gq6i+Sbh6x0BWL3BOU0bwwI/CSIFHEK4ocqK0PYgZBZNJ1QzYBfiy78KlhfIU
	 aUQiMo/e7jsC4BxPSzqZnLmdG2IfKvdb9YOacjULl5tBVoOLlbWSEJsfl6ZbUsi74fw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 5EBC41F000E0;
	Thu, 26 Nov 2026 03:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795662623;
	bh=1U1SzihIC60Wh5zi5DUA6SQRG4RcpzYL9izpFwzLS6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To;
	b=JuTAmrgAg6g9+7n99r8T3f1LPgQ88u1EAWYutK2111/O8tvKTmHN6YZhSojxIHAv+
	 us3xE9NeuraD4ctgLatHhtbw0fpXiZms3VaJu0T+s0IMqRPg9GZxCPSi0kyza8iDko
	 Z48Nwd4tZXraaVVUmzchuLNC6gzGGfTEOyMMuTWpa1Cxqt/cxX1y3cdo+skH7S9u4V
	 ClTcX81ZzOAoecQGOdFILd1ZIIgi7iNeM31YrvaTURvSvD6x6YSXnHPovGmvb2Sw7W
	 Nfu5sYZzLPLox32q/xBNmzG+CU2+ma06STiDi1SDBv0Ilt/JNKy2MPc0yE+7EjSVyO
	 GkO7t5/s3AMjg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id DE26E4D1F4;
	Thu, 26 Nov 2026 03:10:09 +0000 (UTC)
From: Ilia Snezhkov via B4 Relay <devnull+iasnezhkov.gmail.com@kernel.org>
To: peter.wang@mediatek.com, stanley.chu@mediatek.com, 
 martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com
Cc: matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com, 
 louisalexis.eyraud@collabora.com, linux-scsi@vger.kernel.org, 
 linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] scsi: ufs: mediatek: round scalable clock bounds to
 clk_round_rate()
Date: Thu, 26 Nov 2026 03:10:11 +0000
Message-Id: <20261126031008.27506-4-iasnezhkov@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795662608; l=3051;
 i=iasnezhkov@gmail.com; s=mindone2026; h=from:subject:message-id;
 bh=MuIq1TvnjCaHK1YyQad7wOf3RnvQAYoWa7G/0M98I2c=;
 b=oH1rvPdfuZPM6eSf5SJfZh3FEeViLmw03zRzbmT1vwVo0mWByrcy5Fph1kijf2WqWDBGi97Kg
 7979edxEa4/DkIVBKl6GGF3N9wZ8kKBgwzeoTHJEtsX+Chccj7wmQbA
X-Developer-Key: i=iasnezhkov@gmail.com; a=ed25519;
 pk=hQgXfiWi4ukk2jh4BHu1vRVhg9BUivo//AFp50AKMag=
X-Endpoint-Received: by B4 Relay for iasnezhkov@gmail.com/mindone2026 with
 auth_id=1643
X-Original-From: Ilia Snezhkov <iasnezhkov@gmail.com>
Reply-To: iasnezhkov@gmail.com
Content-Transfer-Encoding: 7bit

From: Ilia Snezhkov <iasnezhkov@gmail.com>

ufshcd_devfreq_target() determines scale_up via an exact equality check
against clki->max_freq after rounding the target frequency. When a DT
freq-table-hz lists a nominal value that a PLL-derived clock cannot hit
exactly (for example, msdcpll_d2 on MT6789 delivers 191999939 Hz for a
192000000 Hz DT maximum), clk_round_rate() produces a rate that never
equals clki->max_freq, so devfreq scales down once and can never scale
back up.

Round clki->max_freq and clki->min_freq with clk_round_rate() in
ufs_mtk_init_clocks() for ufs_sel (and ufs_fde when present) before
ufshcd_devfreq_init() builds the OPP table from those bounds, keeping
clki->curr_freq synchronized with the rounded bound and skipping the
adjustment if rounding fails, overflows u32, or collapses min >= max.

Fixes: b7dbc686f60b ("scsi: ufs: ufs-mediatek: Support clk-scaling to optimize power consumption")
Signed-off-by: Ilia Snezhkov <iasnezhkov@gmail.com>
---
Changes since v1:
- Use IS_ERR_OR_NULL(clki->clk) and cast max_rounded to u64 before
  comparing against U32_MAX for 32-bit cleanliness.
- Found on hardware and drafted with an AI coding assistant.

 drivers/ufs/host/ufs-mediatek.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 09b7993..4de72ae 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -967,6 +967,37 @@ static u32 ufs_mtk_get_ufs_hci_version(struct ufs_hba *hba)
 	return hba->ufs_version;
 }
 
+static void ufs_mtk_round_clk_freq(struct ufs_hba *hba,
+				   struct ufs_clk_info *clki)
+{
+	long max_rounded, min_rounded;
+
+	if (IS_ERR_OR_NULL(clki->clk) || !clki->max_freq || !clki->min_freq)
+		return;
+
+	max_rounded = clk_round_rate(clki->clk, clki->max_freq);
+	min_rounded = clk_round_rate(clki->clk, clki->min_freq);
+	if (max_rounded <= 0 || min_rounded <= 0 ||
+	    min_rounded >= max_rounded || (u64)max_rounded > U32_MAX)
+		return;
+
+	if (max_rounded != clki->max_freq) {
+		dev_dbg(hba->dev, "%s: max_freq %u rounds to %ld\n",
+			clki->name, clki->max_freq, max_rounded);
+		if (clki->curr_freq == clki->max_freq)
+			clki->curr_freq = max_rounded;
+		clki->max_freq = max_rounded;
+	}
+
+	if (min_rounded != clki->min_freq) {
+		dev_dbg(hba->dev, "%s: min_freq %u rounds to %ld\n",
+			clki->name, clki->min_freq, min_rounded);
+		if (clki->curr_freq == clki->min_freq)
+			clki->curr_freq = min_rounded;
+		clki->min_freq = min_rounded;
+	}
+}
+
 /**
  * ufs_mtk_init_clocks - Init mtk driver private clocks
  *
@@ -1022,6 +1053,10 @@ static void ufs_mtk_init_clocks(struct ufs_hba *hba)
 		return;
 	}
 
+	ufs_mtk_round_clk_freq(hba, host->mclk.ufs_sel_clki);
+	if (host->mclk.ufs_fde_clki)
+		ufs_mtk_round_clk_freq(hba, host->mclk.ufs_fde_clki);
+
 	/*
 	 * Default get vcore if dts have these settings.
 	 * No matter clock scaling support or not. (may disable by customer)
-- 
2.54.0 (Apple Git-157)


