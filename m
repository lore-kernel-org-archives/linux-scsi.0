Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB5F1A6816;
	Mon, 15 Jun 2026 05:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781503116; cv=none; b=e6ZaJPyFFJYOBoXK3PIHieTe2xECzjCtK/e5ymxq8+Td2Z0jbr0zzjtj0cLEe3GEzyq7CrAHiFlBlUVc+0YAXwrlrqKq08zHjOGvTn+2o4htqsU1xKZxgCPZG0Pct7acfPfqIVl9f9dWvdZ0Admp/1txTraE1WJzrbiRuNPpK5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781503116; c=relaxed/simple;
	bh=J/UslbAuHeOYa/H9By8DgocG8kJjWZycHNyKixn98o4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P0Pt1reeu3JGMOIBYAmdpq0nBMxuC5D0lNYHdR9DYEfvYBOi8ezqarbJHTkT+MJ+JTzTVv2VQ3xurMPhliAFZdGzGmxph8FqjGbsvQ2CKzxXSxhKU/DcB151BZuB6W/pkiYQOWex7Z81qu3FR95pJfHt4Uh9DrLmiJjMTiQkkQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=LFhT/c4Y; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="LFhT/c4Y"
X-UUID: 3a8ea43a687f11f1b1788b6acf885367-20260615
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=Z74uBbdsQ/fARR0kh8p3nPXksCzC/EQS2Nq9vJKqgb8=;
	b=LFhT/c4Y8KJoNb6RJPT6SECWW4TZAbSK5UwOvKtvNz8vdBrDBqxBrDnnm1w9vxXDk2sEsWWTvDTGSRhXJNpBeEJlPHkc7fa65q9ezQVYKN2jnCjzeNKxYGjd8DjfJemrw17sHg8zde+rWtPMSQXqS3HxXaFRgDcNxxXZ0RXVk4w=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.15,REQID:6d0a5ca5-ef9d-4e08-9823-f8b5e8d6ab8e,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:e276073,CLOUDID:f8d2f3e0-ecbd-446c-abfe-8b1546a39ee8,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|123|836|865|888|898,TC:-5,
	Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,C
	OL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 3a8ea43a687f11f1b1788b6acf885367-20260615
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw01.mediatek.com
	(envelope-from <ed.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1154769253; Mon, 15 Jun 2026 13:58:27 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 15 Jun 2026 13:58:26 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 15 Jun 2026 13:58:26 +0800
From: <ed.tsai@mediatek.com>
To: <alim.akhtar@samsung.com>, <avri.altman@wdc.com>, <bvanassche@acm.org>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>, Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mediatek@lists.infradead.org>, <wsd_upstream@mediatek.com>,
	<peter.wang@mediatek.com>, <alice.chao@mediatek.com>,
	<naomi.chu@mediatek.com>, <chun-hung.wu@mediatek.com>, Ed Tsai
	<ed.tsai@mediatek.com>
Subject: [PATCH v3 3/3] ufs: core: Remove max_num_rtt field from ufs_hba_variant_ops
Date: Mon, 15 Jun 2026 13:57:17 +0800
Message-ID: <20260615055802.105479-4-ed.tsai@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260615055802.105479-1-ed.tsai@mediatek.com>
References: <20260615055802.105479-1-ed.tsai@mediatek.com>
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

Remove the max_num_rtt field from ufs_hba_variant_ops as it has been
replaced by the get_hba_nortt() callback which provides more flexible
platform-specific RTT capability handling.

Signed-off-by: Ed Tsai <ed.tsai@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 4 +---
 include/ufs/ufshcd.h      | 2 --
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 382b6041c716..00072bff9dcd 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8557,8 +8557,6 @@ static void ufshcd_set_rtt(struct ufs_hba *hba)
 	struct ufs_dev_info *dev_info = &hba->dev_info;
 	u32 rtt = 0;
 	u32 dev_rtt = 0;
-	int host_rtt_cap = hba->vops && hba->vops->max_num_rtt ?
-			   hba->vops->max_num_rtt : hba->nortt;
 
 	/* RTT override makes sense only for UFS-4.0 and above */
 	if (dev_info->wspecversion < 0x400)
@@ -8574,7 +8572,7 @@ static void ufshcd_set_rtt(struct ufs_hba *hba)
 	if (dev_rtt != DEFAULT_MAX_NUM_RTT)
 		return;
 
-	rtt = min_t(int, dev_info->rtt_cap, host_rtt_cap);
+	rtt = min_t(int, dev_info->rtt_cap, hba->nortt);
 
 	if (rtt == dev_rtt)
 		return;
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 421c286481e8..13d0d7798294 100644
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
@@ -420,7 +419,6 @@ struct ufshcd_tx_eq_params {
  */
 struct ufs_hba_variant_ops {
 	const char *name;
-	int	max_num_rtt;
 	int	(*init)(struct ufs_hba *);
 	void    (*exit)(struct ufs_hba *);
 	u32	(*get_ufs_hci_version)(struct ufs_hba *);
-- 
2.45.2

