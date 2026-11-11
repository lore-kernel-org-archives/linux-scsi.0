Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.25
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794387796;
	b=i4A7dykMqkebHlChWvllKIDfq256+DQbey/mCPNKf5DLe2OSz2MrQ+hD2SuT0/h7vj+D
	 4AlEMZcMImah/4yZDSL47S3YrMEKAdWtac+Lz2OipAu2+238l2+owZvSk9dfbUKBF4II+
	 p9SuWwLL25X5EoopLu+SI+c/bNCXSsD+dcbiMMmkYmgcfCrw95TCKAC4kaiW3clCPkf3p
	 XJKLG7uFdl2YXCzKlvPDoe/YKdfbkPuCsbUBS7rnMgVxva7Hl9yiqKPB8ADFdNZvwZRCZ
	 fKOz9Z9lR1lbbfEr2XtDlHCRysox8Msk5cYlJoKZ1U7GbNCbgS9oboNM50l8JKSPNpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794387796;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:X-Sendblock-Type:CMS-TYPE:X-Hop-Count:
	 X-CMS-RootMailID:References;
	bh=nbkF1pft43e3+J7+NhK3lBDPkT3lRk1WKx0TxFdqD9w=;
	b=I/lJgHwOQXIRni5S/hkMetBMCLkiHrJHLOI2Cq0OYRt7BRowy4Cws+ySdGDxGBSWgc2+
	 ffB8Fw/z+rs74FGpkP1v3QhCilGH298d8yIXE1fq4XwNjcAZ6BZV4GdjD7ExQoMdU/ofS
	 h6mBpOgFNwmf0Ks23IM8md2asqveTEYMC8Lh1mKgnha+x1bFpWMe1z87EnjEsU8K1ZrIb
	 ewXAOQQOCqqc0BqxZgLWvW7Op8EMikdcpCQvu9IbnnlqYhr18W6EaIGIH71Bt0CsfAtmK
	 Cjwx18UX2wJkzzfVqA1OSqGtcxcstG0RP9Gawlbkk50mLrefurYOPHEJdt8mWpIHisQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=DwT35Ahr;
	arc=none smtp.remote-ip=203.254.224.25
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74EAE60A3804
	for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 09:03:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 74EAE60A3804
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=DwT35Ahr
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20261111090307epoutp0205c6469d150daf61cdf34cffbf66dad9~m8i_aLXT12404024040epoutp02K
	for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 09:03:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20261111090307epoutp0205c6469d150daf61cdf34cffbf66dad9~m8i_aLXT12404024040epoutp02K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1794387787;
	bh=nbkF1pft43e3+J7+NhK3lBDPkT3lRk1WKx0TxFdqD9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DwT35Ahrtq4a25JuCfwLA5VG3jT+IOx4SixpLBHaVuZ2Ak1o30vuaS3uEc5PIaxXD
	 vJyMI09SaoyUR3RRwqWbrmzumUSuEzSOMcyKXLXc6+PYLgKw8jXb9dbkhHp8exVxQ4
	 gVtyFr7Rrbzz497seKMi3VvU9Dk8+Po3deZqOeu4=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPS id
	20261111090307epcas2p40eb971c8cf4ca3bdc7cf7d33ca4a71ee~m8i_GNXV31311913119epcas2p4M;
	Wed, 11 Nov 2026 09:03:07 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4jPcxR3C5Hz2SSKg; Wed, 11 Nov
	2026 09:03:07 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
	20261111082304epcas2p4887d72756d51a72b94729439d25dd3e8~m8AAaV9rs0269302693epcas2p4I;
	Wed, 11 Nov 2026 08:23:04 +0000 (GMT)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.81.221.204]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20261111082304epsmtip2c6e4db543d40d7973a31b0f9b9d34be7~m8AAT-jJN1488414884epsmtip2W;
	Wed, 11 Nov 2026 08:23:04 +0000 (GMT)
From: HOYOUNG SEO <hy50.seo@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	bvanassche@acm.org, mkp@kernel.org, martin.petersen@oracle.com,
	stanleyjhu@google.com, peter.wang@mediatek.com, alim.akhtar@samsung.com,
	kwangwon.min@samsung.com, kwmad.kim@samsung.com, cpgsproxy1@samsung.com,
	h10.kim@samsung.com
Cc: HOYOUNG SEO <hy50.seo@samsung.com>, Bean Huo <beanhuo@micron.com>
Subject: [PATCH v10 1/4] scsi: ufs: core: Clear saved errors in
 ufshcd_link_recovery()
Date: Wed, 11 Nov 2026 17:18:31 +0900
Message-Id: <1384010761.101794387787447.JavaMail.epsvc@epcpadp2new>
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
X-CMS-MailID: 20261111082304epcas2p4887d72756d51a72b94729439d25dd3e8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Hop-Count: 3
X-CMS-RootMailID: 20261111082304epcas2p4887d72756d51a72b94729439d25dd3e8
References: <cover.1794384665.git.hy50.seo@samsung.com>
	<CGME20261111082304epcas2p4887d72756d51a72b94729439d25dd3e8@epcas2p4.samsung.com>

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


