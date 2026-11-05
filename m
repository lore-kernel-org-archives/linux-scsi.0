Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.24
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793852450;
	b=URvFNVYiw9Dhswvv5ZhvgLtgEyeGj7noiYD6n2HCsvTguVZU7TYhOKBATMu0uwARCwGQ
	 TdEwMvjnCxY0YrNbivdhOtGPEEdZIMLWbwN6aM+sYaJZedZLG8G+JwrtQZPehER2Tcv2P
	 g/6KQ3k/LRwXVn5fR3ajazWMY6/Ygh0Hb/Rd+5Gvv0IoK/Z33XNAnMZ4QXHM8p79l8smX
	 QnuNVTNwrtjJpQYPlY8dnQrI+1f40XQ22zBVJ32DBcRXwriKN6SBHYsBKRbXTVppdzdv2
	 lNHD4taYqhosE5stcMKq5u4CCgZHecuotjijI3o7aABPTnbP29Cxb4NVlQl94IFxmsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793852450;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:X-Sendblock-Type:CMS-TYPE:X-CPGSPASS:
	 cpgsPolicy:X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=pRrhKbxUqOQ7WsUjlPChh4VnRtGtJUITfOp89eByEWE=;
	b=FuIAMRvX9jPJQlftCCK7zeb3yY8hafnIudIPzm3PtEEiCgw/rrARrwNKH0ZctAT2XZzc
	 lu6OMy8XHD0g4x8DvSVeDpZWwimvO2NKk8ZFiNT0kw/EJcFcZPIA4p5EptN6KbxzHtFNj
	 QQRzi7V4YYxHdUiawa+qam7VmfbggfAcPbCIlcLG08U3825/ZW7Pu1T4I9oRu4xhTXEh3
	 ifj/KGHT6WAAfS+wJp8xG1jXmieSvncy2gylBJw8S7vRVeiu4PphU7+8yiwVoGxd4o3I3
	 2BDJ57uy7B6Ut3/d/gTpTMrC4h5nvfKjOlUKI+dyRNb2+k2qgfqyrGbup1HAoGQxNVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=HKzj1XdU;
	arc=none smtp.remote-ip=203.254.224.24
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA53606D80B
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 04:20:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9BA53606D80B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=HKzj1XdU
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20261105042045epoutp016f8f9f76209ec15b9ccc5d8b3cc9cc35~lC0tssk521255812558epoutp01m
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 04:20:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20261105042045epoutp016f8f9f76209ec15b9ccc5d8b3cc9cc35~lC0tssk521255812558epoutp01m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793852445;
	bh=pRrhKbxUqOQ7WsUjlPChh4VnRtGtJUITfOp89eByEWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HKzj1XdUQt/KzAF8ulkkat4mAWpQIb6QLE4og1UCTc//fi1jAD6HP7Gr+m04xAAoO
	 q4SAcZNM+kOJwEELiQy/wSfHzlcWe9WWe1uCQG9CdL0stg5Ty5/t8MsiZjVmN6h4vS
	 u7cHo8VExRY3tcors46mGYz39lyORoB+RHAqq+Pw=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPS id
	20261105042044epcas2p20f275d649eae04b0859073c30a02b12d~lC0tMXS3g2943429434epcas2p2H;
	Thu,  5 Nov 2026 04:20:44 +0000 (GMT)
Received: from epcas2p2.samsung.com (unknown [182.195.38.199]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4jKpyN1nrbz6B9mL; Thu,  5 Nov
	2026 04:20:44 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
	20261105042043epcas2p2b8a95dde8509fcf59aebad3be2116bce~lC0sQYzOK2941429414epcas2p2N;
	Thu,  5 Nov 2026 04:20:43 +0000 (GMT)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.81.221.204]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261105042043epsmtip13f4875163d44ac16db6198626a3f7367~lC0sL7rRl2504825048epsmtip1e;
	Thu,  5 Nov 2026 04:20:43 +0000 (GMT)
