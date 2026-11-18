Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794972024;
	b=AnjQ1wbywx4RjKdcu2ASguofYy5ZSPJHAhRVdJWJcy31CRC/0XO59X9RFCa8Df5LPRqm
	 i9LI3gDBfeVLe/owz/YLVcd+5kF+KHsIKUqbRGpnGQjx9J28mBkF5FXfYwhcxdgPaKHYQ
	 CybgkmgN/cX4bMrM6CXLLKI0GhHU51txZ+ZrbP9lGX88pJQbE3IQ2Q0gKXIy4FOSnpqrS
	 58+6NVqKg6qYHjpP8fJqMFAoTAVUNyrkBGjVFWmNp7XzlaaSBxAMh2oZmuAGH6dCWoQXs
	 MFP/EwnIgZJOoVDjEdNG7FVf+rQxKuYJaNPtmGKT5arUeXVmSAELv4Zz/3g9m0Z401w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794972024;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xavNYUcUt2JC/N4HjZciqIyCMtHY4/jj8/p6nwYYQrw=;
	b=eMdK+YSKJyWIA7lenmK70Q7uAE9Qypwj4lq+YX5Pe69foZj/Y2vh7k+y8AeeT2XwGTnG
	 5sjvidE1/QV5lr86XfAqbJZJv3RRVf6Yj+/Ae6vCB5BzLYl/vrrbjLIDHBcfqqHZxBih+
	 PMXIgSyXseY8vSq6Sf4NkotuSxwwuRy4nTCEWioqRCbTYC4RhFSsXDnjod7b3IwRGWZsV
	 EP9A6FoBE6j3QWTmwOUac/ylcOfZbrw2OXBRrCNObOX01uarOQ4OO4AdrmzTs9LmiyJ6Q
	 SEJ+7+LSNgNiCpkdwjw0K9vMHAC6LXAXHiwxwAHix2HqEKRooIIR3KIigYCK1xfthrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=RN5a2BCY;
	arc=none smtp.remote-ip=111.22.67.139
Received: from cmccmta6.chinamobile.com (cmccmta6.chinamobile.com [111.22.67.139])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8280606A31C;
	Wed, 18 Nov 2026 03:20:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C8280606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=RN5a2BCY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=RN5a2BCYZ8iStVhjDy0dINQtPs4IQ/p2cJgU14RXbEBeJ62z1cK3pTDKldN0+CFzm3hwKWNg0B1Dm
	 KPiigJdgakX/K/KiCx1aXmyl8OB2bZqtNVaztTb5ZF8Z2TOIyzXiNSF2wZkajWoy6+QYsBodj14LVg
	 nZa2856oI76fsQvg=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app05-12005 (RichMail) with SMTP id 2ee56afd1972b44-0c64c;
	Wed, 18 Nov 2026 11:20:19 +0800 (CST)
X-RM-TRANSID:2ee56afd1972b44-0c64c
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from  (unknown[223.108.79.97])
	by rmsmtp-syy-appsvr05-12005 (RichMail) with SMTP id 2ee56afd1970808-c73ca;
	Wed, 18 Nov 2026 11:20:19 +0800 (CST)
X-RM-TRANSID:2ee56afd1970808-c73ca
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
Subject: [PATCH v2 2/2] scsi: ufs-mediatek: keep mphy state in sync when va09 disable fails
Date: Wed, 18 Nov 2026 11:20:15 +0800
Message-ID: <20261118032015.974-3-laixiangwu@cmss.chinamobile.com>
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

In ufs_mtk_mphy_power_on(), the power-off path calls phy_power_off()
before disabling the va09 regulator.  If regulator_disable() fails,
the error is returned while host->mphy_powered_on is left set,
although the M-PHY is physically powered off already.  The next call
with on = true then bails out through the !(on ^ host->mphy_powered_on)
check without powering the M-PHY back on, leaving the UFS link dead
(I/O timeouts, controller lockups).

The M-PHY is off regardless of the va09 disable result, so update the
state flag in the power-off path and let the next power-on retry the
whole sequence.

Found by code inspection while reviewing the va09 error paths of the
driver; the failure has not been observed on real hardware.

Link: https://lore.kernel.org/r/sashiko-outbox-219916@kernel.org
Fixes: cf137b3ea49a ("scsi: ufs-mediatek: Support VA09 regulator operations")
Signed-off-by: Xiangwu Lai <laixiangwu@cmss.chinamobile.com>
---
 drivers/ufs/host/ufs-mediatek.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index ebbc017d0..8d4b84d58 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -542,6 +542,14 @@ static int ufs_mtk_mphy_power_on(struct ufs_hba *hba, bool on)
 			ufs_mtk_va09_pwr_ctrl(res, 0);
 			ret = regulator_disable(host->reg_va09);
 		}
+		/*
+		 * The M-PHY is off regardless of the va09 result, so keep
+		 * the state in sync with the hardware.  Otherwise the next
+		 * power-on bails out through the
+		 * !(on ^ host->mphy_powered_on) check without powering the
+		 * M-PHY back on.
+		 */
+		host->mphy_powered_on = false;
 	}
 out:
 	if (ret) {
-- 
2.50.1.windows.1



