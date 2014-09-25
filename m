From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH RESEND 18/35] qla2xxx: Fix driver version string message.
Date: Thu, 25 Sep 2014 05:16:49 -0400
Message-ID: <1411636626-7566-19-git-send-email-saurav.kashyap@qlogic.com>
References: <1411636626-7566-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:21019 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753028AbaIYJvW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 05:51:22 -0400
In-Reply-To: <1411636626-7566-1-git-send-email-saurav.kashyap@qlogic.com>
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

