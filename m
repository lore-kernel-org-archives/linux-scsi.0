Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE6D2DB780;
	Tue,  9 Jun 2026 10:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781001547; cv=none; b=SVCGy0jZbfzaMYX/A1oWHamodMIi5V3W8AHwnDQ/plwF0RGqjx6dsLbC48k14k3iyhgaGdI7wuD9PEheaErqeRBtxab+z90aww8E5ahhNj0DXnK6pvgD30JfR6thFvCo7kNLFttlBMQeL9U2hrUH+xYVg8vcgo45gaqdR0Uby54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781001547; c=relaxed/simple;
	bh=gYzeVAkjxUtr+9UShRmceTpcJYUQ6jDXjdVh3tpzgVQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=poN/me6V5nkQnHiGA2uDU4tdQrVEMFZLTGERx5Iw3xxqkuZ/d1V8jwzZPW+SgaI+CV9Q7+2fiFVXEU+cgq7pU5ofuL7c6SNCViuAfZ4b6+9Fc1xvd7YpaPxz4C7AfBiHjQyqBevNFdcwrw0W/FVQMBQHU0WQrodM65dpLV/icaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=hePFc5C6; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="hePFc5C6"
X-UUID: 6d27ddf663ef11f1b1788b6acf885367-20260609
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=8wi9fizjtE9V4ujGFA2Tw2npgNQ/OF9fNC3bNYWZjDA=;
	b=hePFc5C6akCxa1LY+UAG3mUFFEuCgND93AcNectV0mBRSOdTQRV4D8NHHB+KDxYhlSgYw1ys+wrxMIoet/iUtvgXe64CdbWb5o4X4IY4rRvPwZaFVW2AbSRKIgqg5IW//Qs9qH4RTqPhY6ajXUNSlE28U1oFgbXExV7ZAVikf4M=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.15,REQID:a8b72a13-8d2b-470e-a2a3-1ecc1a0c0596,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e276073,CLOUDID:2bd69030-7784-4a77-a538-47ed6151d81b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|123|836|865|888|898,TC:-5,
	Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,C
	OL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6d27ddf663ef11f1b1788b6acf885367-20260609
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
	(envelope-from <ed.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 66635412; Tue, 09 Jun 2026 18:39:00 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Jun 2026 18:38:59 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 9 Jun 2026 18:38:59 +0800
From: <ed.tsai@mediatek.com>
To: <alim.akhtar@samsung.com>, <avri.altman@wdc.com>, <bvanassche@acm.org>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mediatek@lists.infradead.org>, <wsd_upstream@mediatek.com>,
	<peter.wang@mediatek.com>, <alice.chao@mediatek.com>,
	<naomi.chu@mediatek.com>, <chun-hung.wu@mediatek.com>, Ed Tsai
	<ed.tsai@mediatek.com>
Subject: [PATCH 1/2] ufs: core: Add get_hba_nortt callback for vendor-specific RTT capability
Date: Tue, 9 Jun 2026 18:38:55 +0800
Message-ID: <20260609103856.676222-2-ed.tsai@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260609103856.676222-1-ed.tsai@mediatek.com>
References: <20260609103856.676222-1-ed.tsai@mediatek.com>
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

For platforms without the callback, continue to use the value from the
host controller capability register.

Also remove the max_num_rtt field from ufs_hba_variant_ops as it is
replaced by the new get_hba_nortt callback.

Signed-off-by: Ed Tsai <ed.tsai@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 9 +++++----
 include/ufs/ufshcd.h      | 5 +++--
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c3f08957d179..00072bff9dcd 100644
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
@@ -8554,8 +8557,6 @@ static void ufshcd_set_rtt(struct ufs_hba *hba)
 	struct ufs_dev_info *dev_info = &hba->dev_info;
 	u32 rtt = 0;
 	u32 dev_rtt = 0;
-	int host_rtt_cap = hba->vops && hba->vops->max_num_rtt ?
-			   hba->vops->max_num_rtt : hba->nortt;
 
 	/* RTT override makes sense only for UFS-4.0 and above */
 	if (dev_info->wspecversion < 0x400)
@@ -8571,7 +8572,7 @@ static void ufshcd_set_rtt(struct ufs_hba *hba)
 	if (dev_rtt != DEFAULT_MAX_NUM_RTT)
 		return;
 
-	rtt = min_t(int, dev_info->rtt_cap, host_rtt_cap);
+	rtt = min_t(int, dev_info->rtt_cap, hba->nortt);
 
 	if (rtt == dev_rtt)
 		return;
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index cfbc75d8df83..13d0d7798294 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -370,7 +370,6 @@ struct ufshcd_tx_eq_params {
 /**
  * struct ufs_hba_variant_ops - variant specific callbacks
  * @name: variant name
- * @max_num_rtt: maximum RTT supported by the host
  * @init: called when the driver is initialized
  * @exit: called to cleanup everything done in init
  * @set_dma_mask: For setting another DMA mask than indicated by the 64AS
@@ -415,10 +414,11 @@ struct ufshcd_tx_eq_params {
  * @get_rx_fom: called to get Figure of Merit (FOM) value.
  * @tx_eqtr_notify: called before and after TX Equalization Training procedure
  *	to allow platform vendor specific configs to take place.
+ * @get_hba_nortt: called to get maximum number of outstanding RTTs supported by
+ *	the controller.
  */
 struct ufs_hba_variant_ops {
 	const char *name;
-	int	max_num_rtt;
 	int	(*init)(struct ufs_hba *);
 	void    (*exit)(struct ufs_hba *);
 	u32	(*get_ufs_hci_version)(struct ufs_hba *);
@@ -477,6 +477,7 @@ struct ufs_hba_variant_ops {
 	int	(*tx_eqtr_notify)(struct ufs_hba *hba,
 				  enum ufs_notify_change_status status,
 				  struct ufs_pa_layer_attr *pwr_mode);
+	int	(*get_hba_nortt)(struct ufs_hba *hba);
 };
 
 /* clock gating state  */
-- 
2.45.2

