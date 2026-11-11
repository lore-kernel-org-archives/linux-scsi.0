Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794387791;
	b=VYfTfqXzaM2arSi0m1OCgxcMVcjf1/QtbHLLgWe8/O1EDINNF+9TpDZOAwTz/wOMPwEG
	 OiCso+rRjrUSULEew422jZ+hktExZhxSSlqXfpSFtLP69jLrV1f26xhZpKnzbZUC6C8qz
	 gZetUESOW9tXgNYLKepcWEnmvgl4c3h26ZRGSsvekzHhy8gGR2QA97VH/P3ca9Zy4PHpK
	 WI9FC7vd4fMSugLFzp4sx7iToopbWU88yJV0rHNzqp0Y4G08XW30C7iVUK6mXgbozTR/s
	 nBZBAn+8dydGkSbICi6WU8k/WWCQjxXQB+xcz6Lb+hDmKH8yjMCG6Hdms2/FJLs/OVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794387791;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:X-Sendblock-Type:CMS-TYPE:X-Hop-Count:
	 X-CMS-RootMailID:References;
	bh=WIXypDaeLt9BYY2kmleUSUOPj853+XhZ28yVSVEaQno=;
	b=o8xkWkPgdmL8jRs+nuV69fB/SDFpYgEF4bGDc9HVMqgAjhj7cuf7bcBPWvAJzI+QpVJB
	 iKl7QXPLnt7GbF2OIAKAFiCN6tkgPMZlpDt/8FQ4XTytAo/VFRoV94cchX8g7WKYdAP2a
	 +asz4JIVVnxSfM+YUc17AL6fxorUe2VVZYIt2hVZaUqkorSKEaWaoJXmuGmaGAvjGogkH
	 gl4iH2xfTmYQuUSUlnijXL4mbSi/WwPzPra/ajjKJtyAJG3/PgqAu32tOD46GFk18cqgj
	 y0jbrLUy9+8ftGHUUOO/ZoyhnGE4j4+i1/tBTuthIAk93XxxtORfZjqbgz/5JXn2lIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=hVUSjJuO;
	arc=none smtp.remote-ip=203.254.224.34
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25FD0606A32D
	for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 09:03:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 25FD0606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=hVUSjJuO
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20261111090307epoutp0410aecaf357403bff8df4f8f1d472c703~m8i_gp-QE2239422394epoutp04U
	for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 09:03:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20261111090307epoutp0410aecaf357403bff8df4f8f1d472c703~m8i_gp-QE2239422394epoutp04U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1794387787;
	bh=WIXypDaeLt9BYY2kmleUSUOPj853+XhZ28yVSVEaQno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hVUSjJuOYkq/LQoglJr7BU5RXBRu87E7yIP6AhGQqx47ycqZuZXvvmtruA6Hijz2B
	 r/GzgoSFeBILNPT2q2gx8SCcwkYMDTjc5wYoH7l83FQf1/smSBfi8neNerlrf1N097
	 E2kBwc4kjUOyHgTqYOzm3g5Uefo8BSmO/tGZuYe0=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPS id
	20261111090307epcas2p4c6f584454c3b71f6fcbec729f9f8794c~m8i_O0rZp1310813108epcas2p4K;
	Wed, 11 Nov 2026 09:03:07 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4jPcxR4DWJz6B9m4; Wed, 11 Nov
	2026 09:03:07 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
	20261111082307epcas2p3b1376d94048de0aa228515860e892641~m8ACpqCUm0607806078epcas2p3k;
	Wed, 11 Nov 2026 08:23:07 +0000 (GMT)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.81.221.204]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20261111082307epsmtip2e45813de586a586e94d8dd0fc9c0278b~m8ACkI7CR1487414874epsmtip2L;
	Wed, 11 Nov 2026 08:23:07 +0000 (GMT)
From: HOYOUNG SEO <hy50.seo@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	bvanassche@acm.org, mkp@kernel.org, martin.petersen@oracle.com,
	stanleyjhu@google.com, peter.wang@mediatek.com, alim.akhtar@samsung.com,
	kwangwon.min@samsung.com, kwmad.kim@samsung.com, cpgsproxy1@samsung.com,
	h10.kim@samsung.com
Cc: HOYOUNG SEO <hy50.seo@samsung.com>
Subject: [PATCH v10 4/4] scsi: ufs: core: Limit early link recovery in the
 error handler to runtime PM
