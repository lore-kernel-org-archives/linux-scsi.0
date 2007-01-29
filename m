From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 1/14] qla2xxx: Correct sector-erase issues while writing flash.
Date: Mon, 29 Jan 2007 10:22:18 -0800
Message-ID: <11700949512654-git-send-email-andrew.vasquez@qlogic.com>
References: <20070129182124.GA26940@andrew-vasquezs-computer.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:47715 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbXA2SWe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jan 2007 13:22:34 -0500
In-Reply-To: <20070129182124.GA26940@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_sup.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 15390ad..7bbe751 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -611,7 +611,6 @@ qla24xx_write_flash_data(scsi_qla_host_t *ha, uint32_t *dwptr, uint32_t faddr,
 					    flash_conf_to_access_addr(0x0339),
 					    (fdata & 0xff00) | ((fdata << 16) &
 					    0xff0000) | ((fdata >> 16) & 0xff));
-				fdata = (faddr & sec_mask) << 2;
 				ret = qla24xx_write_flash_dword(ha, conf_addr,
 				    (fdata & 0xff00) |((fdata << 16) &
 				    0xff0000) | ((fdata >> 16) & 0xff));
-- 
1.5.0.rc2.gdbaa0

