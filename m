From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 18/35] qla2xxx: Fix driver version string message.
Date: Wed, 24 Sep 2014 03:08:21 -0400
Message-ID: <1411542518-2477-19-git-send-email-saurav.kashyap@qlogic.com>
References: <1411542518-2477-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:29713 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753119AbaIXHmq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2014 03:42:46 -0400
In-Reply-To: <1411542518-2477-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Himanshu Madhani <himanshu.madhani@qlogic.com>

Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_sup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 4788ecd0..b656a05 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -3092,7 +3092,7 @@ qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 		ha->fw_revision[2] = dcode[2];
 		ha->fw_revision[3] = dcode[3];
 		ql_dbg(ql_dbg_init, vha, 0x0060,
-		    "Firmware revision %d.%d.%d.%d.\n",
+		    "Firmware revision %d.%d.%d (%x).\n",
 		    ha->fw_revision[0], ha->fw_revision[1],
 		    ha->fw_revision[2], ha->fw_revision[3]);
 	}
-- 
1.7.7

