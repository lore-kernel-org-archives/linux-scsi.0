From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 01/42] qla2xxx: Bind to ISP8031 devices.
Date: Wed, 22 Aug 2012 14:20:55 -0400
Message-ID: <1345659696-3670-2-git-send-email-chad.dupuis@qlogic.com>
References: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:62806 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S964862Ab2HVSiK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 14:38:10 -0400
In-Reply-To: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index fb8cd38..18237a6 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4495,6 +4495,7 @@ static struct pci_device_id qla2xxx_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2031) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP8001) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP8021) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP8031) },
 	{ 0 },
 };
 MODULE_DEVICE_TABLE(pci, qla2xxx_pci_tbl);
-- 
1.7.7

