Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.33
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793945752;
	b=FxGkI92dY3Mv+m43H2/ftWOhZ57bxqBINobSaNQ5dXPIZhW5l+Lvz1xZdRnK6XTH96sH
	 VQvKVMaoLSuJBRFeT7GCD7JiBkMrHfKsnSpUXQlv9e2Bcy0C/qAQvsJfD/SRSJmEZRyQd
	 gT4Wx3YEhHsB3opqRfMEL0RsQKXgyg64kSVKNgrkEXFR1sxXPP+SLopwLRyc8oz8G7USm
	 W8xswFwToW+IER+SwFrD4VEuaYuNNh9zX9mctPrM4Mt92jhZPN6n5070pTVwRJshkQWda
	 cmqgC2hReaXm4b9shjPDGwbKv76JdsHxcIGdbcJBdhtZGd7TxmL9EfI5lf3F/mIy0eQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793945752;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:X-Sendblock-Type:CMS-TYPE:X-CPGSPASS:
	 cpgsPolicy:X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=v7fwbcB+j3qArALJwbFSNMgaYPsy1n7sC1I4igR5Fcs=;
	b=I5ZsHGDq0/G4TwQRCZbbklAbSdxRFh2p8SaOhs7jPwVErKoIUpNmkNzL/44YgjmeTGVm
	 nY9Fi5nsJCV7ab4ulVEMELicJJoyUKN3BMJdQSoPuAkb3F7SzTL0Cz/n7hLVYBQxja55x
	 h3T/e8rDnT0GceR99ByrIas4NN+H2qXRXrxmyaOJ2vAIXo1p4wM8FjmfdRVq+bt0xb+Xj
	 F5G7MkxlPR4RYvq4shLu1OtHACYYDH9Uh7dBjG4e00yzi8rXk88GG5ts+Mz1d4ZoYPDS7
	 AFSFW8+tJQqw3TAy9LX1II/XsjiCE3LFV3pKR5kRrMWp7pbmo8kVHBGlb4OwH3jXWqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=V462ND7X;
	arc=none smtp.remote-ip=203.254.224.33
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05FE5606A33F
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 06:15:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 05FE5606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=V462ND7X
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20261106061548epoutp033d916c21bacb98894a569ef93eb1aa1a~lYCdrUngS1974319743epoutp03N
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 06:15:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20261106061548epoutp033d916c21bacb98894a569ef93eb1aa1a~lYCdrUngS1974319743epoutp03N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793945749;
	bh=v7fwbcB+j3qArALJwbFSNMgaYPsy1n7sC1I4igR5Fcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V462ND7XRW5OpUG09uwc+/Y7dE/MsuVUodx8Ko5EabA4gxH1SAbSDDpIrTvABQwnh
	 XfEBgF0DheTideJu+RqgM4YVT2O24rki6TOd+pjCU69OJXKdn7mlDSh80CNBcUVGBl
	 cfu2IVbaQMIjs2YD0dQn+vtbkrK08kMHe/JIprlU=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPS id
	20261106061548epcas2p10bded25d72b3cdd6f23f70a9ded73e7d~lYCdUXIsB1875718757epcas2p1P;
	Fri,  6 Nov 2026 06:15:48 +0000 (GMT)
Received: from epcas2p2.samsung.com (unknown [182.195.38.209]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4jLTSh1cwVz6B9mB; Fri,  6 Nov
	2026 06:15:48 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
	20261106061547epcas2p40541421c139d758cdc3633302634d29b~lYCcbrb6o0226002260epcas2p4I;
	Fri,  6 Nov 2026 06:15:47 +0000 (GMT)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.81.221.204]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261106061547epsmtip1fb31b06665099cc6938723bc2059b776~lYCcXeRz20434704347epsmtip1I;
	Fri,  6 Nov 2026 06:15:47 +0000 (GMT)
From: HOYOUNG SEO <hy50.seo@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	bvanassche@acm.org, mkp@kernel.org, martin.petersen@oracle.com,
	stanleyjhu@google.com, alim.akhtar@samsung.com, kwangwon.min@samsung.com,
	kwmad.kim@samsung.com, cpgs@samsung.com, h10.kim@samsung.com
