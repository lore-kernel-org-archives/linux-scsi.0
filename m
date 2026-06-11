Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289B4369D71;
	Thu, 11 Jun 2026 23:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781220418; cv=none; b=ShSEJiEW41a48FNfmSq4+QpsnxwzjtpeUoAE4mZJmos1GoUumjgoA9gJlC0VK0UtQEcyFcRWq+bfH7Uplew+OPBEVACOPgJYnrGwcQt7Qgo8RsxWWseo/j86/+Y1ZffKfKnfUKqCfljn56De4Cg4HqkcjmaMw22Mn1z94UdWEFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781220418; c=relaxed/simple;
	bh=SS/uJZRsXXasD0BBkT0x8L8HcjDGIkeq8sn2Pkbk8WA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=INCyktEFRJBYC/jzB122zKpg6wJaqjC5peYTC5UusrvgGZDnrdrGWOleafQo2pPJUnLJg3wOk6vUQ5dF5xx3C+g6wBUz+U0uNiTld0chNQyrG0Ir4eNfbJsbC3DiSMdFb32/r3NEsfEL7HDnpXeakeH1ZlG5uvf/7vBj+fjJOr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=JGrr8xBS; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="JGrr8xBS"
X-UUID: 02e6754265ed11f18dc8c9802ae25ab1-20260612
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=7lono346LLiByVxDpmcbPatLkqlMCZPQmgQ7Az+Hj/8=;
	b=JGrr8xBSLd8m56Mka7KvuHvthyYtlmFc0GoNFvb3vE1L7xRwnzamktrLGzPfvPA8Wer2VhDYpcl7LN2M19oSXuY8Fjb1zEeb0MMmHmJ1ALu021A9F0pwrENWLYOtp2tb46vhIq+hqaX1sG2gxGFHJ3pUZhiDcdYgRunYnDlVAN4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.15,REQID:71fe7083-5df3-4014-b50e-8d9ff00276e8,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e276073,CLOUDID:6601ae30-7784-4a77-a538-47ed6151d81b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|123|836|865|888|898,TC:-5,
	Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,C
	OL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 02e6754265ed11f18dc8c9802ae25ab1-20260612
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw02.mediatek.com
	(envelope-from <ed.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1976430879; Fri, 12 Jun 2026 07:26:45 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 12 Jun 2026 07:26:44 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 12 Jun 2026 07:26:44 +0800
From: <ed.tsai@mediatek.com>
To: <alim.akhtar@samsung.com>, <avri.altman@wdc.com>, <bvanassche@acm.org>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mediatek@lists.infradead.org>, <wsd_upstream@mediatek.com>,
	<peter.wang@mediatek.com>, <alice.chao@mediatek.com>,
	<naomi.chu@mediatek.com>, <chun-hung.wu@mediatek.com>, Ed Tsai
	<ed.tsai@mediatek.com>
Subject: [PATCH v2 1/3] ufs: core: Add get_hba_nortt callback for vendor-specific RTT capability
Date: Fri, 12 Jun 2026 07:26:30 +0800
Message-ID: <20260611232632.2324422-2-ed.tsai@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260611232632.2324422-1-ed.tsai@mediatek.com>
References: <20260611232632.2324422-1-ed.tsai@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

From: Ed Tsai <ed.tsai@mediatek.com>

The number of outstanding RTTs read from host controller capability
register is problematic on some platforms. Add a new vendor callback
get_hba_nortt() to allow platform vendors to override the default RTT
capability value with platform-specific handling.

This patch keeps max_num_rtt field for bisectability and will be removed
in a later patch once all platforms are migrated.

Signed-off-by: Ed Tsai <ed.tsai@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 5 ++++-
 include/ufs/ufshcd.h      | 3 +++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c3f08957d179..382b6041c716 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2529,7 +2529,10 @@ static inline int ufshcd_hba_capabilities(struct ufs_hba *hba)
 	hba->nutmrs =
 	((hba->capabilities & MASK_TASK_MANAGEMENT_REQUEST_SLOTS) >> 16) + 1;
 
-	hba->nortt = FIELD_GET(MASK_NUMBER_OUTSTANDING_RTT, hba->capabilities) + 1;
+	if (hba->vops && hba->vops->get_hba_nortt)
+		hba->nortt = hba->vops->get_hba_nortt(hba);
+	else
+		hba->nortt = FIELD_GET(MASK_NUMBER_OUTSTANDING_RTT, hba->capabilities) + 1;
 
 	/* Read crypto capabilities */
 	err = ufshcd_hba_init_crypto_capabilities(hba);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index cfbc75d8df83..421c286481e8 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -415,6 +415,8 @@ struct ufshcd_tx_eq_params {
  * @get_rx_fom: called to get Figure of Merit (FOM) value.
  * @tx_eqtr_notify: called before and after TX Equalization Training procedure
  *	to allow platform vendor specific configs to take place.
+ * @get_hba_nortt: called to get maximum number of outstanding RTTs supported by
+ *	the controller.
  */
 struct ufs_hba_variant_ops {
 	const char *name;
@@ -477,6 +479,7 @@ struct ufs_hba_variant_ops {
 	int	(*tx_eqtr_notify)(struct ufs_hba *hba,
 				  enum ufs_notify_change_status status,
 				  struct ufs_pa_layer_attr *pwr_mode);
+	int	(*get_hba_nortt)(struct ufs_hba *hba);
 };
 
 /* clock gating state  */
-- 
2.45.2

