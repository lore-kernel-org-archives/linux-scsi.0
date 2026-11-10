Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.25
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794277207;
	b=urBp3RQMklz46OPrZkpM/U0j1mEc76shhMgt++izLGVf+ct5Y0cNthPznXflRF3Kwo/W
	 c9c2ERMTpYKh/8Q5fe3rnM6HkumF7fdJ5VN8nX/v4wtzRnFB3MJea1w/m1Aqca1/U5Tme
	 5XPk2hZ5UN7s8DVTL/m7h8ZTL/5KNAVQR/looT5gzhg7p28H7c50Dhxz0MNmPXDA8cKes
	 BI5jhNFEGKzqRoSfHW8XhvB0ASlMiDfRK0EoNDVUXze2mhTb0oEa9zrgmPrAJm0nql6xw
	 RigU8AWyfZ3m282yK+21M8XqyGy4/T0sAUIBIh8u9pqsZYPBTdWrRpKVW/8P5U2+ZRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794277207;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:X-Sendblock-Type:CMS-TYPE:X-Hop-Count:
	 X-CMS-RootMailID:References;
	bh=nbkF1pft43e3+J7+NhK3lBDPkT3lRk1WKx0TxFdqD9w=;
	b=IFj0kQ2IBEGfJdQitXx5U766tvTLpn2q2LBlEefynijgOWbCC+488d6ZA6fWxXq5a7YH
	 TZ4yTW53Gf49MAA+OGbfOvHsCkW4dRJB/bM+0JjqJP3JCtEB8wsPK89OceiIcEFXC/mVH
	 X3Jo2H9yK45akQ6hlSUwmyuXQUAgRuYiOa5Tlhmxf+4S9qOXSzHtV+2lntj8KH9RHClV+
	 AUAgPmoBcxJp7jN+OE6A8tGaIEK8aN196XexHH7X4+3I5mnPOcP/Hk8YiNoUPusrolLpm
	 18ExCTFVI/fFJYcuAM2HATR+l7uAzpsq85Yjye9LAq2uqmQQF9XPUT4bpDFvSwaPTGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=Sb1j3B1o;
	arc=none smtp.remote-ip=203.254.224.25
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA6C606A321
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 02:20:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DFA6C606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=Sb1j3B1o
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20261110022003epoutp02ffe1631d441a4cd632c6fd8cb49e353a~mjZxFljzP0423504235epoutp02W
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 02:20:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20261110022003epoutp02ffe1631d441a4cd632c6fd8cb49e353a~mjZxFljzP0423504235epoutp02W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1794277203;
	bh=nbkF1pft43e3+J7+NhK3lBDPkT3lRk1WKx0TxFdqD9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sb1j3B1opXZW6luLUgWzuSP5pXW3AbW56+P/XgmvxjPsOzA+wKk5itSs9gKntdfyc
	 r86AXFKkksgiKs1wCdNR3nlii+mLN02RDY8QESOHAEEHBtupGJWqsKUhTAdQl1wRJM
	 0SmpS4ZHAkh30bSKjQSIRtt+XAT8lzER0CcGlqBM=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPS id
	20261110022003epcas2p12fa7c1b7c60d7fe197dc881100689f44~mjZwhmNTG1253412534epcas2p1H;
	Tue, 10 Nov 2026 02:20:03 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4jNr2q1gYTz6B9mJ; Tue, 10 Nov
	2026 02:20:03 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
	20261110020746epcas2p2ed2c3b150d2ecbf810658264841e790e~mjPB__SSz0304203042epcas2p29;
	Tue, 10 Nov 2026 02:07:46 +0000 (GMT)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.81.221.204]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261110020746epsmtip158b3314fda4c896e6b02213d2d0096f5~mjPB5n3kR3236632366epsmtip1Q;
	Tue, 10 Nov 2026 02:07:46 +0000 (GMT)
From: HOYOUNG SEO <hy50.seo@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	bvanassche@acm.org, mkp@kernel.org, martin.petersen@oracle.com,
	stanleyjhu@google.com, peter.wang@mediatek.com, alim.akhtar@samsung.com,
	kwangwon.min@samsung.com, kwmad.kim@samsung.com, cpgsproxy1@samsung.com,
	h10.kim@samsung.com
Cc: HOYOUNG SEO <hy50.seo@samsung.com>, Bean Huo <beanhuo@micron.com>
Subject: [PATCH v9 1/3] scsi: ufs: core: Clear saved errors in
 ufshcd_link_recovery()
Date: Tue, 10 Nov 2026 11:03:13 +0900
Message-Id: <1582071873.61794277203231.JavaMail.epsvc@epcpadp1new>
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
X-CMS-MailID: 20261110020746epcas2p2ed2c3b150d2ecbf810658264841e790e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Hop-Count: 3
X-CMS-RootMailID: 20261110020746epcas2p2ed2c3b150d2ecbf810658264841e790e
References: <cover.1794275305.git.hy50.seo@samsung.com>
	<CGME20261110020746epcas2p2ed2c3b150d2ecbf810658264841e790e@epcas2p2.samsung.com>

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
Reviewed-by: Bean Huo <beanhuo@micron.com>
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


