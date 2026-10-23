Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.25
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792755554;
	b=RlcCcQbHprWOK1tk8n37NHvMZ+rAITIhEd513LFF+Jys+Mt6eneUQr+SsVY0kvBDm959
	 e6mojtCzeB8tzF57CpFrhrmSsLn/wkww+Irumj+JkF1mwvpGeyl3Sl2tY2GMLm3iBl+9b
	 ivcK5BLyY/y28e1/P5o+wP+2tgnTKlGRStFwZsFXteS7s2QioD1iKwvB/x8geaLn0lCeA
	 HZbTwWG39qwDy+zdsJB4x0TQsijCGp2JhznxaTXsUZwPBfJ3j6KQVSlAKPtJHoTUbw0e/
	 o5WPwxktt4CzPp8r87IL1W+QlvLRdLdkVO5D/NCNFfoId1dr+kbCzAVFhUM1HNkPsag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792755554;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:X-Sendblock-Type:CMS-TYPE:X-CPGSPASS:
	 cpgsPolicy:X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=i9Ml4qigH7DzspM/Amzf5XaHAXSm7xpnRAKJSyb+B5s=;
	b=uN8t7Rzufy0alkWd9bufOvIO2FOgf11AyuLVHKYXbJrc5kq/Vkvc27Fat/HUTIzKM8KV
	 TP3iQzzBA/cJiC6reWiikdUgQf5K03kv3QryvTFjI2YBkdpVhb8w0Rgbwe4rOYqoLtwDX
	 XP1dLWuETtwr899lr8CyznAf3QWcKrjebx2yPy60qxImi5cTOY+D4vUGq7jSXfMQePBim
	 QIeMO3Ivz+rvbv+/lhDseZZ8oYdbdmswdQtsApmXNGHPL/RugvmU2xciw8LhbB+NiLm6V
	 Vm7iuz0pVI69PoPXUFTAoXnqyhNtRGvc8CP6ZI0ewapeN6p0tumcYY8JbF93ttfjyvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=dXi8KQNX;
	arc=none smtp.remote-ip=203.254.224.25
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA61606A321
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 11:39:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CAA61606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=dXi8KQNX
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20261023113912epoutp022c197c823f28396d7f62ff94b2c3a65b~hJa0eA3W_1867318673epoutp02D
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 11:39:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20261023113912epoutp022c197c823f28396d7f62ff94b2c3a65b~hJa0eA3W_1867318673epoutp02D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1792755552;
	bh=i9Ml4qigH7DzspM/Amzf5XaHAXSm7xpnRAKJSyb+B5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dXi8KQNXJnCPRZS6jy8UX4JgmQg+GMR9cx9jkBmDmUoT0qKFYC7mZD1rRFkJR52kK
	 ff+OZ4S0azuM3zn0tVlHpmU4VOEnk+cFopov3O9q3weKVE2JUT5wfUWxDwaD1pPGlB
	 ppreflV7lcvASFCf8jj8NB60eOf5QLqEHXsHxEBU=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPS id
	20261023113911epcas2p47c77c8bc9b8ad66a09a130fa78fafb1e~hJa0JrZbn1351613516epcas2p45;
	Fri, 23 Oct 2026 11:39:11 +0000 (GMT)
Received: from epcas2p3.samsung.com (unknown [182.195.38.202]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4jB1JH2k0tz6B9m7; Fri, 23 Oct
	2026 11:39:11 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
	20261023113910epcas2p1479bbb9200be2c1e0c31a86ba36efbcc~hJayi8j2D2090120901epcas2p1z;
	Fri, 23 Oct 2026 11:39:10 +0000 (GMT)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.81.221.204]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261023113909epsmtip140e3e47c06d9bc66693dfee4a7178969~hJayetg8T0801708017epsmtip1u;
	Fri, 23 Oct 2026 11:39:09 +0000 (GMT)
From: HOYOUNG SEO <hy50.seo@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
	martin.petersen@oracle.com, bvanassche@acm.org, kwangwon.min@samsung.com,
	kwmad.kim@samsung.com, cpgs@samsung.com, h10.kim@samsung.com
Cc: HOYOUNG SEO <hy50.seo@samsung.com>
Subject: [PATCH v2 1/2] scsi: ufs: core: Clear saved errors in
 ufshcd_link_recovery
Date: Fri, 23 Oct 2026 20:34:51 +0900
Message-Id: <31fc787b76a2586ca6d3c442afdb694aab3d14bb.1792755091.git.hy50.seo@samsung.com>
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
X-CMS-MailID: 20261023113910epcas2p1479bbb9200be2c1e0c31a86ba36efbcc
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-234,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261023113910epcas2p1479bbb9200be2c1e0c31a86ba36efbcc
References: <cover.1792755091.git.hy50.seo@samsung.com>
	<CGME20261023113910epcas2p1479bbb9200be2c1e0c31a86ba36efbcc@epcas2p1.samsung.com>

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

Signed-off-by: HOYOUNG SEO <hy50.seo@samsung.com>
---
 drivers/ufs/core/ufshcd.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index bcc2512bf34b..74dfbb98129e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4690,10 +4690,20 @@ EXPORT_SYMBOL_GPL(ufshcd_uic_change_pwr_mode);
 
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
@@ -4704,8 +4714,11 @@ int ufshcd_link_recovery(struct ufs_hba *hba)
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

