Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.135
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794972026;
	b=L1FOoDCQT4e7/Ekv2DAab08s3lyuk2mLcOajMj7PM+W/F3Sp4Uuaw62IXbwDwlO+JTZg
	 VovGKcBdX1huMHgcjCWtgad95AK31QiSF9jD2SkFDTDJ1axjPHfQlVt6NSFzM1ujl+vtT
	 JxosmEfc5qLkLmpcq+qXhiV7T2y/G15GIgRC+TwObLDbzcwddmQWNEMo0MXkH1TVhGYuh
	 3/XV8P3bfMtyS7p9NxSgWboLfZzUypFIWCBw3fVgNd8x+WrKltBXwzLJIse5FyJ0r0x/g
	 EY2EyEdzewka3nkFPtvMrluc726mupnyKcFnw87P/xjlgbiZibpeSNpdd2MiqMqQcXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794972026;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b74ThapphpHdcIp0nuCmWe/yrPJRe9Mk4R9gdk1TObU=;
	b=ByLpahYuTEZWKIbcybb8o76JMoPkZTsakR0k1kbkyjFo2nB4aZe7rExMZoUCcCsVDcVj
	 vDQjkwj71V4uRKMTIWLw/naSd3ZkxvjQXvzGGYWnLpL0qs64tgIK4CkAAm27J8lUuatQr
	 UKJ7hcw05ODJ7J9Ehrsod0hfnR9YSXwK6Bekkw71339yvYWN7EQX7C0JrZRUPYiqA+7u3
	 YaLnFF9XiBhcFFZmiw0mQZHrPkAMkTXAwaY21CnzmAxL7w1JoFXJE9XXSTr8d1wA117Np
	 8Unktv9tPOG9xKv/ilfctMS6ZJHTmDiDizfYGUonJs0rYWHvdgzoiTkgjRk6GOf/57g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=Zesy2vxq;
	arc=none smtp.remote-ip=111.22.67.135
Received: from cmccmta2.chinamobile.com (cmccmta2.chinamobile.com [111.22.67.135])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A277B606A334;
	Wed, 18 Nov 2026 03:20:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A277B606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=Zesy2vxq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=Zesy2vxqX0/IHcz6PvWeXx+oUlxnYx5Vj9RWvlwCnOU7ZorZA2oiVP40wTchMD1Kd5XDPL318tONS
	 2OaOrnpdN0/W1ecwB9PB8y9vWi7h8pcSh39zXGyq83EW0qtDxDZGJJ5kyB08K7SQ6kLyYWn69fugxy
	 TSpTzIYTECwIehyk=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app07-12007 (RichMail) with SMTP id 2ee76afd197228f-10156;
	Wed, 18 Nov 2026 11:20:18 +0800 (CST)
X-RM-TRANSID:2ee76afd197228f-10156
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from  (unknown[223.108.79.97])
	by rmsmtp-syy-appsvr05-12005 (RichMail) with SMTP id 2ee56afd1970808-c73c7;
	Wed, 18 Nov 2026 11:20:18 +0800 (CST)
X-RM-TRANSID:2ee56afd1970808-c73c7
From: Xiangwu Lai <laixiangwu@cmss.chinamobile.com>
To: peter.wang@mediatek.com,
	chaotian.jing@mediatek.com
Cc: chu.stanley@gmail.com,
	alim.akhtar@samsung.com,
	bvanassche@acm.org,
	stanley.chu@mediatek.com,
	sashiko-bot@kernel.org,
	linux-scsi@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Xiangwu Lai <laixiangwu@cmss.chinamobile.com>
Subject: [PATCH v2 1/2] scsi: ufs-mediatek: use devm_regulator_get() for the va09 regulator
Date: Wed, 18 Nov 2026 11:20:14 +0800
Message-ID: <20261118032015.974-2-laixiangwu@cmss.chinamobile.com>
X-Mailer: git-send-email 2.50.1.windows.1
In-Reply-To: <20261118032015.974-1-laixiangwu@cmss.chinamobile.com>
References: <20261118032015.974-1-laixiangwu@cmss.chinamobile.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ufs_mtk_init_va09_pwr_ctrl() obtains the va09 regulator with
regulator_get() but the reference is never released with
regulator_put(), neither on driver unbind nor on probe failure. The
other regulators handled by this driver (dvfsrc-vcore) are already
obtained with devm_regulator_get_optional().

Use devm_regulator_get() so that the reference is released
automatically when the UFS device is detached.

This alone is not enough, though: ufs_mtk_init() powers the M-PHY on,
which enables the va09 regulator, and nothing powers it off again on
the way out -- the variant operations have no .exit callback and
ufshcd_pltfrm_remove() only resumes the device.  The devm release
would then hit WARN_ON(regulator->enable_count) in _regulator_put()
and leak the enable reference.

Balance the use count by adding an .exit callback which powers the
M-PHY off, in the same spirit as the .exit callbacks of ufs-exynos
and ufs-qcom.  ufshcd_hba_exit() invokes it both on driver unbind and
on ufshcd_init() failure after the variant init, so the enable count
is always balanced by the time devm releases the regulator.  It
relies on the state tracking in ufs_mtk_mphy_power_on() and is a
no-op if the M-PHY was never powered on.

Fixes: cf137b3ea49a ("scsi: ufs-mediatek: Support VA09 regulator operations")
Signed-off-by: Xiangwu Lai <laixiangwu@cmss.chinamobile.com>
---

Changes in v2:
- Keep devm_regulator_get() and additionally add an .exit callback
  that powers the M-PHY off, so the va09 enable count is balanced
  before the devm release.  Without it, _regulator_put() would hit
  WARN_ON(regulator->enable_count) on every driver unbind, since
  ufs_mtk_init() leaves the regulator enabled (reported by Sashiko
  AI review).

Link: https://lore.kernel.org/r/20261118014234.424-1-laixiangwu@cmss.chinamobile.com

 drivers/ufs/host/ufs-mediatek.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 5b6bff2cf..ebbc017d0 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -692,7 +692,7 @@ static void ufs_mtk_init_va09_pwr_ctrl(struct ufs_hba *hba)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 
-	host->reg_va09 = regulator_get(hba->dev, "va09");
+	host->reg_va09 = devm_regulator_get(hba->dev, "va09");
 	if (IS_ERR(host->reg_va09))
 		dev_info(hba->dev, "failed to get va09");
 	else
@@ -1331,6 +1331,14 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 	return err;
 }
 
+static void ufs_mtk_exit(struct ufs_hba *hba)
+{
+	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
+
+	if (host)
+		ufs_mtk_mphy_power_on(hba, false);
+}
+
 static int ufs_mtk_negotiate_pwr_mode(struct ufs_hba *hba,
 				      const struct ufs_pa_layer_attr *dev_max_params,
 				      struct ufs_pa_layer_attr *dev_req_params)
@@ -2353,6 +2361,7 @@ static void ufs_mtk_config_scsi_dev(struct scsi_device *sdev)
 static const struct ufs_hba_variant_ops ufs_hba_mtk_vops = {
 	.name                = "mediatek.ufshci",
 	.init                = ufs_mtk_init,
+	.exit                = ufs_mtk_exit,
 	.get_ufs_hci_version = ufs_mtk_get_ufs_hci_version,
 	.setup_clocks        = ufs_mtk_setup_clocks,
 	.hce_enable_notify   = ufs_mtk_hce_enable_notify,
-- 
2.50.1.windows.1



