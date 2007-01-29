From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 12/14] qla2xxx: Fixup printk() with proper new-line character.
Date: Mon, 29 Jan 2007 10:22:29 -0800
Message-ID: <11700949512786-git-send-email-andrew.vasquez@qlogic.com>
References: <20070129182124.GA26940@andrew-vasquezs-computer.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:47719 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbXA2SWm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jan 2007 13:22:42 -0500
In-Reply-To: <20070129182124.GA26940@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 6c790dd..98c01cd 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -77,7 +77,7 @@ qla2x00_initialize_adapter(scsi_qla_host_t *ha)
 	qla_printk(KERN_INFO, ha, "Configuring PCI space...\n");
 	rval = ha->isp_ops.pci_config(ha);
 	if (rval) {
-		DEBUG2(printk("scsi(%ld): Unable to configure PCI space=n",
+		DEBUG2(printk("scsi(%ld): Unable to configure PCI space.\n",
 		    ha->host_no));
 		return (rval);
 	}
-- 
1.5.0.rc2.gdbaa0