From: HOYOUNG SEO <hy50.seo@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	bvanassche@acm.org, mkp@kernel.org, martin.petersen@oracle.com,
	stanleyjhu@google.com, alim.akhtar@samsung.com, kwangwon.min@samsung.com,
	kwmad.kim@samsung.com, cpgs@samsung.com, h10.kim@samsung.com
Cc: HOYOUNG SEO <hy50.seo@samsung.com>
Subject: [PATCH v4 2/2] scsi: ufs: core: Limit early link recovery in the
 error handler to runtime PM
Date: Thu,  5 Nov 2026 13:16:17 +0900
Message-Id: <a5f3b13e7c2ae3cb39dfd078e637fd6c4424356e.1793851432.git.hy50.seo@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1793851432.git.hy50.seo@samsung.com>
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
X-CMS-MailID: 20261105042043epcas2p2b8a95dde8509fcf59aebad3be2116bce
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-234,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261105042043epcas2p2b8a95dde8509fcf59aebad3be2116bce
References: <cover.1793851432.git.hy50.seo@samsung.com>
	<CGME20261105042043epcas2p2b8a95dde8509fcf59aebad3be2116bce@epcas2p2.samsung.com>

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
  - during shutdown, hba->shutting_down makes the error handler stop.

Since pm_op_in_progress does not tell which PM operation is running, add
hba->runtime_pm_in_progress and set it in __ufshcd_wl_suspend() and
__ufshcd_wl_resume().

Fixes: e23ef4f22db3 ("scsi: ufs: core: Fix error handler host_sem issue")
Signed-off-by: HOYOUNG SEO <hy50.seo@samsung.com>
---
 drivers/ufs/core/ufshcd.c | 14 +++++++++++---
 include/ufs/ufshcd.h      |  2 ++
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 3b5580ac390c..e3908d6af3ae 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7089,11 +7089,15 @@ static void ufshcd_err_handler(struct work_struct *work)
 		 * Use ufshcd_rpm_get_noresume() here to safely perform link
 		 * recovery even if an error occurs during runtime suspend or
 		 * runtime resume. This avoids potential deadlocks that could
-		 * happen if we tried to resume the device while a PM operation
-		 * is already in progress.
+		 * happen if we tried to resume the device while a runtime PM
+		 * operation is already in progress.
+		 *
+		 * Do not do this for system PM and shutdown. The system PM
+		 * callbacks hold host_sem, so the regular path below runs
+		 * after them instead of resetting the link concurrently.
 		 */
 		ufshcd_rpm_get_noresume(hba);
-		if (hba->pm_op_in_progress) {
+		if (hba->runtime_pm_in_progress) {
 			ufshcd_link_recovery(hba);
 			ufshcd_rpm_put(hba);
 			return;
@@ -10393,6 +10397,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	enum uic_link_state req_link_state;
 
 	hba->pm_op_in_progress = true;
+	hba->runtime_pm_in_progress = (pm_op == UFS_RUNTIME_PM);
 	if (pm_op != UFS_SHUTDOWN_PM) {
 		pm_lvl = pm_op == UFS_RUNTIME_PM ?
 			 hba->rpm_lvl : hba->spm_lvl;
@@ -10565,6 +10570,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		hba->clk_gating.is_suspended = false;
 		ufshcd_release(hba);
 	}
+	hba->runtime_pm_in_progress = false;
 	hba->pm_op_in_progress = false;
 	return ret;
 }
@@ -10576,6 +10582,7 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	enum uic_link_state old_link_state = hba->uic_link_state;
 
 	hba->pm_op_in_progress = true;
+	hba->runtime_pm_in_progress = (pm_op == UFS_RUNTIME_PM);
 
 	/*
 	 * Call vendor specific resume callback. As these callbacks may access
@@ -10666,6 +10673,7 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		ufshcd_update_evt_hist(hba, UFS_EVT_WL_RES_ERR, (u32)ret);
 	hba->clk_gating.is_suspended = false;
 	ufshcd_release(hba);
+	hba->runtime_pm_in_progress = false;
 	hba->pm_op_in_progress = false;
 	return ret;
 }
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

