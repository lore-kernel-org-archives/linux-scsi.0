Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C452C21ADCB;
	Mon,  4 Aug 2025 06:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754287381; cv=none; b=ESuj2FahMEtAhMXlpU9gWwqvHzuFJQY/o8q3KHiZA6stIr5SdLrvTHfKqVTcJvwrKUkfP0R+UiQs+1ElUArOV6VfsTKwFg0zwh+dJlgq0s8usXBm/QNdS5KHoZV0lAn35B15TCXhA5XQ0ItPCJdCci88yDfYDAsvwY4YYmWO7hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754287381; c=relaxed/simple;
	bh=4rAQAgpCJjXS5Q5/2G4kkVyxN+NZyMEFiBFP7FYGaIA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=oj/AwUlG995r5QIjEObG0hQcCE3SJkym7MpYYGm8dboOhhZVFDYONOtjyRU84wzl2i2ZrkQ1jFlzCcswWRj4UhxVUDBxNcljQoPfPrfTFIA60K6dKbj54TcW9dFcQf4eRvzfZW+lquNkkvUnZFKz86Dx1QRd7Tg4HJV6tCFfvaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=IkQ/cpdZ; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="IkQ/cpdZ"
X-UUID: a810b43c70f811f08871991801538c65-20250804
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=jYX1bSUuVoUfUgRyTX/Hgp4wHn5pumMUBcHWSkGuBHk=;
	b=IkQ/cpdZzti+ncU2DBicbi+++nWJqqGuEM8CC9Ch4kN7l4ZJ+xe1dzISxjYFK923Mu3ultWbr8M3CYfLHEEExUciph/AVA3mGOXH10Endjht5rIlKUPpuzfXyN+2ysr78ZFZtXMffIFuMp1ULhjsaU8pyTtT+9KJpeAV7OdKFxQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:ec6b8906-0af9-4653-800f-6a92190f64a9,IP:0,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:-5
X-CID-META: VersionHash:9eb4ff7,CLOUDID:32668d50-93b9-417a-b51d-915a29f1620f,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:-5,Content:0|15|50,EDM:-3,IP:
	nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,L
	ES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: a810b43c70f811f08871991801538c65-20250804
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 492759898; Mon, 04 Aug 2025 14:02:52 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Mon, 4 Aug 2025 14:02:50 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Mon, 4 Aug 2025 14:02:50 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>,
	<dan.carpenter@linaro.org>, <stable@vger.kernel.org>
Subject: [PATCH v1] ufs: host: mediatek: Fix out-of-bounds access in MCQ IRQ mapping
Date: Mon, 4 Aug 2025 14:01:54 +0800
Message-ID: <20250804060249.1387057-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

From: Peter Wang <peter.wang@mediatek.com>

This patch addresses a potential out-of-bounds access issue when
accessing 'host->mcq_intr_info[q_index]'. The value of 'q_index'
might exceed the valid array bounds if 'q_index == nr'.
The condition is corrected to 'q_index >= nr' to prevent
accessing invalid memory.

Fixes: 66e26a4b8a77 ("scsi: ufs: host: mediatek: Set IRQ affinity policy for MCQ mode")
Cc: <stable@vger.kernel.org>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 86ae73b89d4d..f902ce08c95a 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -818,7 +818,7 @@ static u32 ufs_mtk_mcq_get_irq(struct ufs_hba *hba, unsigned int cpu)
 	unsigned int q_index;
 
 	q_index = map->mq_map[cpu];
-	if (q_index > nr) {
+	if (q_index >= nr) {
 		dev_err(hba->dev, "hwq index %d exceed %d\n",
 			q_index, nr);
 		return MTK_MCQ_INVALID_IRQ;
-- 
2.45.2

