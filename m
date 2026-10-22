Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.33
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792655227;
	b=ZAaisZoVsX49V+t+PVka4VwCaCfixe16M6kUbj+rxerMFAjf4aNnDNXQiGqZuhXJ5ysJ
	 cbpcfFSUB/n33EAFydcR94Eaq3Dflrgz5G8748knmPQWRUGyXRkockoEudMFEyEXS0yl6
	 A/ioMAJ1wLconuQLxTX1/ktUVmhwISOkb2TRexlPXafwtrwWERlsalK747dPSCYxFNNmO
	 AGR4KoRgpxWPw1AsfpCwX5C/Zo7rkCPjNLOGO4H9uCIprJXl0nPZOLHsbwRob1LTNTPJZ
	 vnoQQ7OJkW4HG+lBR6OFh1n46bN8gvua4IMtzk3ra2P5lCOl1cLRSn2NKrEQrVEvuEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792655227;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:X-Msg-Generator:
	 Content-Type:X-Sendblock-Type:CMS-TYPE:X-CPGSPASS:cpgsPolicy:
	 X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=gJ02LIvxF1ifnlAv7EHEIQzP2zf0VPjR+gsStL0r5os=;
	b=bDhT/yCi0BZA5tPS9tRE0NvR05Zyw/6MlgQzIusN0GjoTntn2G6ZAiafV2BKELg29xSh
	 X+IIcl2v91ZpEzC7FrphDFzrR0q+DME40hFbzjSUFu36WYKgLD/5Ko83yQ0MzVm8mNN6+
	 HRJKLMi9/B2tBI9wUgT22AmKEwOUABrZ5bhNf1NdsN9LaVlF1w5we2Sus6PviDFvnluw+
	 2gOGu9QoOkimFcF0affCocuuxG9/H3q6UnIyUMSq+KoavK8FcoVCaqqdBRN6bOJ2wtqkv
	 PuFknrp8IXE2qDZtkCTbdRLmTzrJKo9K8yx2gQAWVTzGtEixixqt32v96Y1E4jhTCEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=OjveYjYn;
	arc=none smtp.remote-ip=203.254.224.33
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F8D606A31D
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 07:47:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D9F8D606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=OjveYjYn
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20261022074703epoutp03e87955fa15d51484c95f865542155a90~gym2VVrqw3271632716epoutp03P
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 07:47:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20261022074703epoutp03e87955fa15d51484c95f865542155a90~gym2VVrqw3271632716epoutp03P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1792655223;
	bh=gJ02LIvxF1ifnlAv7EHEIQzP2zf0VPjR+gsStL0r5os=;
	h=From:To:Cc:Subject:Date:References:From;
	b=OjveYjYnTTRFMny3uMd3AQo/0B1n1+MYTUKkEZYcjyWAzakVGON76tUTbNzHHQZXO
	 1pxR8RDlxDnipf91I52CgPg7Pnr7mut9Y3cdGY7pNGwvl6WuAVHyprvHaKqjkNr9s7
	 RiqXjqmOave4MqdKaDGmS0BldJv37Z1MgNpDoYVk=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPS id
	20261022074703epcas2p255117754149f1d3e039a9797963317d4~gym1tW1eF0625106251epcas2p2H;
	Thu, 22 Oct 2026 07:47:03 +0000 (GMT)
Received: from epcas2p4.samsung.com (unknown [182.195.38.201]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4j9JBt3StMz2SSKY; Thu, 22 Oct
	2026 07:47:02 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
	20261022074701epcas2p30b1d22790ff85d4179d38bda18184575~gym0D8Oac1303713037epcas2p3E;
	Thu, 22 Oct 2026 07:47:01 +0000 (GMT)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.81.221.204]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20261022074701epsmtip2fbc1beebc9051edeb82966278995d551~gymz7woug2133621336epsmtip2N;
	Thu, 22 Oct 2026 07:47:01 +0000 (GMT)
From: HOYOUNG SEO <hy50.seo@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
	martin.petersen@oracle.com, bvanassche@acm.org, kwangwon.min@samsung.com,
	kwmad.kim@samsung.com, cpgs@samsung.com, h10.kim@samsung.com
Cc: HOYOUNG SEO <hy50.seo@samsung.com>
Subject: [PATCH v2] scsi: ufs: Change the error check sequence for auto
 hibern8
Date: Thu, 22 Oct 2026 16:42:49 +0900
Message-Id: <20261022074249.3098100-1-hy50.seo@samsung.com>
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
X-CMS-MailID: 20261022074701epcas2p30b1d22790ff85d4179d38bda18184575
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-234,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261022074701epcas2p30b1d22790ff85d4179d38bda18184575
References: <CGME20261022074701epcas2p30b1d22790ff85d4179d38bda18184575@epcas2p3.samsung.com>

In the case of auto hibern8, hibern8 entering or exiting occurs
without a cmd, so it is not correct to check
for the presence of a cmd before checking for auto hibern8 errors.
Thus, the order of the auto hibern8 error check changed.

Change in v2:
 - changed to check UFSHCD_UIC_HIBERN8_MASK for auto hibern
 only when cmd is null.
Separated from the case of cmd, there will be no problem
in the normal processing situation of cmd.
In the case of retval, when UFSHCD_UIC_HIBERN8_MASK is set,
the ufshcd_check_errors() function is performed
by hba->error and IRQ_HANDLED is set in the retval.

Signed-off-by: HOYOUNG SEO <hy50.seo@samsung.com>
---
 drivers/ufs/core/ufshcd.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index bcc2512bf34b..4f4380c93ce7 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5930,14 +5930,15 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
 	guard(spinlock_irqsave)(&hba->host->host_lock);
 	cmd = hba->active_uic_cmd;
 	if (!cmd) {
-		dev_err(hba->dev,
-			"No active UIC command. Maybe a timeout occurred?\n");
-		return retval;
+		if (ufshcd_is_auto_hibern8_error(hba, intr_status)) {
+			hba->errors |= (UFSHCD_UIC_HIBERN8_MASK & intr_status);
+		} else {
+			dev_err(hba->dev,
+				"No active UIC command. Maybe a timeout occurred?\n");
+			return retval;
+		}
 	}
 
-	if (ufshcd_is_auto_hibern8_error(hba, intr_status))
-		hba->errors |= (UFSHCD_UIC_HIBERN8_MASK & intr_status);
-
 	if (intr_status & UIC_COMMAND_COMPL) {
 		/*
 		 * Store the UIC command result in the lowest byte of
-- 
2.34.1

