Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794966158;
	b=GI7TBkf1kp2KS8IBFjBIbG47hAgUS4XYXXp8+jQBeH6zOdg0tzm4iCWoOKnttBkoCTnH
	 WQrB6AJe8Duv8Whw3dpVBzVK9MUsapOAg6SGtijxxvzM8d/wCzrHDNxk1Nw3bYpuvEnvK
	 4YBBB7NGC0CF/pyLMU08M2E38Qgfaff4T5huOQxJF87TDaxshx/hv/5nrzCn6nOj+zSC5
	 pvU5PLZY+ocld+ukXjJH0JoENv1MEX7gTztKsmoE7jC7po4nD6yXLy8P5kfrKj0R1cTmv
	 lvx7LxKOZ9pp0bam9WCTloV1os+pmyQqjwNX+xYQbvUuwzOt2FutWO6woPAG0aw4frw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794966158;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ZjfWekzq4/sRPKRMmFj7v/AEpXemuhGVbDD4ndLcqmY=;
	b=xNt4yvd4oQgdiz4HBFt+56IhsPLVkxyBoEd9dR93dVALKAUAgIuF6MMZD0mjy5rHHlN1
	 tpGffnjcn6LweYrjg+dd8EAqI+p+OHhPPLRx2/+04h1v1tzOpPXKpR7F9y8cRuiQa/p5o
	 wp2Ni8yFN717h2ojLWzREYibQm6kbBAUaG8S3hc0qAKWny+DPsdN2Fua+KDKJWOTtDUBR
	 I5jyQXpJyxTpzLXmvYmUOz0R/2yGXUfm7cI9PQQzZEfBiTIuoXO9cZhbkn33WLMwrx/vl
	 TP1E0LlACYQHbweoCAw/izJOZCyfEwLeToize6Vq7n0CyOzPuOtJ3rtifavTzWtRjtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=OdRnApPq;
	arc=none smtp.remote-ip=111.22.67.139
Received: from cmccmta6.chinamobile.com (cmccmta6.chinamobile.com [111.22.67.139])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 353CF606A31C;
	Wed, 18 Nov 2026 01:42:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 353CF606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=OdRnApPq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=OdRnApPqBadmTms5nquAyOq4wuofPZjv8yZ/S7EbX6R9til8+1zgGQqHjJU2OdoTtXUt6+NDW4eWZ
	 cS8AqriS0U0HoPbWB1423N0gAQZGT4jGJ781Ywnchmy3ZjbSgVMTs9Hg3TeXQKznMBZNSpSKbCIGNV
	 LUiZnSmf9uoC7kos=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app01-12001 (RichMail) with SMTP id 2ee16afd028b05c-e9a37;
	Wed, 18 Nov 2026 09:42:36 +0800 (CST)
X-RM-TRANSID:2ee16afd028b05c-e9a37
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from DESKTOP-3K8GUTQ (unknown[223.108.79.97])
	by rmsmtp-syy-appsvr06-12006 (RichMail) with SMTP id 2ee66afd028ac77-c42b3;
	Wed, 18 Nov 2026 09:42:35 +0800 (CST)
X-RM-TRANSID:2ee66afd028ac77-c42b3
From: Xiangwu Lai <laixiangwu@cmss.chinamobile.com>
To: peter.wang@mediatek.com,
	chaotian.jing@mediatek.com
Cc: chu.stanley@gmail.com,
	alim.akhtar@samsung.com,
	bvanassche@acm.org,
	stanley.chu@mediatek.com,
	linux-scsi@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Xiangwu Lai <laixiangwu@cmss.chinamobile.com>
Subject: [PATCH] scsi: ufs-mediatek: use devm_regulator_get() for the va09 regulator
Date: Wed, 18 Nov 2026 09:42:34 +0800
Message-ID: <20261118014234.424-1-laixiangwu@cmss.chinamobile.com>
X-Mailer: git-send-email 2.50.1.windows.1
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

Fixes: cf137b3ea49a ("scsi: ufs-mediatek: Support VA09 regulator operations")
Signed-off-by: Xiangwu Lai <laixiangwu@cmss.chinamobile.com>
---
 drivers/ufs/host/ufs-mediatek.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 5b6bff2cf..426af10b3 100644
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
-- 
2.50.1.windows.1



