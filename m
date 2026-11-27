Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.251.105.195
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795795246;
	b=wop+x58AuUB+6pJ3t3+P46N6jslJVSC9EKphLWxF/U1ECPuB4xW2zOKZcbw5ygVbZqJ5
	 8o3ssqj8m+RfCg64RP4zqDojm26z18aILJNbzxEnnHdGbAcnmjWA7l8mA+PmEJBc4iw85
	 mmYVtN6lDimyzZcBw9KB/15z1Ixo1ZEu87eIdgsCG3FK3ffA/hb7fSqlkYtcTmuYoQc+T
	 7Wf6SlALS9To9AG4OnZFQ50RlnDIhnZ08+7qUHqc8lOPgDKm+Z1ZkZBW1jsKnzkKA8CjC
	 +82a0KwYV+z8AWIQN7aCu1NZy//Xdn6JPyW4lk5dYOwmOp6k8XulMGviFLPDts2q7xA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795795246;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=Jxk7iJE8E1AxQjR0uJHBhP7rMxXPsQ3mUJITfPmBWBc=;
	b=OJ1QzQMJAxUp0VTAxgaHZzg3P8zDRTmTWE6xytqOAHMwDtp3Bgl5l+78CE92nzBt9em4
	 vs+DowGuZy74kN0hY+gH80MHrmwzZ4fCzy8Q978UvaiCXacL3w6ZfIV/zub6ZhPST7Mr9
	 H7odJQYmdIYA+yb2pprLlqDeIkAhcNmZ6Pdcw6Rlx6IVyCJ5Ut9nYK1ktQPcfqDlLJL2d
	 yUi/8m+Dh1bcyf3NjDGTlytPWIcB4YB0BjsT7gLJSYoOpXRNSLipTiZ7MQEJ18O/8zaSp
	 UqelWOzCUMhaweC8NTIDrnk4nETFmHCJa+6SQO3aJ4zhNJL46flmpCoTU0On92ZZnoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=collabora.com;
	spf=pass smtp.mailfrom=collabora.com;
	dkim=pass header.d=collabora.com header.i=@collabora.com header.a=rsa-sha256 header.s=mail header.b=ZOLJyP2Z;
	arc=none smtp.remote-ip=148.251.105.195
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D58A60A5BE2;
	Fri, 27 Nov 2026 16:00:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8D58A60A5BE2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.a=rsa-sha256 header.s=mail header.b=ZOLJyP2Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1795795244;
	bh=EZhDsGt1k5I5MgQx0B894Tks60yZ+dIg+vY9qxs2PaA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ZOLJyP2ZJEgdc5E5NM2H+4RmHluxUqsszEhdMrV3qtbdVypqRSZ6v13z7BJP5mtSm
	 cn8IEM8hKO2R+YyhHw2CCinUQEbiLNdJ7bEV2vQIVQ73vj06ddrJTw/QeFS4Q2QXP0
	 G9YTV1yz6MVdyvst8EYKylpOfhq/pUQBbsp9TD/1mnqFBc3PMg8lV58LJMg9I4HTtK
	 +/otUC9Ojx0vBHXOO3IuOdxDI/CRTngogYDTG8L8sSo/u3kwzCIjzzxCftbL/DdtoH
	 8bKEnPg60walK/G8+c3FuJtR3A1UEwGQrLGmAXtN9ffn+KOYu+SWe2LGAFEzZuNr9N
	 kHtlgkU0kCyhw==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id CFC1217E07FF;
	Fri, 27 Nov 2026 17:00:42 +0100 (CET)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Date: Fri, 27 Nov 2026 17:00:18 +0100
Subject: [PATCH v16 15/23] scsi: ufs: mediatek: Remove
 mediatek,ufs-broken-rtc property
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
Message-Id: <20261127-mt8196-ufs-v16-15-6f2568f7c119@collabora.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795795222; l=2134;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=9CTlg8xAILY9iqdRThOl7TUwtadPYUSw9hy9H1UkyUY=;
 b=Tro7JCP9JrSZ0Wuou2rANW0vluL6Awbe7BVTipDTXyORFqplRRejZ9bwn9xyepIhs3NJfnr0D
 8TSXSzHe+V/ANu+Gv9QZ3VuV5qdxxueMHqMizxYMsdMbQg/xB8E66Om
X-Developer-Key: i=louisalexis.eyraud@collabora.com; a=ed25519;
 pk=CHFBDB2Kqh4EHc6JIqFn69GhxJJAzc0Zr4e8QxtumuM=

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

This flag property was never described in the binding, and its
capability wrapper seems pointless.

If one of the MediaTek SoCs needs the ufshcd quirk applied, then this
can be done per-compatible, without needing to give the device tree
author the option to forget to set it.

Remove it and the associated capability flag wrapping code.

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 5 -----
 drivers/ufs/host/ufs-mediatek.h | 2 --
 2 files changed, 7 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 9d7e4bc96203..8fa0bd4442ac 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -712,9 +712,6 @@ static void ufs_mtk_init_host_caps(struct ufs_hba *hba)
 	if (of_property_read_bool(np, "mediatek,ufs-rtff-mtcmos"))
 		host->caps |= UFS_MTK_CAP_RTFF_MTCMOS;
 
-	if (of_property_read_bool(np, "mediatek,ufs-broken-rtc"))
-		host->caps |= UFS_MTK_CAP_MCQ_BROKEN_RTC;
-
 	dev_info(hba->dev, "caps: 0x%x", host->caps);
 }
 
@@ -1255,8 +1252,6 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 	hba->quirks |= UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL;
 
 	hba->quirks |= UFSHCD_QUIRK_MCQ_BROKEN_INTR;
-	if (host->caps & UFS_MTK_CAP_MCQ_BROKEN_RTC)
-		hba->quirks |= UFSHCD_QUIRK_MCQ_BROKEN_RTC;
 
 	hba->vps->wb_flush_threshold = UFS_WB_BUF_REMAIN_PERCENT(80);
 
diff --git a/drivers/ufs/host/ufs-mediatek.h b/drivers/ufs/host/ufs-mediatek.h
index bde2b53f5798..d97951ee1f4e 100644
--- a/drivers/ufs/host/ufs-mediatek.h
+++ b/drivers/ufs/host/ufs-mediatek.h
@@ -138,8 +138,6 @@ enum ufs_mtk_host_caps {
 	UFS_MTK_CAP_DISABLE_MCQ                = 1 << 8,
 	/* Control MTCMOS with RTFF */
 	UFS_MTK_CAP_RTFF_MTCMOS                = 1 << 9,
-
-	UFS_MTK_CAP_MCQ_BROKEN_RTC             = 1 << 10,
 };
 
 struct ufs_mtk_crypt_cfg {

-- 
2.56.1

