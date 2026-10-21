Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792560249;
	b=ctTfrJx4z120lBMY0cUeRUVXdwlOTnf8AZvT4oRc1080XuuZjKk5mFpSJacLOcjLKXVh
	 3YQzApswbuRwAfjfr8iLVvl5zC3gmDe8KTdIWddfaAvtjD5vXh+HeNDRNHba5f8sKG64i
	 7eWOIKQ7jU06r4N+pFqlNZu05RQ55XZA3TQ/x7khIrOxcT4Y7hpMdlVnz0ppUIT+gfRao
	 6a1Uke6ls42Dxqwv447Jx3K99GXj+Tz9elt7a4iJbmNZC8LJqa3OMFjKoZmP5OJuKnceB
	 YUK9/EhLr7jc0LWighFKuglpxQgWu0S0FLNNT7rLyEnZOJl3SWLRsnTSshP2qOaReQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792560249;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:X-Msg-Generator:
	 Content-Type:X-Sendblock-Type:CMS-TYPE:X-CPGSPASS:cpgsPolicy:
	 X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=eueLmUgBHormXL0YdXB8lmaaPSvLGfd8pLaCio6533E=;
	b=4oYiWHMxDDsJIDvJQ32CaZCb34LpAYVoFqSUEZGrxNgk3TyNWNfpHlQSzwbU1uD61ps4
	 MaQOkSufyz3VVOhUo4e0XqnhvKgU01zzgZyuU/4uYIDtsM0TtjehQTG+eVJOfjn+S/ycZ
	 QAs+JZIlYT7xv8rlvGe0ov6acLrkYlgzeYX8z4FYJwlM0hjpOpfkYbX8c4cXTTGGCnoS2
	 xIolzmIngNWX2Ltlx3kbquP3ZIvbRZKr6MVRfmGqZXaAgWG4Vilnuvplkhp0DEo/mQv3D
	 rehVDKjaatCtK6HQs/oOgw7N3zVamrflJOfB+ogHuVDB14S5xNGN9XjRxQbslViGeWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=HbRzwLk+;
	arc=none smtp.remote-ip=203.254.224.34
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2485B606A31E
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 05:24:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2485B606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=HbRzwLk+
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20261021052405epoutp04f939b3e68eb9e57d081a1ae131a5b014~gdAvZsc-u2358223582epoutp04i
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 05:24:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20261021052405epoutp04f939b3e68eb9e57d081a1ae131a5b014~gdAvZsc-u2358223582epoutp04i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1792560245;
	bh=eueLmUgBHormXL0YdXB8lmaaPSvLGfd8pLaCio6533E=;
	h=From:To:Cc:Subject:Date:References:From;
	b=HbRzwLk+aAEvM7Ed11Rn+u72v2ojtBUiSKzaO0CDjIeq10vvy+CdmCAY5Z3D2r7el
	 QctYnTToXqj8RHah5GVRy/M+GoAWu6QUwD5VADAtxwcDnI+20JVKWuTRZzqnyJsCh5
	 5hRs7t1uQRY6d5eJFUUSzZ8I6PNym3mMFtJe38zw=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPS id
	20261021052404epcas2p30c068e388e3a097b351063e822889628~gdAtugqzJ0478904789epcas2p3V;
	Wed, 21 Oct 2026 05:24:04 +0000 (GMT)
Received: from epcas2p2.samsung.com (unknown [182.195.38.212]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4j8d4M6Mppz6B9m7; Wed, 21 Oct
	2026 05:24:03 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
	20261021052403epcas2p43e1a022f46314c1a9d1ffb66502c29eb~gdAs-fzEa2899728997epcas2p4p;
	Wed, 21 Oct 2026 05:24:03 +0000 (GMT)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.81.221.204]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261021052403epsmtip14daee3bd67032b8ce5cada0055d00126~gdAs4KP9X2305023050epsmtip1r;
	Wed, 21 Oct 2026 05:24:03 +0000 (GMT)
From: HOYOUNG SEO <hy50.seo@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
	martin.petersen@oracle.com, bvanassche@acm.org, kwangwon.min@samsung.com,
	kwmad.kim@samsung.com, cpgs@samsung.com, h10.kim@samsung.com
Cc: HOYOUNG SEO <hy50.seo@samsung.com>
Subject: [PATCH v1] scsi: ufs: Change the error check sequence for auto
 hibern8
Date: Wed, 21 Oct 2026 14:19:51 +0900
Message-Id: <20261021051951.1687479-1-hy50.seo@samsung.com>
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
X-CMS-MailID: 20261021052403epcas2p43e1a022f46314c1a9d1ffb66502c29eb
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-234,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261021052403epcas2p43e1a022f46314c1a9d1ffb66502c29eb
References: <CGME20261021052403epcas2p43e1a022f46314c1a9d1ffb66502c29eb@epcas2p4.samsung.com>

In the case of auto hibern8, hibern8 entering or exiting occurs
without a cmd, so it is not correct to check 
for the presence of a cmd before checking for auto hibern8 errors.
Thus, the order of the auto hibern8 error check changed.

Signed-off-by: HOYOUNG SEO <hy50.seo@samsung.com>
---
 drivers/ufs/core/ufshcd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index bcc2512bf34b..c8a70d7d210d 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5928,6 +5928,9 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
 	struct uic_command *cmd;
 
 	guard(spinlock_irqsave)(&hba->host->host_lock);
+	if (ufshcd_is_auto_hibern8_error(hba, intr_status))
+		hba->errors |= (UFSHCD_UIC_HIBERN8_MASK & intr_status);
+
 	cmd = hba->active_uic_cmd;
 	if (!cmd) {
 		dev_err(hba->dev,
@@ -5935,9 +5938,6 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
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

