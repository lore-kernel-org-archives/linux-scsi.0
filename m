Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793931625;
	b=Ghzmt4PoyUA8cZHMnH62CoVaJd+m31FMYdcZsZsW9xRu0DsCrsbtW1hnUXWiZXjy+iN5
	 KlCaUpWKfyaFWgxBqXibC6hGJHYsOTOSzVO2xb68vnGO13JYG4ARqYVuvb3WJbdwtuPpi
	 3k265cQ74b/tRmkLqX6hF8fwFKR1KJ4BvZRwuAFImLZPufpBXsEdgzLNj1yS+6OEwiVkP
	 odYqWUx5P5k6L3ExBUI1/6Fj1IMrLL8Keaeydx03oqpqDnwl7PN9ojMG22uIodqF3Qmcm
	 FUEtnvklxPNeMAQBEbTeyLR5PGRaMw5hOQCXS+7WhgWXR61QfzrPMgk7qDK2ehqK5QQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793931625;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:X-Sendblock-Type:CMS-TYPE:X-CPGSPASS:
	 cpgsPolicy:X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=IH385t9Epw8+bpp6HAM6xMRljzOdk7XC9UY4wR7x0L8=;
	b=ExAv0nB3v3I3FvDMmhYttFyv0JzgCUd7Ktu4ftCOkA1BoIkC6YJq6d5z4BwQX4Splke6
	 uNUJHR4rRLaFLcpywugnnWgmIBdutjaftDrnpMU0nLhsu4710nYsA5cqZGwDXOdoakvY5
	 m5A/w4Uo6omnPIZD8ewsELnhuMqKXamZ4MZBrnEwB8WP5MPX50HsUwx+RxjT77FBDOusB
	 JNtF/cH3H3EFUgADsmRdfaK46ZJokqZ6lFTlGo7vCcMfgvzu4IvkuZbl6sHrXV18JmYOE
	 p4FDsmrR5vbC0spOjGP5q3E9Z35oQ9/+uUO8vrQpZs62cPG1kOJ8W8FdBMJJiZl69rQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=iCGfqy5e;
	arc=none smtp.remote-ip=203.254.224.34
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE78E606A32C
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 02:20:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BE78E606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=iCGfqy5e
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20261106022021epoutp04a6a1de2ccbe4ec4d1597bbcae6e3fb32~lU04g5CZK0042700427epoutp04J
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 02:20:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20261106022021epoutp04a6a1de2ccbe4ec4d1597bbcae6e3fb32~lU04g5CZK0042700427epoutp04J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793931621;
	bh=IH385t9Epw8+bpp6HAM6xMRljzOdk7XC9UY4wR7x0L8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iCGfqy5eWhpW6Rmsg33nXOmyiBhvoeyP06XpPsmK1/QRnsnF4aye9h5zxHwjHQcuu
	 N2qbU07L/st0/RJyebjYoZ5rljWEMyyUO5vU9m44Bfse5LRAwmxwg80IAon91E2QZC
	 TDGrly3iP5XF4vGTU0Rv3sf1EPrPNtkDjW8GAHH4=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPS id
	20261106022021epcas2p2af9dec489a6bfd660d21cd5ad8f8de84~lU04HPLEz2615426154epcas2p2M;
	Fri,  6 Nov 2026 02:20:21 +0000 (GMT)
Received: from epcas2p1.samsung.com (unknown [182.195.38.202]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4jLNF05xj0z3hhTL; Fri,  6 Nov
	2026 02:20:20 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
	20261106022020epcas2p397f84c634df3397fcb1c98d1837bb83f~lU03CyHWz0947409474epcas2p3s;
	Fri,  6 Nov 2026 02:20:20 +0000 (GMT)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.81.221.204]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261106022019epsmtip136af37fea21b164474413654d420ad51~lU029ObBB0346703467epsmtip1I;
	Fri,  6 Nov 2026 02:20:19 +0000 (GMT)
From: HOYOUNG SEO <hy50.seo@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	bvanassche@acm.org, mkp@kernel.org, martin.petersen@oracle.com,
	stanleyjhu@google.com, alim.akhtar@samsung.com, kwangwon.min@samsung.com,
	kwmad.kim@samsung.com, cpgs@samsung.com, h10.kim@samsung.com
Cc: HOYOUNG SEO <hy50.seo@samsung.com>
Subject: [PATCH v6 1/3] scsi: ufs: core: Clear saved errors in
 ufshcd_link_recovery()
Date: Fri,  6 Nov 2026 11:15:51 +0900
Message-Id: <a0b59fb709e8c53a72e2839bb6b1635a4a20f395.1793931113.git.hy50.seo@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1793931113.git.hy50.seo@samsung.com>
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
X-CMS-MailID: 20261106022020epcas2p397f84c634df3397fcb1c98d1837bb83f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-234,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261106022020epcas2p397f84c634df3397fcb1c98d1837bb83f
References: <cover.1793931113.git.hy50.seo@samsung.com>
	<CGME20261106022020epcas2p397f84c634df3397fcb1c98d1837bb83f@epcas2p3.samsung.com>

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

