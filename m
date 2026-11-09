Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.24
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794200287;
	b=Jd2TPVZBJagwtStS6R16yPDOQf2hmIzPFRIkHmv5VMu6as9ns5wYYjZaBOzO19qLaEIL
	 7iCX3CO5JJA7g8JTQl/nt84n6XOGuixh9+HOKys533OJbdNDKSPEsmDSYlV3pXTQ6gIav
	 ptCUsHcVzYUiC+izHktD4O/4bVnQFO4E13rcGjOZhmtirhtxUf+9Xs76E7DhgcN0NSIe5
	 eTcDjbatjxq92jAzgMWpcyTvJCZ1ysMZNjT3/kYXxxLWCttYCadA11yzSKA7XPpg3aJKm
	 Gq/3D+1Tp+a/AVT5Lbhy0QpqqGufzxntkbTSQAQK4aDdW/zJa7x50hnFzmCaVaGr0mQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794200287;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:X-Sendblock-Type:CMS-TYPE:X-CPGSPASS:
	 X-Hop-Count:X-CMS-RootMailID:References;
	bh=Sx0BGLttm1qWK9zJ4S1hVFmTGgQ46bv/tah2klk4P5M=;
	b=pC8Ab1qDDdBZneQsgpWhrb5Mogj6PRz7etaiMY62N35mU2fMyLZYCt5gt1LBPX1mQdJw
	 w0WFrnY/IGaGoJzIyyyDCA1sdDH6pBGzyzV8QPmILxQc0VxJX0TCjFjHkx+szcO1DYz0Q
	 VfzjRboQhFoZxFCO9ZgUcwtQZLo24vhgDVPmKdT0IV9sILP74Xi393jheZ61XKai23/np
	 3oDbxvaNPFKJSPadf/tMaaDv9aSHSAeBSjpoaEjW2E6hagOoOst3zR6PgYc5vG0z/jVPy
	 s2qFk3SUeSY8i1ZrHyEZDQ//AiUMLBLXBr5s+HXMJu/lfKWXyQzyVDJhJcH6Okd8EkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=EIHKlHZD;
	arc=none smtp.remote-ip=203.254.224.24
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F52606A326
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 04:58:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E3F52606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=EIHKlHZD
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20261109045803epoutp01292642c469c6c6e4c85e2a1417fb9d20~mR6btGB032104121041epoutp01X
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 04:58:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20261109045803epoutp01292642c469c6c6e4c85e2a1417fb9d20~mR6btGB032104121041epoutp01X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1794200283;
	bh=Sx0BGLttm1qWK9zJ4S1hVFmTGgQ46bv/tah2klk4P5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EIHKlHZD4Djrm/4WHu6cHlIch3Xx7vTdvoGgrIEIr7R1uT6c5/noNA9jlM6eKchCS
	 j9GMTkgDPTFuWmEpRNFVD+TRMICWps+jBnWJv5NTJrA1GVq+h/Q9vb62y/CTwHVLom
	 03IoVv1PBxWCh4awW0+AQFMMV/wxpq8IkFLsMDsA=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPS id
	20261109045803epcas2p1e9b9053b6b1017b664111471e90dc4c0~mR6bFGOJt1665916659epcas2p1G;
	Mon,  9 Nov 2026 04:58:03 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4jNHbb0qkPz6B9m7; Mon,  9 Nov
	2026 04:58:03 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
	20261109041346epcas2p403d660b62bc9f227fef868e8b19816af~mRTwz6kzC1543215432epcas2p4y;
	Mon,  9 Nov 2026 04:13:46 +0000 (GMT)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.81.221.204]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261109041346epsmtip1ba2667f98aacb502ffbd3bd043676255~mRTwuvvKp2834428344epsmtip1s;
	Mon,  9 Nov 2026 04:13:46 +0000 (GMT)
From: HOYOUNG SEO <hy50.seo@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	bvanassche@acm.org, mkp@kernel.org, martin.petersen@oracle.com,
	stanleyjhu@google.com, peter.wang@mediatek.com, alim.akhtar@samsung.com,
	kwangwon.min@samsung.com, kwmad.kim@samsung.com, cpgs@samsung.com,
	h10.kim@samsung.com
Cc: HOYOUNG SEO <hy50.seo@samsung.com>
Subject: [PATCH v8 1/3] scsi: ufs: core: Clear saved errors in
 ufshcd_link_recovery()
Date: Mon,  9 Nov 2026 13:09:15 +0900
Message-Id: <728258269.41794200283102.JavaMail.epsvc@epcpadp2new>
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
X-CMS-MailID: 20261109041346epcas2p403d660b62bc9f227fef868e8b19816af
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20261109041346epcas2p403d660b62bc9f227fef868e8b19816af
References: <cover.1794196863.git.hy50.seo@samsung.com>
	<CGME20261109041346epcas2p403d660b62bc9f227fef868e8b19816af@epcas2p4.samsung.com>

ufshcd_link_recovery() resets both the device and the host and then
re-establishes the link. Unlike ufshcd_reset_and_restore(), however, it
does not clear hba->saved_err, hba->saved_uic_err and hba->force_reset,
so the errors latched before the recovery remain pending after the link
has already been recovered.

When ufshcd_err_handler() runs afterwards,
ufshcd_err_handling_should_stop() sees these stale errors. The error
handler then quiesces all queues and, depending on the latched errors
(e.g. a fatal error or UFSHCD_UIC_DL_PA_INIT_ERROR), performs another
full ufshcd_reset_and_restore() on a link that is already operational.

Cache and clear the saved errors before the reset, as
ufshcd_reset_and_restore() does, so that only errors raised during or
after the recovery are left to the error handler. Put them back if the
recovery fails.

Fixes: 35dabf4503b9 ("scsi: ufs: core: Use link recovery when h8 exit fails during runtime resume")
Signed-off-by: HOYOUNG SEO <hy50.seo@samsung.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index fd52deb72d21..3b5580ac390c 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4695,10 +4695,20 @@ EXPORT_SYMBOL_GPL(ufshcd_uic_change_pwr_mode);
 
 int ufshcd_link_recovery(struct ufs_hba *hba)
 {
+	u32 saved_err, saved_uic_err;
 	int ret;
 	unsigned long flags;
 
 	spin_lock_irqsave(&hba->host->host_lock, flags);
+	/*
+	 * The errors saved so far are handled by this full reset, so cache and
+	 * clear them first, in case new errors are generated during recovery.
+	 */
+	saved_err = hba->saved_err;
+	saved_uic_err = hba->saved_uic_err;
+	hba->saved_err = 0;
+	hba->saved_uic_err = 0;
+	hba->force_reset = false;
 	hba->ufshcd_state = UFSHCD_STATE_RESET;
 	ufshcd_set_eh_in_progress(hba);
 	spin_unlock_irqrestore(&hba->host->host_lock, flags);
@@ -4709,8 +4719,11 @@ int ufshcd_link_recovery(struct ufs_hba *hba)
 	ret = ufshcd_host_reset_and_restore(hba);
 
 	spin_lock_irqsave(&hba->host->host_lock, flags);
-	if (ret)
+	if (ret) {
 		hba->ufshcd_state = UFSHCD_STATE_ERROR;
+		hba->saved_err |= saved_err;
+		hba->saved_uic_err |= saved_uic_err;
+	}
 	ufshcd_clear_eh_in_progress(hba);
 	spin_unlock_irqrestore(&hba->host->host_lock, flags);
 
-- 
2.34.1


