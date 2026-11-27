Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.251.105.195
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795795256;
	b=NA2C/MGFo51GY2cCYpJYVq3o+PGfUf+jEHt8Y37YYhhaHJjKA84StpaB+sGDp5wRsTIp
	 oweMOjNP6mGKzfhEIOkuF1mYVxbgEq+D765/O4dFLaylBh3HlU3NTvWetyUUvgS65kkRr
	 UxIPBMAwh43RMnlzd8d1NndWI+6L0ANK5OjwWsX9rEgN9GB2NNctq1h1kOFG5SBQhMBLq
	 5X59P242ryC1Yhg3a2cTsUUDzjWHSs/t8eyCJKBJvH4eHclfQn4MzzjCJip/dnRdfq8sk
	 sSrpTvXAj5SxvLZ5hr0BKCKQhREiYOqRaH5wUIWCOiiyAw6jl+A2csix6tGWYT7FEcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795795256;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=gE3yKnlohnWoJO9J2ZC7iGcbBKT8ggwgyLdq3uH8Caw=;
	b=niC71+BlQPbN2lmZvOT37rYAaRG36Nl34tgr4HRuZuqq+mUKQKwYolEBWGYEG83L0OwT
	 IGAwiecezAWcPlzdi9n9f1rTcUH9kTd7l76AeZBJj8HuTbgId1X5iROwl3NKwEdM+RJbX
	 mQOHtxm2Y9V3maxxLkobomXjzL7E+EkbARm3HBKWf1fhM+538XC4h6phWI6JELWu3CF9g
	 SL5FXpjdy1e2aqe30ckHLoq647F7yFeWMtUlX+uzMWjiassp/n3f5eHx5XDZIIrQTph9r
	 mOgmc4iPZGK+gQuJDMGdJ/nFmvGI/yv+Y9YaQNwW9+wG4SSebxd74ypJUKBGkYdVZjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=collabora.com;
	spf=pass smtp.mailfrom=collabora.com;
	dkim=pass header.d=collabora.com header.i=@collabora.com header.a=rsa-sha256 header.s=mail header.b=VTHSAgER;
	arc=none smtp.remote-ip=148.251.105.195
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622B0606C21D;
	Fri, 27 Nov 2026 16:00:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 622B0606C21D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.a=rsa-sha256 header.s=mail header.b=VTHSAgER
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1795795254;
	bh=yHEPc9SkCperUq2H+yblKT0WinHaz9Qyg0VM8DkDmis=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=VTHSAgERASeLFCgp5nF6VY2s5zsL6XOXkKYsnE/SwYBoVw7nDVrEZnQnTWB6IOxe+
	 0HBMVtqhywvqMNvA2ZUv08QA0mA0JijLe7ww3R/w3qGaLQ1h/L9qcy1RSaEMcr4vmK
	 XCfutEd21UcstmF1iG8nscrZ5o8fNqpzcbZUgo5+JQy1+6pN/t/siJNpxBz809Sjfe
	 Bhk4+IcrUEC5yxqSYgp3ihs5kBIZ5uhUYJeNO3H0m2S+bxML32sQdwQ69W9H1Jg3U/
	 tK3XsxB3BJevc1EOsrAqo92IBhkeYcn4tqsb/cBmNQZSqXHltK7cphHayjTeSzVmhO
	 UCpW4JlkwB3BA==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id B658417E0E37;
	Fri, 27 Nov 2026 17:00:53 +0100 (CET)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Date: Fri, 27 Nov 2026 17:00:26 +0100
Subject: [PATCH v16 23/23] scsi: ufs: mediatek: Add MT8196 compatible,
 update copyright
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
Content-Transfer-Encoding: 7bit
Message-Id: <20261127-mt8196-ufs-v16-23-6f2568f7c119@collabora.com>
References: <20261127-mt8196-ufs-v16-0-6f2568f7c119@collabora.com>
In-Reply-To: <20261127-mt8196-ufs-v16-0-6f2568f7c119@collabora.com>
To: Chunfeng Yun <chunfeng.yun@mediatek.com>, Vinod Koul <vkoul@kernel.org>, 
 Neil Armstrong <neil.armstrong@linaro.org>, 
 Manivannan Sadhasivam <mani@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Peter Wang <peter.wang@mediatek.com>, 
 Chaotian Jing <chaotian.jing@mediatek.com>, 
 Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
 Bean Huo <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>, 
 Stanley Jhu <chu.stanley@gmail.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Philipp Zabel <p.zabel@pengutronix.de>, Liam Girdwood <lgirdwood@gmail.com>, 
 Mark Brown <broonie@kernel.org>, Chun-Hung Wu <chun-hung.wu@mediatek.com>
Cc: kernel@collabora.com, linux-arm-kernel@lists.infradead.org, 
 linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-scsi@vger.kernel.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>, 
 Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795795222; l=2479;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=ng8074+Xw5koEENCrcN0XOyaB5QdfK4doK2YMnCe4lE=;
 b=KVukKp/RT+P7D5ALPKGHtOnnnFJHPcg8DqXicg37NF+bsKZkNJmKoATzH9pgN58tbLFQ0M1rg
 oLtIFhpvK8fC1inKEz0DikAAHFsxuFiNDYPZrjjGrOKqXDHOEDhgUyt
X-Developer-Key: i=louisalexis.eyraud@collabora.com; a=ed25519;
 pk=CHFBDB2Kqh4EHc6JIqFn69GhxJJAzc0Zr4e8QxtumuM=

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

The MT8196's UFS controller has a new compatible. Add the necessary
struct definitions to support it.

Also update the copyrights and authors, without tabs following spaces to
avoid checkpatch errors, to list myself as having contributed to this
driver after the preceding rework patches.

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index a16c67559712..a9bbb89cfad5 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1,9 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2019 MediaTek Inc.
+ * Copyright (C) 2026 Collabora Ltd.
  * Authors:
- *	Stanley Chu <stanley.chu@mediatek.com>
- *	Peter Wang <peter.wang@mediatek.com>
+ *      Stanley Chu <stanley.chu@mediatek.com>
+ *      Peter Wang <peter.wang@mediatek.com>
+ *      Nicolas Frattaroli <nicolas.frattaroli@collabora.com> (Major cleanups)
  */
 
 #include <linux/arm-smccc.h>
@@ -2291,6 +2293,10 @@ static const char *const ufs_mtk_regs_avdd12_ckbuf_avdd18[] = {
 	"avdd12", "avdd12-ckbuf", "avdd18"
 };
 
+static const char *const ufs_mtk_regs_avdd12_ckbuf[] = {
+	"avdd12", "avdd12-ckbuf"
+};
+
 static const struct ufs_mtk_soc_data mt8183_data = {
 	.has_avdd09 = true,
 	.reg_names = ufs_mtk_regs_avdd12_avdd18,
@@ -2303,10 +2309,18 @@ static const struct ufs_mtk_soc_data mt8192_8195_data = {
 	.num_reg_names = ARRAY_SIZE(ufs_mtk_regs_avdd12_ckbuf_avdd18),
 };
 
+static const struct ufs_mtk_soc_data mt8196_data = {
+	.has_avdd09 = true,
+	.has_avdd09_1 = true,
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
2.56.1

