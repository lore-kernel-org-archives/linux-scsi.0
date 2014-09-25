From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 12/19] qla2xxx: Increase the request queue size to 8K for ISP2031
Date: Thu, 25 Sep 2014 04:10:05 -0400
Message-ID: <1411632612-7320-13-git-send-email-saurav.kashyap@qlogic.com>
References: <1411632612-7320-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:2081 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751930AbaIYIoQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 04:44:16 -0400
In-Reply-To: <1411632612-7320-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com

Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |    1 +
 drivers/scsi/qla2xxx/qla_os.c  |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index c9fe4cf..6e3b4f5 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -266,6 +266,7 @@
 #define REQUEST_ENTRY_CNT_2100		128	/* Number of request entries. */
 #define REQUEST_ENTRY_CNT_2200		2048	/* Number of request entries. */
 #define REQUEST_ENTRY_CNT_24XX		2048	/* Number of request entries. */
+#define REQUEST_ENTRY_CNT_83XX		8192	/* Number of request entries. */
 #define RESPONSE_ENTRY_CNT_2100		64	/* Number of response entries.*/
 #define RESPONSE_ENTRY_CNT_2300		512	/* Number of response entries.*/
 #define RESPONSE_ENTRY_CNT_MQ		128	/* Number of response entries.*/
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 437dc90..366ccf4 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2540,7 +2540,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ha->portnum = PCI_FUNC(ha->pdev->devfn);
 		ha->max_fibre_devices = MAX_FIBRE_DEVICES_2400;
 		ha->mbx_count = MAILBOX_REGISTER_COUNT;
-		req_length = REQUEST_ENTRY_CNT_24XX;
+		req_length = REQUEST_ENTRY_CNT_83XX;
 		rsp_length = RESPONSE_ENTRY_CNT_2300;
 		ha->tgt.atio_q_length = ATIO_ENTRY_CNT_24XX;
 		ha->max_loop_id = SNS_LAST_LOOP_ID_2300;
-- 
1.7.7

