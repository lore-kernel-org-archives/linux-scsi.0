Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.24
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793931639;
	b=lVwvLLRxS6T6FY5HjbvuIRdio/RqjSqJbKlbs4tCgkQVFZQwKn86yVyeEwC0E2NcQPMq
	 0EVzEakvmBaizluWXXZPVveq6eto5Q3tRuLGUp0jVIJu+jDLqkQBiDgS6nwqtPhvf6FPW
	 bGLmSlpvPjAqVeldxP/daCPg5MtMHJ9xWUyzwhEw9oqzo97fPDWESqa7YmcvoZwnY7cK3
	 0TjFPUTFR5DqmQGSizBKIAWHRimUuqO7gfLhd3c9Nzpq1WofORWLb13v0Dw3OPFFtsL+V
	 w8pgGX7/mT5GKm1KQLQRBGbCx3RyL2UiincotlCaRPDfT7uXo2CPVOcqONWi1T6vuow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793931639;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:X-Sendblock-Type:CMS-TYPE:X-CPGSPASS:
	 cpgsPolicy:X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=MZKaMktugBAXwZw8hjvmkbkgozIKruWx23/wUHTIGAg=;
	b=ssSK2zOG6V7VedyfUQcVcuwWWhLVjp+MaqyTmODPS7nWc8VGTJdU3VTgXwOwsAhS7y8v
	 UhQjP29nQIjbD5iapYU/zZkvoeRo1PgXxhCwzWifoQ+g+vKDgOvm5yQtJaDoLPDTuq/LH
	 MxIAWvyoFacmwt8TfQCR0qF7Dgeay8qBZK66916AmURlzTCgMuYPbqzlnq67T5VlHjDGo
	 M+3c/zkh+1C5Kavn54a8MjnYS7YnPkYFaJWZitMynunXd/wcdS10utKamj4VWdC7+8NVr
	 O5sMlR4P1iRWtnivvpyG9li0DayvIx2sTurRohRhudZSQG74ugMG6yh/VI/hDaJ4hHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=mjZuQjXK;
	arc=none smtp.remote-ip=203.254.224.24
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1C9606A338
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 02:20:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9E1C9606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=mjZuQjXK
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20261106022023epoutp0131b1912859e907d8cf17fd7a575c6503~lU056QOJv1979219792epoutp01i
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 02:20:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20261106022023epoutp0131b1912859e907d8cf17fd7a575c6503~lU056QOJv1979219792epoutp01i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793931623;
	bh=MZKaMktugBAXwZw8hjvmkbkgozIKruWx23/wUHTIGAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mjZuQjXKurxuUC8hnhVrLAulaEfPV57vJbUb62IH9w7jdSJwe5ou5G+PP/QWfrht8
	 7iHDSVN+k7to3sMwN+c9aHvyukjKFwuisbz/uh3en/13bKpnEaT0i4HnEyCa5tActu
	 cakwlOfviR7o+d9DN1AWunwqiEmqCHg0M+ZJwpPI=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPS id
	20261106022022epcas2p3cc2ae667471eda1c6089735149705a87~lU05X1IgA0947409474epcas2p3-;
	Fri,  6 Nov 2026 02:20:22 +0000 (GMT)
Received: from epcas2p1.samsung.com (unknown [182.195.38.202]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4jLNF22DqTz3hhT9; Fri,  6 Nov
	2026 02:20:22 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
	20261106022021epcas2p20d78ac51e55f03348d496f45e96031e1~lU04pLqto2787827878epcas2p2G;
	Fri,  6 Nov 2026 02:20:21 +0000 (GMT)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.81.221.204]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261106022021epsmtip1a4929d9c6492f47a1e103f93adbc18b5~lU04iPpFt0408404084epsmtip1w;
	Fri,  6 Nov 2026 02:20:21 +0000 (GMT)
From: HOYOUNG SEO <hy50.seo@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	bvanassche@acm.org, mkp@kernel.org, martin.petersen@oracle.com,
	stanleyjhu@google.com, alim.akhtar@samsung.com, kwangwon.min@samsung.com,
	kwmad.kim@samsung.com, cpgs@samsung.com, h10.kim@samsung.com
Cc: HOYOUNG SEO <hy50.seo@samsung.com>
Subject: [PATCH v6 3/3] scsi: ufs: core: Set shutting_down in
 ufshcd_wl_poweroff()
Date: Fri,  6 Nov 2026 11:15:53 +0900
Message-Id: <66845a28b3014bb53b7f1332c258009b80707297.1793931113.git.hy50.seo@samsung.com>
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
X-CMS-MailID: 20261106022021epcas2p20d78ac51e55f03348d496f45e96031e1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-234,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261106022021epcas2p20d78ac51e55f03348d496f45e96031e1
References: <cover.1793931113.git.hy50.seo@samsung.com>
	<CGME20261106022021epcas2p20d78ac51e55f03348d496f45e96031e1@epcas2p2.samsung.com>

ufshcd_wl_shutdown() sets hba->shutting_down under host_sem before it
suspends the device, so that ufshcd_err_handling_should_stop() makes the
error handler return instead of recovering the HBA while it is being shut
down.

ufshcd_wl_poweroff(), which is used for hibernation, also suspends the
device with UFS_SHUTDOWN_PM but neither holds host_sem nor sets
hba->shutting_down. An error handler that runs in the meantime can reset
the link concurrently with __ufshcd_wl_suspend().

Set hba->shutting_down in ufshcd_wl_poweroff() in the same way as
ufshcd_wl_shutdown() does.

Signed-off-by: HOYOUNG SEO <hy50.seo@samsung.com>
---
 drivers/ufs/core/ufshcd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 95beb95bb036..a52d6ccfa56b 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -11583,6 +11583,10 @@ static int ufshcd_wl_poweroff(struct device *dev)
 	struct scsi_device *sdev = to_scsi_device(dev);
 	struct ufs_hba *hba = shost_priv(sdev->host);
 
+	down(&hba->host_sem);
+	hba->shutting_down = true;
+	up(&hba->host_sem);
+
 	__ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM);
 	return 0;
 }
-- 
2.34.1

