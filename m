From: Cao jin <caoj.fnst@cn.fujitsu.com>
Subject: [PATCH] scsi/qla4: comments correction
Date: Mon, 19 Dec 2016 14:20:29 +0800
Message-ID: <1482128429-17975-1-git-send-email-caoj.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11138 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750763AbcLSGQJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Dec 2016 01:16:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: QLogic-Storage-Upstream@qlogic.com, linux-scsi@vger.kernel.org
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com

Signed-off-by: Cao jin <caoj.fnst@cn.fujitsu.com>
---
 drivers/scsi/qla4xxx/ql4_os.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 01c3610a60cf..fc60e0a1043e 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -9546,15 +9546,15 @@ static int qla4xxx_host_reset(struct Scsi_Host *shost, int reset_type)
  * driver calls the following device driver's callbacks
  *
  * - Fatal Errors - link_reset
- * - Non-Fatal Errors - driver's pci_error_detected() which
+ * - Non-Fatal Errors - driver's error_detected() which
  * returns CAN_RECOVER, NEED_RESET or DISCONNECT.
  *
  * PCI AER driver calls
- * CAN_RECOVER - driver's pci_mmio_enabled(), mmio_enabled
+ * CAN_RECOVER - driver's mmio_enabled(), mmio_enabled()
  *               returns RECOVERED or NEED_RESET if fw_hung
  * NEED_RESET - driver's slot_reset()
  * DISCONNECT - device is dead & cannot recover
- * RECOVERED - driver's pci_resume()
+ * RECOVERED - driver's resume()
  */
 static pci_ers_result_t
 qla4xxx_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
-- 
2.1.0



