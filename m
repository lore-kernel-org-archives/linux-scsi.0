From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH] qla2xxx: Remove unavailable firmware files
Date: Tue, 17 Nov 2015 15:03:37 -0500
Message-ID: <1447790617-1410-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:23402 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751705AbbKQUne (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 15:43:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, martin.petersen@oracle.com
Cc: giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, linux-scsi@vger.kernel.org

Remove firmware binary names for the ISPs, which
are not submitted to linux-firmware

Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Julian Calaby <julian.calaby@gmail.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index bfa9a64..6be32fd 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5843,6 +5843,3 @@ MODULE_FIRMWARE(FW_FILE_ISP2300);
 MODULE_FIRMWARE(FW_FILE_ISP2322);
 MODULE_FIRMWARE(FW_FILE_ISP24XX);
 MODULE_FIRMWARE(FW_FILE_ISP25XX);
-MODULE_FIRMWARE(FW_FILE_ISP2031);
-MODULE_FIRMWARE(FW_FILE_ISP8031);
-MODULE_FIRMWARE(FW_FILE_ISP27XX);
-- 
1.7.7

