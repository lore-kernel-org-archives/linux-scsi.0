Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.24
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793931627;
	b=s11iHLM77LN0Pyt3K9+3a4Bgj6Bi5xJQilWmCMU3tj1GZgW5MgKTtrfEFAFyWem8Lshh
	 yR25Lk2xcAJHTikPXQIDI0P4mg1s7Agfni7Tadfu/+hh3wnuM6jN7RP6T+m0p86kStKe/
	 8mjqGXwjwfR0tMxPfB18ggfgYA/kNUhRopyDA+dhPO6Yvlkl+ZU9tMe1kyVTwcMwATP5V
	 qNXTnBpcUlxJBpzkXUnXcUvakg9OK6/DfkfeASk6zNJyjafB2vITuPSh1LYDkiMlp+Mfb
	 jbo4inMBQmgYDk/fTZgVS8RLWLfUsnj4LOK7IQ49vGb5ILAi13xF99kuBGpf+yV+XDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793931627;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:X-Sendblock-Type:CMS-TYPE:X-CPGSPASS:
	 cpgsPolicy:X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=rfy9NXbU2lNKJVMFxDHV9X5u8HMSdn5x4FOQMZSGgv4=;
	b=2yfwXsyytr0nu1MnV3z3UWo/9asWCECt/sAgPeqrnnslvP/oma/NB00/e3LLU+wW33z8
	 KQMD5Kw1w0zPjuxNX1rKfja4GfBocopMttIsiHibtdQCOqxb2AWiYib91keTrVHA9fE/J
	 Oyeyi+xb+dIbaInFH39qqe+TGwQZoI2dGn7qtMYLa7VQzeVJlnbwHn2zrf86YJSmGNuNe
	 XX2c+eD5zO+OCK05vG8dhbmaE5GGKrrFFr4SOchWifd7MtbR6418dKF4mxom09FFLB/YF
	 g09VrY8KQPwL6tLZQQi9IWVtm9mIgDwftRzmCY08eOEYvBjZRMHXAy+aReoVcw3wIGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=D3BeoSXA;
	arc=none smtp.remote-ip=203.254.224.24
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C950D606A33F
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 02:20:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C950D606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=D3BeoSXA
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20261106022022epoutp01140c48c87bb9f70556d0b0cd026dfedf~lU05KAQqA1979219792epoutp01g
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 02:20:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20261106022022epoutp01140c48c87bb9f70556d0b0cd026dfedf~lU05KAQqA1979219792epoutp01g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793931622;
	bh=rfy9NXbU2lNKJVMFxDHV9X5u8HMSdn5x4FOQMZSGgv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D3BeoSXAFF9SWFk1YYCPHAoY97AWuX15DGlXZONvGeOFGOw1L+d4XqI/Bk8yOGyzI
	 nzJ2347kr4aVAbnabtmDVqLvJGoj4tqjnrOUJaZ7B5geJ4JjZ9oXWObZDV8zo2QcYd
	 bTZXvpWxa0aa2YBXrg9T6iuBUWwwxBheDi9Nvpf4=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPS id
	20261106022021epcas2p19b9cc90a5cfcad735761e909183feecc~lU04t48Bb0857208572epcas2p1c;
	Fri,  6 Nov 2026 02:20:21 +0000 (GMT)
Received: from epcas2p2.samsung.com (unknown [182.195.38.206]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4jLNF13FjXz6B9m7; Fri,  6 Nov
	2026 02:20:21 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
	20261106022020epcas2p2af29bc4d81ede559c5a74076721aba7f~lU0328CaX2787827878epcas2p2_;
	Fri,  6 Nov 2026 02:20:20 +0000 (GMT)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.81.221.204]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261106022020epsmtip175a458cf2e2bf04420295375e6c12b76~lU03xiXes0408404084epsmtip1v;
	Fri,  6 Nov 2026 02:20:20 +0000 (GMT)
From: HOYOUNG SEO <hy50.seo@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	bvanassche@acm.org, mkp@kernel.org, martin.petersen@oracle.com,
	stanleyjhu@google.com, alim.akhtar@samsung.com, kwangwon.min@samsung.com,
	kwmad.kim@samsung.com, cpgs@samsung.com, h10.kim@samsung.com
Cc: HOYOUNG SEO <hy50.seo@samsung.com>
Subject: [PATCH v6 2/3] scsi: ufs: core: Limit early link recovery in the
 error handler to runtime PM
Date: Fri,  6 Nov 2026 11:15:52 +0900
Message-Id: <e25861e1983785d6d96e4db40f6c175bc3d091d1.1793931113.git.hy50.seo@samsung.com>
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
X-CMS-MailID: 20261106022020epcas2p2af29bc4d81ede559c5a74076721aba7f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-234,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261106022020epcas2p2af29bc4d81ede559c5a74076721aba7f
References: <cover.1793931113.git.hy50.seo@samsung.com>
	<CGME20261106022020epcas2p2af29bc4d81ede559c5a74076721aba7f@epcas2p2.samsung.com>

