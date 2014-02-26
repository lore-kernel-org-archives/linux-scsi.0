From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 21/23] qla2xxx: Correct the port no assignment for ISP82XX.
Date: Wed, 26 Feb 2014 04:15:16 -0500
Message-ID: <1393406118-6586-22-git-send-email-saurav.kashyap@qlogic.com>
References: <1393406118-6586-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:56123 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750748AbaBZJuw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Feb 2014 04:50:52 -0500
In-Reply-To: <1393406118-6586-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 61d42af..7b54e0a 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2271,7 +2271,7 @@ qla2x00_set_isp_flags(struct qla_hw_data *ha)
 	}
 
 	if (IS_QLA82XX(ha))
-		ha->port_no = !(ha->portnum & 1);
+		ha->port_no = ha->portnum & 1;
 	else {
 		/* Get adapter physical port no from interrupt pin register. */
 		pci_read_config_byte(ha->pdev, PCI_INTERRUPT_PIN, &ha->port_no);
-- 
1.7.7