Cc: HOYOUNG SEO <hy50.seo@samsung.com>
Subject: [PATCH v7 3/3] scsi: ufs: core: Limit early link recovery in the
 error handler to runtime PM
Date: Fri,  6 Nov 2026 15:11:18 +0900
Message-Id: <66ffa35908823d693cde364ef6fbdeef50aa5a69.1793943246.git.hy50.seo@samsung.com>
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
X-CMS-MailID: 20261106061547epcas2p40541421c139d758cdc3633302634d29b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-234,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261106061547epcas2p40541421c139d758cdc3633302634d29b
References: <cover.1793943246.git.hy50.seo@samsung.com>
	<CGME20261106061547epcas2p40541421c139d758cdc3633302634d29b@epcas2p4.samsung.com>

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

Only take the early path while a runtime PM operation is in progress.
For the other PM operations the regular error handling is safe:

  - the system PM callbacks hold host_sem from ufshcd_wl_suspend() until
    ufshcd_wl_resume() returns, and ufshcd_wl_poweroff() holds it as
    well, so the error handler waits for them;
  - during shutdown, hba->shutting_down makes the error handler stop.

This changes the behavior during shutdown: errors that occur while the
final START STOP UNIT command is being processed are no longer handled
by the error handler. Recovery then only happens through
ufshcd_eh_timed_out().

Since pm_op_in_progress does not tell which PM operation is running, add
hba->runtime_pm_in_progress. It is set in ufshcd_wl_runtime_suspend() and
ufshcd_wl_runtime_resume() around the PM operation, so it covers
pm_op_in_progress for runtime PM and is never set for the other PM
operations. The error handler tests only this flag. It is accessed
without locking, so use READ_ONCE() and WRITE_ONCE().

Fixes: e23ef4f22db3 ("scsi: ufs: core: Fix error handler host_sem issue")
Signed-off-by: HOYOUNG SEO <hy50.seo@samsung.com>
---
 drivers/ufs/core/ufshcd.c | 11 ++++++++++-
 include/ufs/ufshcd.h      |  2 ++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 1c935a8d016d..3d748974e753 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7091,9 +7091,14 @@ static void ufshcd_err_handler(struct work_struct *work)
 		 * runtime resume. This avoids potential deadlocks that could
 		 * happen if we tried to resume the device while a PM operation
 		 * is already in progress.
+		 *
+		 * Do not do this for system PM, shutdown and poweroff. The
+		 * system PM and poweroff callbacks hold host_sem, and
+		 * shutting_down makes the regular path below stop, so it
+		 * does not reset the link concurrently with them.
 		 */
 		ufshcd_rpm_get_noresume(hba);
-		if (hba->pm_op_in_progress) {
+		if (READ_ONCE(hba->runtime_pm_in_progress)) {
 			ufshcd_link_recovery(hba);
 			ufshcd_rpm_put(hba);
 			return;
@@ -10678,11 +10683,13 @@ static int ufshcd_wl_runtime_suspend(struct device *dev)
 	ktime_t start = ktime_get();
 
 	hba = shost_priv(sdev->host);
+	WRITE_ONCE(hba->runtime_pm_in_progress, true);
 
 	ret = __ufshcd_wl_suspend(hba, UFS_RUNTIME_PM);
 	if (ret)
 		dev_err(&sdev->sdev_gendev, "%s failed: %d\n", __func__, ret);
 
+	WRITE_ONCE(hba->runtime_pm_in_progress, false);
 	trace_ufshcd_wl_runtime_suspend(hba, ret,
 		ktime_to_us(ktime_sub(ktime_get(), start)),
 		hba->curr_dev_pwr_mode, hba->uic_link_state);
@@ -10698,11 +10705,13 @@ static int ufshcd_wl_runtime_resume(struct device *dev)
 	ktime_t start = ktime_get();
 
 	hba = shost_priv(sdev->host);
+	WRITE_ONCE(hba->runtime_pm_in_progress, true);
 
 	ret = __ufshcd_wl_resume(hba, UFS_RUNTIME_PM);
 	if (ret)
 		dev_err(&sdev->sdev_gendev, "%s failed: %d\n", __func__, ret);
 
+	WRITE_ONCE(hba->runtime_pm_in_progress, false);
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