ufshcd_err_handler() recovers the link without taking hba->host_sem
whenever hba->pm_op_in_progress is set. That early path was added by
commit f966e02ae521 ("scsi: ufs: core: Fix runtime suspend error
deadlock") because the regular error handling would wait for a runtime
PM operation that cannot complete while the error handler is waiting.

pm_op_in_progress is also set during system suspend, system resume and
shutdown, where the early path is not needed and runs concurrently with
the PM path itself. For example, if a LINERESET is reported and the
hibern8 exit fails in __ufshcd_wl_resume() during system resume, both
ufshcd_err_handler() and __ufshcd_wl_resume() call
ufshcd_link_recovery(), and the host and the device may be reset at the
same time.

Only take the early path while a runtime PM operation is in progress.
For the other PM operations the regular error handling is safe:

  - the system PM callbacks hold host_sem from ufshcd_wl_suspend() until
    ufshcd_wl_resume() returns, so the error handler waits for them;
  - during shutdown and poweroff, hba->shutting_down makes the error
    handler stop.

Since pm_op_in_progress does not tell which PM operation is running, add
hba->runtime_pm_in_progress. It is set in ufshcd_wl_runtime_suspend() and
ufshcd_wl_runtime_resume() around the PM operation, so it covers
pm_op_in_progress for runtime PM and is never set for the other PM
operations. The error handler tests only this flag.

Fixes: e23ef4f22db3 ("scsi: ufs: core: Fix error handler host_sem issue")
Signed-off-by: HOYOUNG SEO <hy50.seo@samsung.com>
---
 drivers/ufs/core/ufshcd.c | 11 ++++++++++-
 include/ufs/ufshcd.h      |  2 ++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 3b5580ac390c..95beb95bb036 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7091,9 +7091,14 @@ static void ufshcd_err_handler(struct work_struct *work)
 		 * runtime resume. This avoids potential deadlocks that could
 		 * happen if we tried to resume the device while a PM operation
 		 * is already in progress.
+		 *
+		 * Do not do this for system PM, shutdown and poweroff. The
+		 * system PM callbacks hold host_sem, and shutting_down makes
+		 * the regular path below stop, so it does not reset the link
+		 * concurrently with them.
 		 */
 		ufshcd_rpm_get_noresume(hba);
-		if (hba->pm_op_in_progress) {
+		if (hba->runtime_pm_in_progress) {
 			ufshcd_link_recovery(hba);
 			ufshcd_rpm_put(hba);
 			return;
@@ -10678,11 +10683,13 @@ static int ufshcd_wl_runtime_suspend(struct device *dev)
 	ktime_t start = ktime_get();
 
 	hba = shost_priv(sdev->host);
+	hba->runtime_pm_in_progress = true;
 
 	ret = __ufshcd_wl_suspend(hba, UFS_RUNTIME_PM);
 	if (ret)
 		dev_err(&sdev->sdev_gendev, "%s failed: %d\n", __func__, ret);
 
+	hba->runtime_pm_in_progress = false;
 	trace_ufshcd_wl_runtime_suspend(hba, ret,
 		ktime_to_us(ktime_sub(ktime_get(), start)),
 		hba->curr_dev_pwr_mode, hba->uic_link_state);
@@ -10698,11 +10705,13 @@ static int ufshcd_wl_runtime_resume(struct device *dev)
 	ktime_t start = ktime_get();
 
 	hba = shost_priv(sdev->host);
+	hba->runtime_pm_in_progress = true;
 
 	ret = __ufshcd_wl_resume(hba, UFS_RUNTIME_PM);
 	if (ret)
 		dev_err(&sdev->sdev_gendev, "%s failed: %d\n", __func__, ret);
 
+	hba->runtime_pm_in_progress = false;
 	trace_ufshcd_wl_runtime_resume(hba, ret,
 		ktime_to_us(ktime_sub(ktime_get(), start)),
 		hba->curr_dev_pwr_mode, hba->uic_link_state);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index be62165b785e..8b5bfc83fea2 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -974,6 +974,7 @@ enum ufshcd_mcq_opr {
  * @spm_lvl: desired UFS power management level during system PM.
  * @pm_lvl_min: minimum supported power management level.
  * @pm_op_in_progress: whether or not a PM operation is in progress.
+ * @runtime_pm_in_progress: whether or not a runtime PM operation is in progress.
  * @ahit: value of Auto-Hibernate Idle Timer register.
  * @outstanding_tasks: Bits representing outstanding task requests
  * @outstanding_lock: Protects @outstanding_reqs.
@@ -1129,6 +1130,7 @@ struct ufs_hba {
 	enum ufs_pm_level spm_lvl;
 	enum ufs_pm_level pm_lvl_min;
 	int pm_op_in_progress;
+	bool runtime_pm_in_progress;
 
 	/* Auto-Hibernate Idle Timer register value */
 	u32 ahit;
-- 
2.34.1

