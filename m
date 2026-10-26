Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.24
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792989709;
	b=vzfPQvPbHTjdtoONbM0Gj6pUyC9HDKrXJF6zwdpKe6TnVkUci2gbqOG2d5KMRbCjMj49
	 oWd6XiGhxEM8SgdQTXALlTIBeitzf3RG/0TKAEE5fyRGTeCMNT0KfWERdLyGds47QZQNq
	 mt7rxJLfwHnbOGP5BI1BfmjrtIpCDjCbl4xiYLsyOpReAYJQajHeu/gqXrEpI6/ziHZ9G
	 wBny+WccecFxGv0meF9pOQuy7BBUnF9QUB0mhtEOlynMtrMeHz+f/uYHuD5ovpD5lThL7
	 7jk9TK6qMPQzL+TXEPijT2LtgzCQkaNrNUR8GtrLeVEd50G2EglWbBSTI38HwdhQcPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792989709;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:X-Sendblock-Type:CMS-TYPE:X-CPGSPASS:
	 cpgsPolicy:X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=i9Ml4qigH7DzspM/Amzf5XaHAXSm7xpnRAKJSyb+B5s=;
	b=FUktRhIRB675Uwru+8jeKLOC8NynszrXRxLwMI/VYsn1Wkbs0LG5oCQkX2pts0T4BCem
	 8nRj8P1Xz3k/zIdIoqpCLrraFOTclk8OLyMfkSefp2TxCiIY4Ulx6JmoYauN3PIEsXz2J
	 DnujXh16iyT86Ye47Ef4AS3I4rU6pyHI1evQeO+LZmgJ6bfEGxR0YwGfFGbu5pb9+2A7P
	 aBeRz+639qCZfDW/HAFPWXShB5UO4+GEN+pBRRx/QTOTAnsJINH4cVMs7XaRotHYToz8/
	 IB8H8q3pYMcpT5cj8jEJPiRt6laJTclSktyT1NGb5f2Z4uOhuEs7e1Dhc8gTC8u5g0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b="Ha/DKq0X";
	arc=none smtp.remote-ip=203.254.224.24
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D23606A320
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 04:41:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90D23606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=Ha/DKq0X
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20261026044141epoutp0161999b259c462c2d009db126da28f956~h_qI67uu52210422104epoutp01t
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 04:41:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20261026044141epoutp0161999b259c462c2d009db126da28f956~h_qI67uu52210422104epoutp01t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1792989701;
	bh=i9Ml4qigH7DzspM/Amzf5XaHAXSm7xpnRAKJSyb+B5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ha/DKq0XOwk423BgBc++PfZrKnSvpFec1cfj+K6/wLLbhbNtfEOThZyQJY2HDVev9
	 7ew1lKJvEMaPeQzbq6dJLL1J8FvPF5M7dkWLJ3IVT6ZfT1++8GLHe8oMu/8YEXyU4M
	 dBLtAW7J6N4/dHKd+qiQcM4+5otd/gJQlPaz3uvs=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPS id
	20261026044140epcas2p3a062afdfe7952408f310da73cf0495ca~h_qIdHFO21523415234epcas2p3F;
	Mon, 26 Oct 2026 04:41:40 +0000 (GMT)
Received: from epcas2p1.samsung.com (unknown [182.195.38.206]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4jCgv82dysz3hhT9; Mon, 26 Oct
	2026 04:41:40 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
	20261026044139epcas2p3a5b55ec93b313eeb9a38bbf0c93cf889~h_qHfcBAx1607616076epcas2p3S;
	Mon, 26 Oct 2026 04:41:39 +0000 (GMT)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.81.221.204]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261026044139epsmtip1c6e30acc4f83bf7ebfc8318ef2d9bc21~h_qHa79XP2136321363epsmtip1K;
	Mon, 26 Oct 2026 04:41:39 +0000 (GMT)
From: HOYOUNG SEO <hy50.seo@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
	martin.petersen@oracle.com, bvanassche@acm.org, kwangwon.min@samsung.com,
	kwmad.kim@samsung.com, cpgs@samsung.com, h10.kim@samsung.com
Cc: HOYOUNG SEO <hy50.seo@samsung.com>
Subject: [PATCH v3 1/2] scsi: ufs: core: Clear saved errors in
 ufshcd_link_recovery
Date: Mon, 26 Oct 2026 13:37:20 +0900
Message-Id: <31fc787b76a2586ca6d3c442afdb694aab3d14bb.1792989286.git.hy50.seo@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1792989286.git.hy50.seo@samsung.com>
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
X-CMS-MailID: 20261026044139epcas2p3a5b55ec93b313eeb9a38bbf0c93cf889
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-234,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261026044139epcas2p3a5b55ec93b313eeb9a38bbf0c93cf889
References: <cover.1792989286.git.hy50.seo@samsung.com>
	<CGME20261026044139epcas2p3a5b55ec93b313eeb9a38bbf0c93cf889@epcas2p3.samsung.com>

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
index bcc2512bf34b..74dfbb98129e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4690,10 +4690,20 @@ EXPORT_SYMBOL_GPL(ufshcd_uic_change_pwr_mode);
 
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
@@ -4704,8 +4714,11 @@ int ufshcd_link_recovery(struct ufs_hba *hba)
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

