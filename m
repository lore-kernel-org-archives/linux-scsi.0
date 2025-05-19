Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF4622DA14;
	Mon, 19 May 2025 07:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747640315; cv=none; b=bIjxs1bdx8XoXdyehyXs/f8KZ+UBO7skZf74lCAT+hn7E6gPGlKNlVworqc+CCk5+ztbxbVWfaOmSJkl4aGZXCcGoWzj2i+oypX12btD/6/WJjunAFI2VjoMWseHMJKWOygxnP5Gi/Yp++T/ivgG3jOmNVEKxt2JfkavKzuz1RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747640315; c=relaxed/simple;
	bh=SjjBMUxQPYzQNNIFGjlm0NpZXO7Rfj/OLiyitrnPmKc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=F6kEkZ2mENQqQcuw/ApHWQQ1rqcsWUDd0BgX5j1aFUs9Fl+mmWsuyZLZhgBBXL4D1A1CzZnPYa0g0S2ZMyg5fJDnfzy+tMhHD2R606x+2o8XDqvZhvJDJQye7LgzQFJvaq+rZbBh4CHfSk6ho/WsCwfWEW5N158dKIHw4YqWZdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=a3wFtYUm; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="a3wFtYUm"
X-UUID: 3bf13c46348411f082f7f7ac98dee637-20250519
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=Z7nRriuV9vS+4k4680rkW86JxjvMbZ7a06K/lzDLNBo=;
	b=a3wFtYUmcH5zYvLJAPaUVjKH0MWg2JQRmpLx4yRd7jJU/KmUxK/T2YPPuDE/DJERAZgR1a9gDKvCzGSOw81kr4GZUsYCEVzi21yTAHmMlyCuLPQ6ena91pLaGnMafoE0ZdDw/Q6wjTZU4tXFY7WDcMDOVF8LlxZe42w2CDb81C0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:fca8c623-834e-41f0-a70d-4d61db8c3c2e,IP:0,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-25
X-CID-META: VersionHash:0ef645f,CLOUDID:e496ea73-805e-40ad-809d-9cec088f3bd8,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|50,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 3bf13c46348411f082f7f7ac98dee637-20250519
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw02.mediatek.com
	(envelope-from <bo.ye@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 554549055; Mon, 19 May 2025 15:38:19 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Mon, 19 May 2025 15:38:17 +0800
Received: from mcddlt001.gcn.mediatek.inc (10.19.240.15) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Mon, 19 May 2025 15:38:16 +0800
From: Bo Ye <bo.ye@mediatek.com>
To: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
CC: <xiujuan.tan@mediatek.com>, Qilin Tan <qilin.tan@mediatek.com>, Bosser Ye
	<bo.ye@mediatek.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mediatek@lists.infradead.org>
Subject: [PATCH] scsi: ufs: preventing bus hang crash during emergency power off
Date: Mon, 19 May 2025 15:38:13 +0800
Message-ID: <20250519073814.167264-1-bo.ye@mediatek.com>
X-Mailer: git-send-email 2.17.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N

From: Qilin Tan <qilin.tan@mediatek.com>

When kernel_power_off is called directly without freezing userspace,
it may cause UFS crashes:

Callback:
    ...... 0xBFFFFFC080C6156C()
    vmlinux readl() + 52
    vmlinux ufshcd_add_command_trace() + 552
    vmlinux ufshcd_send_command() + 84

When kernel_power_off is executed, ufshcd_wl_shutdown is also called
to turn off the UFS reference clock, VCC, and VCCQ. If I/O requests
are still being sent to the UFS host and accessing the interrupt
status register at this time, AP read timeouts may occur, causing bus
hang crashes.

The root cause is that scsi_device_quiesce and blk_mq_freeze_queue
only drain the requests in the request queue but don't guarantee that
all requests have been dispatched to the UFS host and completed.
Requests may remain pending in the hardware dispatch queue and be
rescheduled later. If the UFS reference clock has already been turned
off at this point, a bus hang crash will occur.

Example of the race condition:
Thread 1                                                   Thread 2
kernel_power_off
-> ufshcd_wl_shutdown
 -> scsi_device_quiesce(sdev)
  -> blk_mq_freeze_queue(q)
   -> blk_mq_run_hw_queue(htx, false)
    -> blk_mq_delay_run_hw_queue(hctx, 0)                blk_mq_run_work_fn
 -> ufshcd_suspend(hba) // disable ref clk                -> blk_mq_dispatch_rq_list
                                                           -> blk_mq_run_hw_queue()
                                                            -> ufshcd_send_command()
                                                             -> ufshcd_add_command_trace()
                                                              -> ufshcd_readl(hba, REG_INTERRUPT_STATUS)

When Thread-2's dispatch request is delayed due to heavy CPU load,
the interrupt status register may be read after the reference clock
is disabled, resulting in a bus hang crash.

To avoid this issue, call ufshcd_wait_for_doorbell_clr to wait until
all requests are processed before disabling the reference clock.

Signed-off-by: Qilin Tan <qilin.tan@mediatek.com>
Signed-off-by: Bosser Ye <bo.ye@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 7735421e3991..a1013aea8e90 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10262,6 +10262,7 @@ static void ufshcd_wl_shutdown(struct device *dev)
 		scsi_device_set_state(sdev, SDEV_OFFLINE);
 		mutex_unlock(&sdev->state_mutex);
 	}
+	ufshcd_wait_for_doorbell_clr(hba, 5 * USEC_PER_SEC);
 	__ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM);
 
 	/*
-- 
2.17.0

