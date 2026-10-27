Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.33
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793067303;
	b=YY3fc9jXX3FYV/lGuZqQr4kYw/glWkAivgDd7pJXV/AVC/jWiQS+SjNJnjqozUM8tY0E
	 +q9YO5UOWDSYBh9R0I+Cp/JWHq8313/fmozM/IVDUjgrxjPznzq/uJRtORtPHs/aLbAN7
	 vkuZWsvmm1m9sPvjdr7kHqcnOyLvRTlhfNLXL2IiPsHNxnGGBgNJ/eavc9lcII1I3dkR6
	 nDVpZVaXHC4kkpfqvxFkr77b1FreqSOVoZI3XBeHiAyVJAWJwp1pmGkLiTkZjVD0knrR2
	 rshl6Tfhfw9Y0IwulXTazpqBSqQDiILaERfCFo5JDre0lZHqHsCTxmhNYM5e34F3nfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793067303;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:X-Msg-Generator:
	 Content-Type:X-Sendblock-Type:CMS-TYPE:X-CPGSPASS:cpgsPolicy:
	 X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=r/ih1FRvfSOmfO7QDbPciyZaWLHsTj9/8O4QuQ4T6pU=;
	b=YyOXuaMbOK8STZBAOFjRXkl8Xuj0vtr6DcWkUdIGwBthVm9zMyJDfpbHLCaeP1wt59YR
	 MondLasA0xzUbzfmHcwITnO+5vNXrQ9RRMpqkUkWcv5oaw6OPteYHyZmOjfZGaouLyN2B
	 lGahsXxxs3ywVC2+PsmFJftfr0vWSevPgru8Gy8Mu/KFVtEbuiwkA5BFGrysukBVsPAJ/
	 +AvOxHTMSzH1/yThyo/4D36aK65T76TN3EaCqxdRjjIbwahiohshpGub+6WZR/HTbrXjy
	 GiK7mYsBKs7BoqW1uNIturQ5vKjq2nxRljaMJWyX+8MzziElyojiUvKltPocthCzkkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=LBKrDqA+;
	arc=none smtp.remote-ip=203.254.224.33
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E663A606A323
	for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2026 02:15:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E663A606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=LBKrDqA+
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20261027021454epoutp03d45405eb12c828d84e2c4d3215dce1fd~iQTQuGVb21771517715epoutp03D
	for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2026 02:14:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20261027021454epoutp03d45405eb12c828d84e2c4d3215dce1fd~iQTQuGVb21771517715epoutp03D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793067294;
	bh=r/ih1FRvfSOmfO7QDbPciyZaWLHsTj9/8O4QuQ4T6pU=;
	h=From:To:Cc:Subject:Date:References:From;
	b=LBKrDqA+Bt5IVXuwI1IcW8kNbSc8vQbrTc6GqNEGsM7CVMUxWuMyKhQ9DRdPRUpVw
	 tHdh0KrbGigc/m9KEEyZW+tfUXTxbaLflO5SyXAwkZ6HKq+P+702cZxARokaQg/J+4
	 YywJQhpGc4iY96kitz5Xd2IV6fXfhewGcoPsoYk0=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPS id
	20261027021453epcas2p28f51b1d20d1019d8cbbfad208984efd1~iQTQWG61U3121731217epcas2p2H;
	Tue, 27 Oct 2026 02:14:53 +0000 (GMT)
Received: from epcas2p4.samsung.com (unknown [182.195.38.204]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4jDDbK1kgCz3hhT7; Tue, 27 Oct
	2026 02:14:53 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
	20261027021452epcas2p1f71a25c723df847d76cd114ce7afabaa~iQTPbqUs11825818258epcas2p1N;
	Tue, 27 Oct 2026 02:14:52 +0000 (GMT)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.81.221.204]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20261027021452epsmtip2b378fe92584083c91083387acfbb1a46~iQTPWge012996629966epsmtip2r;
	Tue, 27 Oct 2026 02:14:52 +0000 (GMT)
From: HOYOUNG SEO <hy50.seo@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
	martin.petersen@oracle.com, bvanassche@acm.org, kwangwon.min@samsung.com,
	kwmad.kim@samsung.com, cpgs@samsung.com, h10.kim@samsung.com
Cc: HOYOUNG SEO <hy50.seo@samsung.com>
Subject: [PATCH v5] scsi: ufs: Change the error check sequence for auto
 hibern8
