Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.25
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792989706;
	b=CJow5XoWuo/BCsxAeBPJ8NPef9dVaeXV83x2XVtkuaqqScPfh5M8SkH0nqjKz9HvPm0R
	 AWLi6vYvx8O4xmtIuYMZZE7gvBQfTC60f3akZ62SHqRJnWVtvNqkocvUcljGtjW6IAOMU
	 0z0SP+JK6D3f7YFNYrlBiN9D81wtQ/GB0Ss81SlI6e/hkL8sfquO3D6DA4K7+luXfNPA6
	 qyBUljRVuQlEgiDBaQv4EUNPOZxuLpdhnTnQqhy963Q/l5TFUtcMAnXByXGvhhUxqLFAY
	 Q9Rd7T4QhkgyprOcnwTLKIzvyqnDAfA6Ob01nFvKN0VcfdXrm7LyViM+pPQKQeXuRdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792989706;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:X-Sendblock-Type:CMS-TYPE:X-CPGSPASS:
	 cpgsPolicy:X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=fMk4REBh2xnlyfRTAlZZe/9at8WMGk5t4jrouM3C5pI=;
	b=ISLsjO58EcETTYRpBtVecy+3q+PhXgY9fGy3+RhmhNhGqCjaHc0zMhWQsm2k3p9s2asN
	 bRIsAstnZEhB0SLRht+1dFo/IpetIN1wKRMJl9M470dqoTQYs0NA8ryXrQm3ysD5NFyxO
	 yP8xsJYGHvOovf4k3j0Q/MwiTVlDtgXKhbmQhVeLs4pa6LHUH/7YivxP6nwRDyuUKDXXm
	 MiC0ynO0rHtWgQq7xsm9baMb/eOn3Z+CdVPBAocZRTRNmJ+7E2JUcDoiW9sV4RaZaaJ+T
	 nXW6s0yzXswzc4D9EUUXhoKILOi1oMW9XTr+gS+ERzQm+LI0vSyLVIG7L5PTjDNX2tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=TqRtT29Q;
	arc=none smtp.remote-ip=203.254.224.25
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C0A606A329
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 04:41:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12C0A606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=TqRtT29Q
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20261026044143epoutp02d911b2f575226291beebeba8ec8d3fc9~h_qK-VNmd2377623776epoutp02V
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 04:41:43 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20261026044143epoutp02d911b2f575226291beebeba8ec8d3fc9~h_qK-VNmd2377623776epoutp02V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1792989703;
	bh=fMk4REBh2xnlyfRTAlZZe/9at8WMGk5t4jrouM3C5pI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TqRtT29Qq9upQuz7KdEwVgcFhc6lKSuFI6BKmpCvu/eWOTstA76L/pUKFsFLonXvD
	 ClbekGjTbmoKkhHqtSSVw5SUgmrfH/XaJCNDVf8a2FVsVWOMjVdG+rsq9KFVajD7TV
	 7v+WhO8QDtIef4yB8wrcawHKvtVsqKLtQ5M78F4M=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPS id
	20261026044141epcas2p20ef9b9d633b3c36fa4f5700f2b1f79f7~h_qJbJh561708417084epcas2p22;
	Mon, 26 Oct 2026 04:41:41 +0000 (GMT)
Received: from epcas2p3.samsung.com (unknown [182.195.38.211]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4jCgv94LYvz2SSKh; Mon, 26 Oct
	2026 04:41:41 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
	20261026044140epcas2p3e83872a5701a30853937a40e16511e49~h_qIjdlr-1810118101epcas2p3I;
	Mon, 26 Oct 2026 04:41:40 +0000 (GMT)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.81.221.204]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261026044140epsmtip1098365324e86f6a4d30cedae51cd2d91~h_qIeo4KG2136321363epsmtip1L;
	Mon, 26 Oct 2026 04:41:40 +0000 (GMT)
From: HOYOUNG SEO <hy50.seo@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
	martin.petersen@oracle.com, bvanassche@acm.org, kwangwon.min@samsung.com,
	kwmad.kim@samsung.com, cpgs@samsung.com, h10.kim@samsung.com
Cc: HOYOUNG SEO <hy50.seo@samsung.com>
Subject: [PATCH v3 2/2] scsi: ufs: core: add is_sys_suspended state before
 recovery
Date: Mon, 26 Oct 2026 13:37:21 +0900
Message-Id: <f21bbc546949a60332bda5b144c95a6b379eb2cb.1792989286.git.hy50.seo@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1792989286.git.hy50.seo@samsung.com>
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
X-CMS-MailID: 20261026044140epcas2p3e83872a5701a30853937a40e16511e49
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-234,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261026044140epcas2p3e83872a5701a30853937a40e16511e49
References: <cover.1792989286.git.hy50.seo@samsung.com>
	<CGME20261026044140epcas2p3e83872a5701a30853937a40e16511e49@epcas2p3.samsung.com>

If a LINERESET is reported and the hibern8 exit fails in
__ufshcd_wl_resume() during system resume, the link is recovered twice:

  - the UIC error interrupt schedules eh_work, and ufshcd_err_handler()
    calls ufshcd_link_recovery() because hba->pm_op_in_progress is set;
  - __ufshcd_wl_resume() calls ufshcd_link_recovery() itself after the
    hibern8 exit failure.

Since the early recovery path in ufshcd_err_handler() does not take
hba->host_sem, the two recoveries are not serialized and may reset the
host and the device concurrently.

During system resume, hba->host_sem is held from ufshcd_wl_suspend()
until ufshcd_wl_resume() returns, so the error handler can simply wait
for it. Skip the early link recovery when hba->is_sys_suspended is set.

Once host_sem is released, ufshcd_err_handler() decides as usual with
ufshcd_err_handling_should_stop(). With the previous patch, the errors
already recovered by the resume path are cleared, so it stops unless new
errors occurred. If the resume failed before any recovery was done, the
pending errors are still set and it runs the regular error handling. If
the recovery in the resume path failed, the HBA is in
UFSHCD_STATE_ERROR and the error handler does not retry.

The early link recovery added by commit f966e02ae521 ("scsi: ufs: core:
Fix runtime suspend error deadlock") is kept for runtime PM, where
host_sem is not held and the error handler cannot wait for the PM
operation to finish.

Signed-off-by: HOYOUNG SEO <hy50.seo@samsung.com>
---
 drivers/ufs/core/ufshcd.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 74dfbb98129e..d085d394858f 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7053,9 +7053,14 @@ static void ufshcd_err_handler(struct work_struct *work)
 		 * runtime resume. This avoids potential deadlocks that could
 		 * happen if we tried to resume the device while a PM operation
 		 * is already in progress.
+		 *
+		 * During system resume, host_sem is held from
+		 * ufshcd_wl_suspend() until ufshcd_wl_resume() returns, so wait
+		 * for it below instead of recovering the link concurrently with
+		 * the resume path.
 		 */
 		ufshcd_rpm_get_noresume(hba);
-		if (hba->pm_op_in_progress) {
+		if (hba->pm_op_in_progress && !hba->is_sys_suspended) {
 			ufshcd_link_recovery(hba);
 			ufshcd_rpm_put(hba);
 			return;
-- 
2.34.1

