Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.25
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793865665;
	b=j62YutJPoaYrbYObYqA4NXbVP8iDhHBQtfc7J3Z2FE9RLRTr6SBDOo8iut1yWGojDogb
	 AtuyxjqLYCLI55cijtZITrn4oTudEAFBQFJ+CpbuwGaMVyP2a1rJLnUie7ja/5VLMUTr2
	 fyYQ36wD6Fnb77a1gnP4iuKlCc2NmZYbz2TgJwUY6kLV4f3bilZyBH1oqcwphRxHvv1+n
	 cSYYKxLmM7sVscMCSARTohqgkMahUaSnBMDxgdqMyTzoCNxyEgt6IcU7VP4EYrZi54GPy
	 d7A2Ur+/2CJSH+tYiAujedm6y0qmpqi/dYgGvPoW6xYYkMj+PM8A+9wAZiI03/JAVmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793865665;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:X-Sendblock-Type:CMS-TYPE:X-CPGSPASS:
	 cpgsPolicy:X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=csK9dgm7U755rGUdnl4P8DPAxrtTm2BPzEXrt7f6/MU=;
	b=RZ9yYG8AhRxNFLP/EOwqqj1Mg1dqiiZS9LIfY6l1TZL/ZxynuVphHvto9Xb+mfm+b+w9
	 pRFrdBXFUtwn6Od+f5UXPJ073NEtdKYXEUiplG8FScQKIIjSeQSBDfj1flXD7nmGnDLhZ
	 Ci+CJwRnIS6jllDd9GAB7khZDNO1r1s74ZhTxX00MvPOaMYlIDZ+d2ZFH6AXTIGl0nqsk
	 V2x7Pi8+FLrFxGugJCBwyFG9Luta+tbdHbr04+F0NK2rfFUH8YMaZrKBW6xvDAHyNRJYO
	 lQD3qCkmHFvD/It4nHM3d+HoETQRXLE3nR39jWStc9LTDleMqLPQWQ97+HCdB8mUIlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=Umtr2zBB;
	arc=none smtp.remote-ip=203.254.224.25
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1A9606A329
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 08:01:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6A1A9606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=Umtr2zBB
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20261105080101epoutp02a29a1e66597a1ec6cf436f064538f82a~lF1CrI46Z0660106601epoutp02A
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 08:01:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20261105080101epoutp02a29a1e66597a1ec6cf436f064538f82a~lF1CrI46Z0660106601epoutp02A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793865661;
	bh=csK9dgm7U755rGUdnl4P8DPAxrtTm2BPzEXrt7f6/MU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Umtr2zBBfHPqtEvCOeJBqfWS8KNebTcsvqtFJrr9FSKcSHexj2rrTDwfKJFXN4nZG
	 FL5tlpHaboyvk2Zy1Sn/YR8qkjJP0gsO4j4hvO/cvgqZBxovlvOGpw+NZveOlU/NDd
	 hLEoH8C1RiErH9zKMQa7JNSDKvENEvvsQr3Tg1kY=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPS id
	20261105080101epcas2p393b69420de32ed8c69b218e7d48e8fb5~lF1B6tFaU2409624096epcas2p3N;
	Thu,  5 Nov 2026 08:01:00 +0000 (GMT)
Received: from epcas2p4.samsung.com (unknown [182.195.38.205]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4jKvrX4PYwz2SSL1; Thu,  5 Nov
	2026 08:01:00 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
	20261105080100epcas2p36fcb27f8e5763089901d3a8539c281dc~lF1BAavYc2407924079epcas2p3D;
	Thu,  5 Nov 2026 08:01:00 +0000 (GMT)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.81.221.204]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20261105080059epsmtip219481bf4b133c70332246df296d5d24f~lF1A7qbl22425224252epsmtip26;
	Thu,  5 Nov 2026 08:00:59 +0000 (GMT)
From: HOYOUNG SEO <hy50.seo@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	bvanassche@acm.org, mkp@kernel.org, martin.petersen@oracle.com,
	stanleyjhu@google.com, alim.akhtar@samsung.com, kwangwon.min@samsung.com,
	kwmad.kim@samsung.com, cpgs@samsung.com, h10.kim@samsung.com
Cc: HOYOUNG SEO <hy50.seo@samsung.com>
Subject: [PATCH v5 1/2] scsi: ufs: core: Clear saved errors in
 ufshcd_link_recovery
Date: Thu,  5 Nov 2026 16:56:35 +0900
Message-Id: <4cefdf850673bade48a92949518869dfc2ae88e3.1793865172.git.hy50.seo@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1793865172.git.hy50.seo@samsung.com>
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
X-CMS-MailID: 20261105080100epcas2p36fcb27f8e5763089901d3a8539c281dc
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-234,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261105080100epcas2p36fcb27f8e5763089901d3a8539c281dc
References: <cover.1793865172.git.hy50.seo@samsung.com>
	<CGME20261105080100epcas2p36fcb27f8e5763089901d3a8539c281dc@epcas2p3.samsung.com>

ufshcd_link_recovery() resets both the device and the host and then
re-establishes the link. Unlike ufshcd_reset_and_restore(), however, it
does not clear hba->saved_err, hba->saved_uic_err and hba->force_reset,
so the errors latched before the recovery remain pending after the link
has already been recovered.

When ufshcd_err_handler() runs afterwards,
ufshcd_err_handling_should_stop() sees these stale errors. The error
handler then quiesces all queues and, depending on the latched errors
(e.g. a fatal error or UFSHCD_UIC_DL_PA_INIT_ERROR), performs another
full ufshcd_reset_and_restore() on a link that is already operational.

Cache and clear the saved errors before the reset, as
ufshcd_reset_and_restore() does, so that only errors raised during or
after the recovery are left to the error handler. Put them back if the
recovery fails.

Signed-off-by: HOYOUNG SEO <hy50.seo@samsung.com>
---
 drivers/ufs/core/ufshcd.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index fd52deb72d21..3b5580ac390c 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4695,10 +4695,20 @@ EXPORT_SYMBOL_GPL(ufshcd_uic_change_pwr_mode);
 
 int ufshcd_link_recovery(struct ufs_hba *hba)
 {
+	u32 saved_err, saved_uic_err;
 	int ret;
 	unsigned long flags;
 
 	spin_lock_irqsave(&hba->host->host_lock, flags);
+	/*
+	 * The errors saved so far are handled by this full reset, so cache and
+	 * clear them first, in case new errors are generated during recovery.
+	 */
+	saved_err = hba->saved_err;
+	saved_uic_err = hba->saved_uic_err;
+	hba->saved_err = 0;
+	hba->saved_uic_err = 0;
+	hba->force_reset = false;
 	hba->ufshcd_state = UFSHCD_STATE_RESET;
 	ufshcd_set_eh_in_progress(hba);
 	spin_unlock_irqrestore(&hba->host->host_lock, flags);
@@ -4709,8 +4719,11 @@ int ufshcd_link_recovery(struct ufs_hba *hba)
 	ret = ufshcd_host_reset_and_restore(hba);
 
 	spin_lock_irqsave(&hba->host->host_lock, flags);
-	if (ret)
+	if (ret) {
 		hba->ufshcd_state = UFSHCD_STATE_ERROR;
+		hba->saved_err |= saved_err;
+		hba->saved_uic_err |= saved_uic_err;
+	}
 	ufshcd_clear_eh_in_progress(hba);
 	spin_unlock_irqrestore(&hba->host->host_lock, flags);
 
-- 
2.34.1

