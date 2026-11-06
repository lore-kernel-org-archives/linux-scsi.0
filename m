Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.25
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793945750;
	b=MFvJJIV4kW92I7dc1VGChYe9hGia+J+2G0WP5XFtt81haT+Q3rFj2FQ4bByFLKNtRuOd
	 opDWGJ/IzNLohMrNY9mnJcNbO2RupgJh3BrA1fupJUFWeNF2hc1AefiHV3d4uuL6iImKi
	 5392I7+eRz5Iq5EhKbONJAqVHtEEtOtthIRkbvSnETAjZFbRsTnKDsn4OYsahcu/Q5UE6
	 M3TFm8QjRMb7pd8uCjGkG/XN+ktEQ1ZUUBCv5h6vSOMtw7WwqRMK/9zGs24F/NPSf1eR1
	 DgadBWtnrEETdmeVv+AofbYOLb0ORLPNsUNpjU7M+Kas/sq6qM5AolnPzIO0ZCckDFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793945750;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:X-Sendblock-Type:CMS-TYPE:X-CPGSPASS:
	 cpgsPolicy:X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=C9+ToI4wfuI3hQuZPFjeXBO3vlyX0xZf1fkhqdYbUM0=;
	b=P1QJAJfcdEx2S9SctsSwHXul+luhASj2hzxXsNi/Cn66YYix0q759Df62GUiFZwVHtiZ
	 29iip4M6aXAZ6rpn+YzgS1EVkaK3sDS6kEcQJJAkdzrj4a5gK1JYqVFPz3Kp57aMWh7ez
	 r6A0GjM1LaT57AfBK/yN1apvmO8DsgcFKuX+ZsVYcI885xVoo0li6n4w4VdmTC6BzY6tL
	 5V2Q2rqWNaC/j0kcKB3j7AkLaUpNTx5OO4Dwbe/dvLpa4szghuWF4k1hPVu2QzyU/2D0S
	 s5HxoWYB0+n/gW+UTN/oEVxVLw20j6fZMcX6nTTWAjAilw5WtVM/zNcQMVmVjSfAvaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=O7TKr7B9;
	arc=none smtp.remote-ip=203.254.224.25
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4FF5606A32D
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 06:15:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4FF5606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=O7TKr7B9
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20261106061547epoutp026214ae8d339f31846bcd1a13874cd7e7~lYCcCQgr62780127801epoutp02G
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 06:15:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20261106061547epoutp026214ae8d339f31846bcd1a13874cd7e7~lYCcCQgr62780127801epoutp02G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793945747;
	bh=C9+ToI4wfuI3hQuZPFjeXBO3vlyX0xZf1fkhqdYbUM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O7TKr7B9A8izSQLs3iMnrVc+nsG0F2srnry9riFC/3ef6IXkHIPoHzilV055nj4C/
	 ELLNjRHN2ML1qFIoVRAowO08mh4mg0brO4qUelo4/GL5XoUbl5NX+CqZyTEbLyZ7/8
	 TPKjak+ABAScqj/JeVIk7hpeULqgpjQEyoy9HVoE=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPS id
	20261106061546epcas2p27a9795f6808f265e450e8556d4acec80~lYCbltmqP2331123311epcas2p29;
	Fri,  6 Nov 2026 06:15:46 +0000 (GMT)
Received: from epcas2p3.samsung.com (unknown [182.195.38.208]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4jLTSf2tjXz6B9mD; Fri,  6 Nov
	2026 06:15:46 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
	20261106061545epcas2p2e16985621e8852e675e5a557857dca54~lYCay17VE2386023860epcas2p2x;
	Fri,  6 Nov 2026 06:15:45 +0000 (GMT)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.81.221.204]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261106061545epsmtip154f16d891b5bd0b35387e040936808e2~lYCauX0PV0088100881epsmtip1d;
	Fri,  6 Nov 2026 06:15:45 +0000 (GMT)
From: HOYOUNG SEO <hy50.seo@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	bvanassche@acm.org, mkp@kernel.org, martin.petersen@oracle.com,
	stanleyjhu@google.com, alim.akhtar@samsung.com, kwangwon.min@samsung.com,
	kwmad.kim@samsung.com, cpgs@samsung.com, h10.kim@samsung.com
Cc: HOYOUNG SEO <hy50.seo@samsung.com>
Subject: [PATCH v7 1/3] scsi: ufs: core: Clear saved errors in
 ufshcd_link_recovery()
Date: Fri,  6 Nov 2026 15:11:16 +0900
Message-Id: <59dbee337b8f28240beff5fe24fb327b226564da.1793943246.git.hy50.seo@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1793943246.git.hy50.seo@samsung.com>
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
X-CMS-MailID: 20261106061545epcas2p2e16985621e8852e675e5a557857dca54
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-234,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261106061545epcas2p2e16985621e8852e675e5a557857dca54
References: <cover.1793943246.git.hy50.seo@samsung.com>
	<CGME20261106061545epcas2p2e16985621e8852e675e5a557857dca54@epcas2p2.samsung.com>

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

Fixes: 35dabf4503b9 ("scsi: ufs: core: Use link recovery when h8 exit fails during runtime resume")
Signed-off-by: HOYOUNG SEO <hy50.seo@samsung.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
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

