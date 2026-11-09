Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.33
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794200287;
	b=KKbzblKD3pHZ5Pys8Mdy+wBZ0G4/42GEfWcFbHA3Lb2zYZTrJ/E3liHdr/8eV/VQkFef
	 JKJVXAa9+ie5N1qTjjBS0wnlusU0fH8b0WUbJr4CHpq/WfQyH6w7IZuq2YOucNKVyylbo
	 xD396D2NJHglPN2GL2XSfGtPf0Rpx8fShb9PZ5qlqdcsUwK3r70NgF0XWm9NKStjBDAXC
	 B41l7XKZRj+sVNzkw//mCXj/qpztvoQBGQZwfJv+IEPw/lF1o3pxDaY/pVuIEs0fnp395
	 t60QBL7l0F7gOM4bN2p6gxOE8RNEx+xZYWdWTRvmllBzB738+hDfSrm92FSXcqlKO5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794200287;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:X-Sendblock-Type:CMS-TYPE:X-CPGSPASS:
	 X-Hop-Count:X-CMS-RootMailID:References;
	bh=/gL92kk0pPsmx77woySNE4lM5lKJ04JXgYDTqF4TWWc=;
	b=NxWnLAFhY9mQQDat4/A/9DwQaq0qGarc+expSCkJL+CVomtGv8ojT4j49q5kGfwclxga
	 Rar9ysvW6SmiQrJdut2hBqNWavZfG6bELU+jcfau/q5EKLFDcA87dPnj6Ts11tSwKYhBE
	 buLmZkIWQbZeMbI3GqvveDaIkagA8etHH7xqVQBAiBg1ehXIiWuZkEPtFSizU/FbxnFFV
	 axcezqH32hBooJf8z8La2vvx0goggAOwR7482zvzgYQ7v5W7uoyLpxQ2MLx67d+b0kbVj
	 lROAJPIVYY2QWthqATAkPAkGW3IVC8tNAebn1tXbPzpJ979ABKuGSGMq4Ty1NgknpyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=cGyyKPC6;
	arc=none smtp.remote-ip=203.254.224.33
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69E4606A325
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 04:58:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C69E4606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=cGyyKPC6
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20261109045804epoutp037c8df6c61d4640618cb9ecb7275c62d3~mR6cGNScb1342913429epoutp03R
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 04:58:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20261109045804epoutp037c8df6c61d4640618cb9ecb7275c62d3~mR6cGNScb1342913429epoutp03R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1794200284;
	bh=/gL92kk0pPsmx77woySNE4lM5lKJ04JXgYDTqF4TWWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cGyyKPC6ANk3ETlJE2D6XLZmTsVN/hodLD+ROD0wvZIRg6h3uz9YnHwCpS18p0dp9
	 BrIqKytRNsT6DMFuitUaStx+RoCMbUq++D/Kid9uF+wiLlIQhWa4//IB04gSs8WVnK
	 WcTRBb+DM8E/+lh5JSU9U/OqLMCDwGFZtdYl40JU=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPS id
	20261109045803epcas2p4018ec7962f09b66981249230f3e490ce~mR6bn1plv1777717777epcas2p4U;
	Mon,  9 Nov 2026 04:58:03 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4jNHbb4yC2z6B9mS; Mon,  9 Nov
	2026 04:58:03 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
	20261109041348epcas2p1a8518c19bea8a58c57e8538809d2a947~mRTylJm8o2701327013epcas2p1Y;
	Mon,  9 Nov 2026 04:13:48 +0000 (GMT)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.81.221.204]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261109041348epsmtip1c02dd4285ebf7e97e3c54ad7574d9ffe~mRTyggfZN2715127151epsmtip1I;
	Mon,  9 Nov 2026 04:13:48 +0000 (GMT)
From: HOYOUNG SEO <hy50.seo@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	bvanassche@acm.org, mkp@kernel.org, martin.petersen@oracle.com,
	stanleyjhu@google.com, peter.wang@mediatek.com, alim.akhtar@samsung.com,
	kwangwon.min@samsung.com, kwmad.kim@samsung.com, cpgs@samsung.com,
	h10.kim@samsung.com
Cc: HOYOUNG SEO <hy50.seo@samsung.com>
Subject: [PATCH v8 3/3] scsi: ufs: core: Limit early link recovery in the
 error handler to runtime PM
