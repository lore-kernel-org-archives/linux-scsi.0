Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.33
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792755555;
	b=J2Hzen3bEoSRQXqAlmSg+nRUg/nvQnehXjBQF1ybBzi8cVfS5+yxwBniz5XjAprkq2uT
	 NH+pc3biSiaMxYZFhqVbZaIciYSIBDFmjH1t6kz2wbcDQYDdkhvy3p3dal13fdYxE7Hgh
	 kGVwXBUA9oXKIM+11haC/3kGVHcXwzIim3kIDkcYaTeoA8YhYaxVZZOYxO+PjoQizwU5a
	 4/8L19xireb+AkaLGEgQcx3dkSLEG9eL/ZVwAa954iEvseFCWMIsOeqaraLknE4cxF/Gj
	 PiMnQD3/JqFOM0Qk45FNqqvAxCAuF2lKqc9o0nfVpwCDgNxVP9nwJhgQScOxeXzitvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792755555;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:X-Sendblock-Type:CMS-TYPE:X-CPGSPASS:
	 cpgsPolicy:X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=/fb3/Y827A4wnDd72mGaRpwXygPAZ1ef7pQ3wEqp0qY=;
	b=RBGCogDJVrWj3m+TtF+UpnxhtsSGPg1EVR89Fz8eSUkpQOtQrkoQDcn7wEBrmdLYQKYc
	 rx5Cc9sWhNqOUEOqu1lJSds8DBstS/5TNx2I91rPtfUr3ohA45xHs0b795VQPCXBojEsV
	 35EatbcvGNmRpPoW122PhXqFWwAwYKXEGfq5mnUtMdMm1yfKTy4ikxrWK4PnychDIhkMP
	 Mqke08ya33saNQ1/36SCgut5ujwbn0UY0aCk7FrGaXkaH6HoRMBzEP63opLx2CPylLPmq
	 EiwAX4FzFGM2lU1wcgN4yL7xCE2ULM4SLrHgEUA6DQGNERG6faUp3XtpKnJo8MxegIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=d5W0DJFC;
	arc=none smtp.remote-ip=203.254.224.33
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94D4606A31D
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 11:39:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E94D4606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=d5W0DJFC
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20261023113913epoutp03c55ebaa05fd023d8453a28b439a149b9~hJa1aBMvq1754317543epoutp03P
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 11:39:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20261023113913epoutp03c55ebaa05fd023d8453a28b439a149b9~hJa1aBMvq1754317543epoutp03P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1792755553;
	bh=/fb3/Y827A4wnDd72mGaRpwXygPAZ1ef7pQ3wEqp0qY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d5W0DJFCiQgSxHVb2fC8910BS/HeOLmlpy3ptNVIcose0ug/HwgI8HiIxsbyUr5k3
	 XBzEhbMANtEVGT5rlQawOTlVr4fCCdt46J7Pb1YnHdABgSJoMfAf8tEB0ssgTu+SKJ
	 GW/+E/XaX347dQFo+oxB4zE2wwVyPtHNqecSA+jg=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPS id
	20261023113912epcas2p318e7a3183db0a436162965ed83263a06~hJa04IcTq2175721757epcas2p3C;
	Fri, 23 Oct 2026 11:39:12 +0000 (GMT)
Received: from epcas2p1.samsung.com (unknown [182.195.38.200]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4jB1JJ2X8Fz2SSKZ; Fri, 23 Oct
	2026 11:39:12 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
	20261023113911epcas2p44c986c4542ca8bae511086ef4b2ad850~hJa0N-gVy1753517535epcas2p4s;
	Fri, 23 Oct 2026 11:39:11 +0000 (GMT)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.81.221.204]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261023113911epsmtip15f887e05dd69b3dbec4dc4763bbc647e~hJa0J2Jqr2560225602epsmtip1U;
	Fri, 23 Oct 2026 11:39:11 +0000 (GMT)
From: HOYOUNG SEO <hy50.seo@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
	martin.petersen@oracle.com, bvanassche@acm.org, kwangwon.min@samsung.com,
	kwmad.kim@samsung.com, cpgs@samsung.com, h10.kim@samsung.com
Cc: HOYOUNG SEO <hy50.seo@samsung.com>
Subject: [PATCH v2 2/2] scsi: ufs: core: add is_sys_suspended state before
 recovery
Date: Fri, 23 Oct 2026 20:34:52 +0900
Message-Id: <4eabe38e93631579a0cacda137a98053526fe030.1792755091.git.hy50.seo@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1792755091.git.hy50.seo@samsung.com>
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
X-CMS-MailID: 20261023113911epcas2p44c986c4542ca8bae511086ef4b2ad850
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-234,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261023113911epcas2p44c986c4542ca8bae511086ef4b2ad850
References: <cover.1792755091.git.hy50.seo@samsung.com>
	<CGME20261023113911epcas2p44c986c4542ca8bae511086ef4b2ad850@epcas2p4.samsung.com>

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
With the previous patch, the errors already recovered by the resume path
are cleared, so ufshcd_err_handler() stops once host_sem is released
unless new errors occurred. If the resume failed, is_sys_suspended stays
set and the error handler performs a full recovery as usual.

The early link recovery is kept for runtime PM, where host_sem is not
held and the error handler cannot wait for the PM operation to finish.

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

