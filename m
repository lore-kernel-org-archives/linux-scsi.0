Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2313E49C227;
	Thu,  8 Jan 2026 10:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767869528; cv=pass; b=gsie7+lpkooe7AUF0WFHBR+ui0WX6T58L109E8xHFdC2C7P1se3iI5yZYQO4HLL2TXuI/PJWMEDn94jvJ9uPzyC3hz0kGYjTsgRJr7d6cA0VlIawK6KNpBNXD4LliNaguFKMyZPTmC8UB05qa5Mb+gd1Sqv71SoOm21pMowrPZU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767869528; c=relaxed/simple;
	bh=cHE1xwnUUAd8zCMwGUiQF2E5DMP6WCsn2qRVe3K9hiA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FbN4Y5ij5Ga5vcQ4CHdiZEhizV4TQg06f3cEjTPpWzZ4oh4AguGhz1knRG16CXAN9L8vMrxNhXoPW0/FrozVFSq+O/wqjFxc1aLUIZnDV6CE9k9nwaUokWpFxnsbooZyJfoyNLblAD9jIooWFJN/C5ZoHGFuEarMV29Cc5NFIUU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=ECkDbJJW; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="ECkDbJJW"
ARC-Seal: i=1; a=rsa-sha256; t=1767869487; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=QDXPtw3rPiPWIHc9kLwJxjugFAKrnvXvPgr2AnLCUvar8InqE5gR8DoDEGayYtdNl1gX8bU9weULoa88t0RUW+Uiy8guEj1h3WtTMrxbghIjFto0h3zGT+rJ4P4LRuO9Fu9kAhvsIAeEXrHXTt64zhOfVGgsVIfgER+c9ZoQn5U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1767869487; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=4rMHsJjiUV86PAj6jvywgEhs1dLS6nmBWhNCaoGf/Rw=; 
	b=It4X1hfSIhnlb3wLPsMxo7FA/C7q0hfY0Z5wIeFtWQis1BLpgZRqEcvRcXTRKPxngb9cNzDRnqADEdk4dNkUeRRmsMSmAJwm0UL2OnlqyG7mmIlx/T3dT3OhCjkSRqvTLrANP6ABINusfwryPzAcOh587IrsP5vsLuZ8FyrwXyU=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1767869487;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=4rMHsJjiUV86PAj6jvywgEhs1dLS6nmBWhNCaoGf/Rw=;
	b=ECkDbJJWmvPzxcQ0Ux7cPXNmwWFDQhWmsq/lI3TCzxvzLMVEj6R9h0TUQDiHmEa0
	BtqRtsaPw1nyZH2C8yzu25IeEvH15RUuezraKQJll+pBrUWNqfBdyNtXycvJHbmfoBF
	0myuQmLdhpOOuKJTWGy2KIdALmNDv/YFEIq579fs=
Received: by mx.zohomail.com with SMTPS id 1767869485778694.0441057375441;
	Thu, 8 Jan 2026 02:51:25 -0800 (PST)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Thu, 08 Jan 2026 11:49:34 +0100
Subject: [PATCH v5 15/24] scsi: ufs: mediatek: Remove
 mediatek,ufs-broken-rtc property
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260108-mt8196-ufs-v5-15-49215157ec41@collabora.com>
References: <20260108-mt8196-ufs-v5-0-49215157ec41@collabora.com>
In-Reply-To: <20260108-mt8196-ufs-v5-0-49215157ec41@collabora.com>
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

This flag property was never described in the binding, and its
capability wrapper seems pointless.

If one of the MediaTek SoCs needs the ufshcd quirk applied, then this
can be done per-compatible, without needing to give the device tree
author the option to forget to set it.

Remove it and the associated capability flag wrapping code.

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 5 -----
 drivers/ufs/host/ufs-mediatek.h | 2 --
 2 files changed, 7 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 230e11533eac..424533538b90 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -655,9 +655,6 @@ static void ufs_mtk_init_host_caps(struct ufs_hba *hba)
 	if (of_property_read_bool(np, "mediatek,ufs-rtff-mtcmos"))
 		host->caps |= UFS_MTK_CAP_RTFF_MTCMOS;
 
-	if (of_property_read_bool(np, "mediatek,ufs-broken-rtc"))
-		host->caps |= UFS_MTK_CAP_MCQ_BROKEN_RTC;
-
 	dev_info(hba->dev, "caps: 0x%x", host->caps);
 }
 
@@ -1185,8 +1182,6 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 	hba->quirks |= UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL;
 
 	hba->quirks |= UFSHCD_QUIRK_MCQ_BROKEN_INTR;
-	if (host->caps & UFS_MTK_CAP_MCQ_BROKEN_RTC)
-		hba->quirks |= UFSHCD_QUIRK_MCQ_BROKEN_RTC;
 
 	hba->vps->wb_flush_threshold = UFS_WB_BUF_REMAIN_PERCENT(80);
 
diff --git a/drivers/ufs/host/ufs-mediatek.h b/drivers/ufs/host/ufs-mediatek.h
index 4e6a34f4ac39..9c377745f7a0 100644
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
2.52.0