Date: Mon,  9 Nov 2026 13:09:17 +0900
Message-Id: <2052256418.81794200283664.JavaMail.epsvc@epcpadp2new>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1794196863.git.hy50.seo@samsung.com>
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
X-CMS-MailID: 20261109041348epcas2p1a8518c19bea8a58c57e8538809d2a947
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20261109041348epcas2p1a8518c19bea8a58c57e8538809d2a947
References: <cover.1794196863.git.hy50.seo@samsung.com>
	<CGME20261109041348epcas2p1a8518c19bea8a58c57e8538809d2a947@epcas2p1.samsung.com>

ufshcd_err_handler() recovers the link without taking hba->host_sem
whenever hba->pm_op_in_progress is set. That early path was added by
commit f966e02ae521 ("scsi: ufs: core: Fix runtime suspend error
deadlock") because the regular error handling would wait for a runtime
PM operation that cannot complete while the error handler is waiting.

pm_op_in_progress is also set during system suspend, system resume,
shutdown and poweroff, where the early path is not needed and runs
concurrently with the PM path itself. For example, if a LINERESET is
reported and the hibern8 exit fails in __ufshcd_wl_resume() during
system resume, both ufshcd_err_handler() and __ufshcd_wl_resume() call
ufshcd_link_recovery(), and the host and the device may be reset at the
same time.

Only take the early path while a runtime suspend or resume of the WLUN
is in progress. The runtime PM core sets the runtime status of the WLUN
to RPM_SUSPENDING or RPM_RESUMING while ufshcd_wl_runtime_suspend() or
ufshcd_wl_runtime_resume() runs, and it is RPM_ACTIVE or RPM_SUSPENDED
during system PM. Read it with READ_ONCE() without power.lock held in
the new helper ufshcd_rpm_transition_in_progress(), next to the other
ufshcd_rpm_*() helpers. The status is only available with CONFIG_PM, so
the helper returns false without it.

For the other PM operations the regular error handling is safe:

  - the system PM callbacks hold host_sem from ufshcd_wl_suspend() until
    ufshcd_wl_resume() returns, and ufshcd_wl_poweroff() holds it as
    well, so the error handler waits for them;
  - during shutdown, hba->shutting_down makes the error handler stop.

This changes the behavior during shutdown: errors that occur while the
final START STOP UNIT command is being processed are no longer handled
by the error handler. Recovery then only happens through
ufshcd_eh_timed_out().

Fixes: e23ef4f22db3 ("scsi: ufs: core: Fix error handler host_sem issue")
Signed-off-by: HOYOUNG SEO <hy50.seo@samsung.com>
---
 drivers/ufs/core/ufshcd-priv.h | 13 +++++++++++++
 drivers/ufs/core/ufshcd.c      |  7 ++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index e55c2a02c1f5..ae3eaf5ab017 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -413,6 +413,19 @@ static inline void ufshcd_rpm_put(struct ufs_hba *hba)
 	pm_runtime_put(&hba->ufs_device_wlun->sdev_gendev);
 }
 
+/* Whether a runtime suspend or resume of the WLUN is in progress. */
+static inline bool ufshcd_rpm_transition_in_progress(struct ufs_hba *hba)
+{
+#ifdef CONFIG_PM
+	enum rpm_status status =
+		READ_ONCE(hba->ufs_device_wlun->sdev_gendev.power.runtime_status);
+
+	return status == RPM_SUSPENDING || status == RPM_RESUMING;
+#else
+	return false;
+#endif
+}
+
 /**
  * ufs_is_valid_unit_desc_lun - checks if the given LUN has a unit descriptor
  * @dev_info: pointer of instance of struct ufs_dev_info
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 1c935a8d016d..a79951cfcb29 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7091,9 +7091,14 @@ static void ufshcd_err_handler(struct work_struct *work)
 		 * runtime resume. This avoids potential deadlocks that could
 		 * happen if we tried to resume the device while a PM operation
 		 * is already in progress.
+		 *
+		 * Do this only while a runtime PM operation is in progress. The
+		 * system PM and poweroff callbacks hold host_sem, and
+		 * shutting_down makes the regular path below stop, so it does
+		 * not reset the link concurrently with them.
 		 */
 		ufshcd_rpm_get_noresume(hba);
-		if (hba->pm_op_in_progress) {
+		if (ufshcd_rpm_transition_in_progress(hba)) {
 			ufshcd_link_recovery(hba);
 			ufshcd_rpm_put(hba);
 			return;
-- 
2.34.1


