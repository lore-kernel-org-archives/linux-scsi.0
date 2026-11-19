Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795072577;
	b=UwCmlABzXhTFHY71nEwsMpXpcoPhEIvJHoBYeSWjFsIH5lcW+iXSxlTuP6+wBtT2xLKe
	 dfa6gg9BB+a9umcHvGKEHE+QIRnR1yndggFaWvNfdwXIvyZZ8jIKIiH19Nupbh6OAmA/c
	 O7dEKKfRN4zbfKE/kjyh2h5/03K9obWp1B9mngyFofdXpMzUsF/D8OJbf9XSmHoYbdtGT
	 LM0HH1SyqHs811GNBrbL9CimgyYKfNCvo5njkNTzKSLkhONzApCCVMBTj/EvSIm997Rlh
	 VGVyk6uyNHsKhGFUpUCItlGvHir8abe7f3+q4FmPoRV+sFxKhYSVfIT3+mj0jWy2R2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795072577;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bQFs6QcycdODAlRkXP22avEkZfPGNEYE6AJIhhJv7Hw=;
	b=V/ClaT8ezzbCtQYnq7ecFWF53APMpv+PKLnQG9vKlcIiDx3nyIvjEbYG4nGeqxyDCeBz
	 zYPBnVusW/79hCDRE0afHgQDRsCyvtKwFqtkNElTyrsSe7KcSclE6RfhhmhVAEx3gEsHp
	 npFvjA71ZVrz3qNt2I9odRJ6ggLgsL2OE25nRkYNBqYlqnKvGsv3nIyWpH9WbG85ld5iU
	 4b0F5sg8+7qCBR3MEQfuCVQweqisO0dMn4CBDiASJoAQ+rpXWERSQLuV6wP8WWZRnZdkT
	 rQ67BWrW1+jlK7Ex5janFcztVcBw/XqMpB9+jx9nnBKrIUPUqWzYftKKDBBf6EBM0hQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=sqjBq9lL;
	arc=none smtp.remote-ip=111.22.67.139
Received: from cmccmta6.chinamobile.com (cmccmta6.chinamobile.com [111.22.67.139])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D49A606A324;
	Thu, 19 Nov 2026 07:16:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6D49A606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=sqjBq9lL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=sqjBq9lL5HZ/Lw1lhIiPaTm77Y/w3v803JsflBwtvaAgelFBEmggc01/gZKQmhIsPqsYSpQsLH1+G
	 EFXl3+JIkNkoPWCc4eWzUGaF8hzYHj0tSevEQbakntC4GGEFhC8e5bE6gQ4ofM5iFlmyrcMsu2TS3v
	 Ns8D+hBW7FxrYNwo=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app05-12005 (RichMail) with SMTP id 2ee56afea23e7b1-18364;
	Thu, 19 Nov 2026 15:16:14 +0800 (CST)
X-RM-TRANSID:2ee56afea23e7b1-18364
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from  (unknown[223.108.79.97])
	by rmsmtp-syy-appsvr05-12005 (RichMail) with SMTP id 2ee56afea23a32d-f43aa;
	Thu, 19 Nov 2026 15:16:14 +0800 (CST)
X-RM-TRANSID:2ee56afea23a32d-f43aa
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
Subject: [PATCH v3 2/2] scsi: ufs-mediatek: restore the M-PHY power state when va09 disable fails
Date: Thu, 19 Nov 2026 15:16:10 +0800
Message-ID: <20261119071611.117-3-laixiangwu@cmss.chinamobile.com>
X-Mailer: git-send-email 2.50.1.windows.1
In-Reply-To: <20261119071611.117-1-laixiangwu@cmss.chinamobile.com>
References: <20261119071611.117-1-laixiangwu@cmss.chinamobile.com>
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

In ufs_mtk_mphy_power_on(), the power-off path tears the M-PHY down in
two steps before regulator_disable() is called: phy_power_off() puts
the PHY PLL and its clocks down, and ufs_mtk_va09_pwr_ctrl() asks the
firmware to drop the VA09 supply.  If regulator_disable() then fails,
the M-PHY stays physically off while host->mphy_powered_on is left
set, so the next power-on attempt bails out through the
!(on ^ host->mphy_powered_on) check and never powers the M-PHY back
up, leaving the UFS host with an unpowered PHY (I/O timeouts,
controller lockups).

Simply forcing mphy_powered_on to false would trade this for two more
problems.  First, the regulator core drops the consumer enable count
only after a successful disable, so the count stays at 1, the next
power-on raises it to 2 and it never returns to zero: va09 is then
never physically disabled and the devm-acquired regulator would hit
WARN_ON(enable_count) again on release.  Second, when the power-off
fails during ufs_mtk_suspend(), the error recovery in
__ufshcd_wl_suspend() runs ufshcd_host_reset_and_restore() without
powering the M-PHY back on, which would run against an unpowered PHY.
(Both points were raised by the Sashiko AI review of v2.)

Since the va09 regulator stays enabled when its disable fails, restore
the M-PHY power state instead: power the PHY back on through
ufs_mtk_va09_pwr_ctrl() and phy_power_on() and leave mphy_powered_on
set.  The next power-off attempt then retries the full sequence and
the enable count stays balanced.

Found by code inspection while reviewing the va09 error paths of the
driver; the failure has not been observed on real hardware.

Suggested-by: Peter Wang <peter.wang@mediatek.com>
Link: https://lore.kernel.org/r/sashiko-outbox-220026@kernel.org
Fixes: cf137b3ea49a ("scsi: ufs-mediatek: Support VA09 regulator operations")
Signed-off-by: Xiangwu Lai <laixiangwu@cmss.chinamobile.com>
---
 drivers/ufs/host/ufs-mediatek.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

Changes in v3:
- restore the M-PHY power state when regulator_disable() fails
  (phy_power_on() plus the va09 SMC call) instead of forcing
  mphy_powered_on to false, as suggested by Peter Wang.  This also
  keeps the va09 enable count balanced and leaves the suspend error
  recovery running with the M-PHY powered, resolving both findings of
  the Sashiko AI review of v2
  (https://lore.kernel.org/all/sashiko-outbox-220026@kernel.org/).

Link: https://lore.kernel.org/r/20261118032015.974-3-laixiangwu@cmss.chinamobile.com/

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index ebbc017d0..caf186966 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -541,6 +541,16 @@ static int ufs_mtk_mphy_power_on(struct ufs_hba *hba, bool on)
 		if (ufs_mtk_is_va09_supported(hba)) {
 			ufs_mtk_va09_pwr_ctrl(res, 0);
 			ret = regulator_disable(host->reg_va09);
+			if (ret) {
+				/*
+				 * The va09 regulator stays enabled, so
+				 * bring the M-PHY back up to keep the
+				 * software state in sync with the
+				 * hardware.
+				 */
+				ufs_mtk_va09_pwr_ctrl(res, 1);
+				phy_power_on(mphy);
+			}
 		}
 	}
 out:
-- 
2.50.1.windows.1



