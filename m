Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794277213;
	b=eY++dI05RPP/ESiVnm9y9XkwySi6LPM791PlPWlseMBS9aaOz+CsoQjr52DWCUFFRTWN
	 xMiOYrt4m2hFgZk6p3mDfuaWeRr04tiCRDlCZvV0BAMzA+JQp5v1YhXQDyTmosU1SgrmW
	 5ZfJivYO22j03tfIsK+B2FqgUxtyIYKhETLjyJp3X1F0/SjgYuRtq8UNIoZEPfaplKx9Y
	 86F8cvTQBs5jLtOJ/vZRJaxtDcNTFp2QkCaBkWgfQb84D5TztmIbj0oWUI8eV7DJZjigK
	 5BlkYCLWCbZiMnUxPBB5aPCa//1nFo3aQ3KLRyfJbC2u2pRL38Z2NfANMhrlNlcHDOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794277213;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:X-Sendblock-Type:CMS-TYPE:X-Hop-Count:
	 X-CMS-RootMailID:References;
	bh=XO1z7eseE1mYc0cwIiXmRUi03coF13n0S5aDopHgx00=;
	b=vF96e7N4isERiRLJqLn0pwX4YCbc3GxPUFbQadbJFymDlhIv+xfj1NZ7XQrun6T4ep64
	 +nSKLbqk+h01ZAZ7gqfdhhhrYCLVc+KgKzpnRZHs0la4XWwEFzlEvi0ixOSVwRpLmNZuV
	 yD84Zrp0W7MslA1H5k59NXViyqaC7VWX1FLfk1mqOLrKPseTYz9ZpSx2pdcAQEv5hfKtj
	 /o+BGT2s6F73WEapXxoJmN5QcNqRn17sUinCdC0JSdMAR+Eigz6s7UrtUpEcw6in78Ajd
	 yoInlRYf/tW9l0/gRYPNgQ9DjgprG13g/vwZZcXgNIftGmgJrXR7QhvwpFo09pSzzgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=CxK+EUKG;
	arc=none smtp.remote-ip=203.254.224.34
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2E4606A31C
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 02:20:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A2E4606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=CxK+EUKG
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20261110022003epoutp041843dc989db7c3e108dc4ecc61a4aa6a~mjZxKrV2g0483404834epoutp04E
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 02:20:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20261110022003epoutp041843dc989db7c3e108dc4ecc61a4aa6a~mjZxKrV2g0483404834epoutp04E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1794277204;
	bh=XO1z7eseE1mYc0cwIiXmRUi03coF13n0S5aDopHgx00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CxK+EUKG2QfK6R6henAxUkCucSIfD0E7NS1p4fGDrpxo+7Xxw3NmI0/ENIHUVm8Rt
	 8zQaedh7WcsFV1L92isV6LMwH2OAoM5vVdJRqNoZ8YvRIbmu2JmX0GwEt1DXQ7gYr7
	 8cmruBvaHinDfugL4Ma/qGQSsBkituCValy1cuzQ=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPS id
	20261110022003epcas2p1a35b9ac5e3ca97b7f0b4be41f7b43992~mjZwuJjIi1253412534epcas2p1K;
	Tue, 10 Nov 2026 02:20:03 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4jNr2q38q3z6B9m6; Tue, 10 Nov
	2026 02:20:03 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
	20261110020748epcas2p25076a34f183116ca4d8714dacf214958~mjPD9LqcK1166111661epcas2p2c;
	Tue, 10 Nov 2026 02:07:48 +0000 (GMT)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.81.221.204]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261110020748epsmtip1b81dc34b6fb0f48a152a07b40b32c29a~mjPD31Ba73263232632epsmtip1k;
	Tue, 10 Nov 2026 02:07:48 +0000 (GMT)
From: HOYOUNG SEO <hy50.seo@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	bvanassche@acm.org, mkp@kernel.org, martin.petersen@oracle.com,
	stanleyjhu@google.com, peter.wang@mediatek.com, alim.akhtar@samsung.com,
	kwangwon.min@samsung.com, kwmad.kim@samsung.com, cpgsproxy1@samsung.com,
	h10.kim@samsung.com
Cc: HOYOUNG SEO <hy50.seo@samsung.com>
Subject: [PATCH v9 3/3] scsi: ufs: core: Limit early link recovery in the
 error handler to runtime PM
Date: Tue, 10 Nov 2026 11:03:15 +0900
Message-Id: <2052256418.81794277203434.JavaMail.epsvc@epcpadp1new>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1794275305.git.hy50.seo@samsung.com>
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
X-CMS-MailID: 20261110020748epcas2p25076a34f183116ca4d8714dacf214958
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Hop-Count: 3
X-CMS-RootMailID: 20261110020748epcas2p25076a34f183116ca4d8714dacf214958
References: <cover.1794275305.git.hy50.seo@samsung.com>
	<CGME20261110020748epcas2p25076a34f183116ca4d8714dacf214958@epcas2p2.samsung.com>

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

Both checks are done in the new helper
ufshcd_rpm_transition_in_progress(), next to the other ufshcd_rpm_*()
helpers. The runtime status is read with READ_ONCE() and without
power.lock held. It is only available with CONFIG_PM, so the helper
returns false without it. Both values are read without locking. As the
window of pm_op_in_progress is contained in the runtime PM window, a
stale value of either one can only make the error handler take the
regular path, like an error handler that starts just before or after
the PM operation.

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
 drivers/ufs/core/ufshcd-priv.h | 17 +++++++++++++++++
 drivers/ufs/core/ufshcd.c      |  7 ++++++-
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index e55c2a02c1f5..8cd9fabc4c02 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -413,6 +413,23 @@ static inline void ufshcd_rpm_put(struct ufs_hba *hba)
 	pm_runtime_put(&hba->ufs_device_wlun->sdev_gendev);
 }
 
+/*
+ * Whether __ufshcd_wl_suspend() or __ufshcd_wl_resume() runs for a runtime
+ * suspend or resume of the WLUN.
+ */
+static inline bool ufshcd_rpm_transition_in_progress(struct ufs_hba *hba)
+{
+#ifdef CONFIG_PM
+	enum rpm_status status =
+		READ_ONCE(hba->ufs_device_wlun->sdev_gendev.power.runtime_status);
+
+	return hba->pm_op_in_progress &&
+	       (status == RPM_SUSPENDING || status == RPM_RESUMING);
+#else
+	return false;
+#endif
+}
+
 /**
  * ufs_is_valid_unit_desc_lun - checks if the given LUN has a unit descriptor
  * @dev_info: pointer of instance of struct ufs_dev_info
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 0d86c67f0b1a..0cca33d59065 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7091,9 +7091,14 @@ static void ufshcd_err_handler(struct work_struct *work)
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
+		if (ufshcd_rpm_transition_in_progress(hba)) {
 			ufshcd_link_recovery(hba);
 			ufshcd_rpm_put(hba);
 			return;
-- 
2.34.1