Date: Tue, 27 Oct 2026 11:10:37 +0900
Message-Id: <20261027021037.3398180-1-hy50.seo@samsung.com>
X-Mailer: git-send-email 2.34.1
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
X-CMS-MailID: 20261027021452epcas2p1f71a25c723df847d76cd114ce7afabaa
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-234,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261027021452epcas2p1f71a25c723df847d76cd114ce7afabaa
References: <CGME20261027021452epcas2p1f71a25c723df847d76cd114ce7afabaa@epcas2p1.samsung.com>

Auto-hibern8 enter and exit are performed by the host controller without
a UIC command, and the auto-hibern8 idle timer only runs while no UIC
command is outstanding. An auto-hibern8 error (IS.UHES or IS.UHXS) is
therefore usually reported while hba->active_uic_cmd is NULL.

Since commit fcd8b0450a9a ("scsi: ufs: core: Make ufshcd_uic_cmd_compl()
easier to analyze"), ufshcd_uic_cmd_compl() returns early when
hba->active_uic_cmd is NULL, before ufshcd_is_auto_hibern8_error() is
called. Such auto-hibern8 errors are no longer recorded in hba->errors,
so ufshcd_check_errors() is not called for them and the error handler is
not scheduled.

Check for auto-hibern8 errors before checking for an active UIC command,
as was done before that commit, but keep returning early when there is
no active UIC command so that a NULL cmd is never dereferenced. Only
report the missing UIC command if no auto-hibern8 error was found.

Fixes: fcd8b0450a9a ("scsi: ufs: core: Make ufshcd_uic_cmd_compl() easier to analyze")

Signed-off-by: HOYOUNG SEO <hy50.seo@samsung.com>
---
Changes in v5:
 - Fix the unmatched brace in ufshcd_uic_cmd_compl() that broke the build
   in v4 (Stanley Jhu, Sashiko, kernel test robot).
 - Use a local bool for the ufshcd_is_auto_hibern8_error() result instead
   of testing hba->errors (Bart Van Assche).
 - Move the Signed-off-by above the "---" line and Cc stable.
 - Link to all previous versions.

Changes in v4:
 - Changed patch version

Changes in v3:
 - Check auto-hibern8 errors before the NULL check again, so that errors
   reported while a non-hibernate UIC command is active are still
   detected (Sashiko review).
 - Return early when no UIC command is active instead of falling
   through, to avoid dereferencing a NULL cmd (Sashiko review).
 - Add Fixes tag, reword subject and commit message.

Changes in v2:
 - Check UFSHCD_UIC_HIBERN8_MASK for auto-hibern8 only when cmd is NULL.

v1: https://lore.kernel.org/linux-scsi/20261021051951.1687479-1-hy50.seo@samsung.com/
v2: https://lore.kernel.org/linux-scsi/20261022074249.3098100-1-hy50.seo@samsung.com/
v3: https://lore.kernel.org/linux-scsi/20261026051851.1845934-1-hy50.seo@samsung.com/
v4: https://lore.kernel.org/linux-scsi/20261026052632.1848929-1-hy50.seo@samsung.com/

 drivers/ufs/core/ufshcd.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d085d394858f..c08278a2e43e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5939,18 +5939,26 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
 {
 	irqreturn_t retval = IRQ_NONE;
 	struct uic_command *cmd;
+	bool ah8_err;
 
 	guard(spinlock_irqsave)(&hba->host->host_lock);
+
+	/*
+	 * Auto-hibern8 is performed without a UIC command, so check for
+	 * auto-hibern8 errors before checking for an active UIC command.
+	 */
+	ah8_err = ufshcd_is_auto_hibern8_error(hba, intr_status);
+	if (ah8_err)
+		hba->errors |= (UFSHCD_UIC_HIBERN8_MASK & intr_status);
+
 	cmd = hba->active_uic_cmd;
 	if (!cmd) {
-		dev_err(hba->dev,
-			"No active UIC command. Maybe a timeout occurred?\n");
+		if (!ah8_err)
+			dev_err(hba->dev,
+				"No active UIC command. Maybe a timeout occurred?\n");
 		return retval;
 	}
 
-	if (ufshcd_is_auto_hibern8_error(hba, intr_status))
-		hba->errors |= (UFSHCD_UIC_HIBERN8_MASK & intr_status);
-
 	if (intr_status & UIC_COMMAND_COMPL) {
 		/*
 		 * Store the UIC command result in the lowest byte of
-- 
2.34.1