Date: Wed, 11 Nov 2026 17:18:34 +0900
Message-Id: <282821294.121794387787588.JavaMail.epsvc@epcpadp2new>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1794384665.git.hy50.seo@samsung.com>
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
X-CMS-MailID: 20261111082307epcas2p3b1376d94048de0aa228515860e892641
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Hop-Count: 3
X-CMS-RootMailID: 20261111082307epcas2p3b1376d94048de0aa228515860e892641
References: <cover.1794384665.git.hy50.seo@samsung.com>
	<CGME20261111082307epcas2p3b1376d94048de0aa228515860e892641@epcas2p3.samsung.com>

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

Only take the early path while pm_op_in_progress is set and a runtime
suspend or resume of the WLUN is in progress. The runtime PM core sets
the runtime status of the WLUN to RPM_SUSPENDING or RPM_RESUMING while
ufshcd_wl_runtime_suspend() or ufshcd_wl_runtime_resume() runs, and it
is RPM_ACTIVE or RPM_SUSPENDED during system PM. The runtime status
alone is not enough: it also covers the block layer steps before and
after the driver callbacks, where the early link recovery must not run.
pm_op_in_progress is only set while __ufshcd_wl_suspend() or
__ufshcd_wl_resume() run, which is inside that window.

Both checks are done in the new function ufshcd_in_wl_rpm_callback().
The runtime status is only available with CONFIG_PM, so the function
returns false without it. Both values are read without locking, so use
READ_ONCE() for them and WRITE_ONCE() when pm_op_in_progress is
updated. As the window of pm_op_in_progress is contained in the runtime
PM window, a stale value of either one can only make the error handler
take the regular path, like an error handler that starts just before or
after the PM operation.

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
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 8aea99f5c364..09c8095141e2 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7062,6 +7062,23 @@ static bool ufshcd_abort_all(struct ufs_hba *hba)
 	return ret != 0;
 }
 
+/*
+ * Whether a runtime PM callback of the WLUN runs __ufshcd_wl_suspend() or
+ * __ufshcd_wl_resume().
+ */
+static bool ufshcd_in_wl_rpm_callback(struct ufs_hba *hba)
+{
+#ifdef CONFIG_PM
+	enum rpm_status status =
+		READ_ONCE(hba->ufs_device_wlun->sdev_gendev.power.runtime_status);
+
+	return READ_ONCE(hba->pm_op_in_progress) &&
+	       (status == RPM_SUSPENDING || status == RPM_RESUMING);
+#else
+	return false;
+#endif
+}
+
 /**
  * ufshcd_err_handler - handle UFS errors that require s/w attention
  * @work: pointer to work structure
@@ -7091,9 +7108,14 @@ static void ufshcd_err_handler(struct work_struct *work)
 		 * runtime resume. This avoids potential deadlocks that could
 		 * happen if we tried to resume the device while a PM operation
 		 * is already in progress.
+		 *
+		 * Do this only while the PM callbacks run for a runtime PM
+		 * operation. The system PM and poweroff callbacks hold
+		 * host_sem, and shutting_down makes the regular path below
+		 * stop, so it does not reset the link concurrently with them.
 		 */
 		ufshcd_rpm_get_noresume(hba);
-		if (hba->pm_op_in_progress) {
+		if (ufshcd_in_wl_rpm_callback(hba)) {
 			ufshcd_link_recovery(hba);
 			ufshcd_rpm_put(hba);
 			return;
@@ -10392,7 +10414,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	enum ufs_dev_pwr_mode req_dev_pwr_mode;
 	enum uic_link_state req_link_state;
 
-	hba->pm_op_in_progress = true;
+	WRITE_ONCE(hba->pm_op_in_progress, true);
 	if (pm_op != UFS_SHUTDOWN_PM) {
 		pm_lvl = pm_op == UFS_RUNTIME_PM ?
 			 hba->rpm_lvl : hba->spm_lvl;
@@ -10565,7 +10587,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		hba->clk_gating.is_suspended = false;
 		ufshcd_release(hba);
 	}
-	hba->pm_op_in_progress = false;
+	WRITE_ONCE(hba->pm_op_in_progress, false);
 	return ret;
 }
 
@@ -10575,7 +10597,7 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	int ret;
 	enum uic_link_state old_link_state = hba->uic_link_state;
 
-	hba->pm_op_in_progress = true;
+	WRITE_ONCE(hba->pm_op_in_progress, true);
 
 	/*
 	 * Call vendor specific resume callback. As these callbacks may access
@@ -10666,7 +10688,7 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		ufshcd_update_evt_hist(hba, UFS_EVT_WL_RES_ERR, (u32)ret);
 	hba->clk_gating.is_suspended = false;
 	ufshcd_release(hba);
-	hba->pm_op_in_progress = false;
+	WRITE_ONCE(hba->pm_op_in_progress, false);
 	return ret;
 }
 
-- 
2.34.1


