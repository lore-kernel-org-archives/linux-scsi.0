Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.24
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793852448;
	b=H0TtHUjq3RHh7cTbjT/qp6wiN/8A+qoW6t+50KV3hVczFcX14gLQZHMTxOYU5ftzcJa1
	 Ng3f6/4rY+9f+o2BgdNT8HYRV/bUyLcF+AJb+MHBR8pNCIZa0Q8m9c1GfzVCjUwi3oCX8
	 SPxwst5ry9kh+mLkMrJEFwc7n2uOWBgfALq/uf8K1WcN4fJbpYCXIE/FbUaPK0WKMgKRj
	 A9nM3TNZDOvM0Ihwm/HCOqRcuT/YO1+18uIpd4s582KYPaS5ni6DYkCFrhkWSnjEkbHXC
	 bgJFYoL4aZhPlo67mKWceGMVn5YfIbAXj3TcNKQ8MXBbUi2SYVnUeRtKgnmHNtbz5LQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793852448;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:X-Sendblock-Type:CMS-TYPE:X-CPGSPASS:
	 cpgsPolicy:X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=csK9dgm7U755rGUdnl4P8DPAxrtTm2BPzEXrt7f6/MU=;
	b=lCunzaXL2JYaXE1ad9vQ6PNsk/OCCyIhqPsP25PGAbQIXR7DkTzJleWRuV7Z+k0iOjoL
	 3GocyaH8ewmT/VwKwM2U7bSdnfGwyEhnvSz6nemXKLLRJL15PSF+DM442vI9bSd+ARyi5
	 Z6VG/CLr02D7Szdh5a3VuVYAGkxXt3bYZG/sFVIQNFBWB3kHHZTMZUU/ZAV6mkzMI3p5R
	 Wts9aWqorPAC2E841XNZM/M7Z7f06yXpWEQR5Z6dAZbQ1UDAgGn7++jl8unmUeLze/YEs
	 VUmv7cySDGa7PEySMUD7SfSSdriAv/cX1ypJUuTMuw4R/WcHkODDsEQdOqUuPg+I9Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=lGJsqFXZ;
	arc=none smtp.remote-ip=203.254.224.24
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BCE606A330
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 04:20:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 19BCE606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=lGJsqFXZ
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20261105042044epoutp01d482d5c64d294918865968814b61339b~lC0s2HDTC1029310293epoutp01e
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 04:20:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20261105042044epoutp01d482d5c64d294918865968814b61339b~lC0s2HDTC1029310293epoutp01e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793852444;
	bh=csK9dgm7U755rGUdnl4P8DPAxrtTm2BPzEXrt7f6/MU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lGJsqFXZD0hnGUVXuRn8UkqRUoa+v28qiWtw8x1yy7T58ZVw3uAm431BWwjGnOLTl
	 B5mrxTFnwb+MsBXxoB9Xy9mTBb1Zb8thx8tC45rm67/JZ/qssQTzZ4cvvSDz67htBj
	 WteCswCLKOglnuJspK5RekDk+sAY5whjhpTJwWbc=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPS id
	20261105042043epcas2p47e2c6608a3bb4cc05e0d394e239dee35~lC0sUzZij3102431024epcas2p4O;
	Thu,  5 Nov 2026 04:20:43 +0000 (GMT)
Received: from epcas2p1.samsung.com (unknown [182.195.38.209]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4jKpyM293lz6B9m6; Thu,  5 Nov
	2026 04:20:43 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
	20261105042042epcas2p3324be8d7f036c225feda4cbf2238ed43~lC0q_62XT1144111441epcas2p3G;
	Thu,  5 Nov 2026 04:20:42 +0000 (GMT)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.81.221.204]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261105042042epsmtip195224d35ce3da27bc52d6da42e0b6ad8~lC0q42XqM2513425134epsmtip1G;
	Thu,  5 Nov 2026 04:20:42 +0000 (GMT)
From: HOYOUNG SEO <hy50.seo@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	bvanassche@acm.org, mkp@kernel.org, martin.petersen@oracle.com,
	stanleyjhu@google.com, alim.akhtar@samsung.com, kwangwon.min@samsung.com,
	kwmad.kim@samsung.com, cpgs@samsung.com, h10.kim@samsung.com
Cc: HOYOUNG SEO <hy50.seo@samsung.com>
Subject: [PATCH v4 1/2] scsi: ufs: core: Clear saved errors in
 ufshcd_link_recovery
Date: Thu,  5 Nov 2026 13:16:16 +0900
Message-Id: <4cefdf850673bade48a92949518869dfc2ae88e3.1793851432.git.hy50.seo@samsung.com>
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
X-CMS-MailID: 20261105042042epcas2p3324be8d7f036c225feda4cbf2238ed43
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-234,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261105042042epcas2p3324be8d7f036c225feda4cbf2238ed43
References: <cover.1793851432.git.hy50.seo@samsung.com>
	<CGME20261105042042epcas2p3324be8d7f036c225feda4cbf2238ed43@epcas2p3.samsung.com>

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

