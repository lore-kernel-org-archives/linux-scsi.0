From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2] lpfc: add missing Kconfig NVME dependencies
Date: Wed, 22 Feb 2017 12:16:50 -0800
Message-ID: <58adf1b2.pGf0m6CGsoX83xvw%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:34821 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933786AbdBVU2p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2017 15:28:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.com, martin.petersen@oracle.com, dick.kennedy@broadcom.com, linux-next@vger.kernel.org, sfr@canb.auug.org.au, linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org


add missing Kconfig NVME dependencies

-- james

Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index d4023bf..2558434 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1240,6 +1240,7 @@ config SCSI_LPFC
 	tristate "Emulex LightPulse Fibre Channel Support"
 	depends on PCI && SCSI
 	depends on SCSI_FC_ATTRS
+	depends on NVME_FC && NVME_TARGET_FC
 	select CRC_T10DIF
 	help
           This lpfc driver supports the Emulex LightPulse
-- 
2.5.0
