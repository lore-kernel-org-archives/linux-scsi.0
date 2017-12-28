From: chenxiang <chenxiang66@hisilicon.com>
Subject: [PATCH 1/2] ata: enhance the definition of SET MAX feature field value
Date: Thu, 28 Dec 2017 18:20:46 +0800
Message-ID: <1514456447-213928-2-git-send-email-chenxiang66@hisilicon.com>
References: <1514456447-213928-1-git-send-email-chenxiang66@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:3235 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751442AbdL1JeG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 28 Dec 2017 04:34:06 -0500
In-Reply-To: <1514456447-213928-1-git-send-email-chenxiang66@hisilicon.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, tj@kernel.org
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linuxarm@huawei.com, chenxiang <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>

There are two other values for SET MAX feature field according to ata
protocol. So definite them.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 include/linux/ata.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/ata.h b/include/linux/ata.h
index c7a3538..40d150a 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -448,6 +448,8 @@ enum {
 	ATA_SET_MAX_LOCK	= 0x02,
 	ATA_SET_MAX_UNLOCK	= 0x03,
 	ATA_SET_MAX_FREEZE_LOCK	= 0x04,
+	ATA_SET_MAX_PASSWD_DMA	= 0x05,
+	ATA_SET_MAX_UNLOCK_DMA	= 0x06,
 
 	/* feature values for DEVICE CONFIGURATION OVERLAY */
 	ATA_DCO_RESTORE		= 0xC0,
-- 
1.9.1
