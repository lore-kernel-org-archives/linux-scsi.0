From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: [PATCH] scsi: ufs: Kconfig fix
Date: Fri, 23 Sep 2016 12:52:52 +0100
Message-ID: <68bc8a512ea93a41be92f83fc664efd724855ced.1474631254.git.jpinto@synopsys.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtprelay4.synopsys.com ([198.182.47.9]:39795 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935881AbcIWLw4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Sep 2016 07:52:56 -0400
Received: from dc8secmta1.synopsys.com (dc8secmta1.synopsys.com [10.13.218.200])
        by smtprelay.synopsys.com (Postfix) with ESMTP id F098B24E2019
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2016 04:52:55 -0700 (PDT)
Received: from dc8secmta1.internal.synopsys.com (dc8secmta1.internal.synopsys.com [127.0.0.1])
        by dc8secmta1.internal.synopsys.com (Service) with ESMTP id E450C27113
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2016 04:52:55 -0700 (PDT)
Received: from mailhost.synopsys.com (mailhost1.synopsys.com [10.12.238.239])
        by dc8secmta1.internal.synopsys.com (Service) with ESMTP id C69E927102
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2016 04:52:55 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Manjunath.MB@synopsys.com, Joao Pinto <Joao.Pinto@synopsys.com>

Currently if we have PCI and UFSHCD configured in the kernel, both
SCSI_UFS_DWC_TC_PCI and SCSI_UFSHCD_PCI show up, which is not correct.
This patch changes the UFS Kconfig to assure hierarchy between the 2
options.

Signed-off-by: Joao Pinto <jpinto@synopsys.com>
---
 drivers/scsi/ufs/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 4796690..e27b4d4 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -63,7 +63,7 @@ config SCSI_UFSHCD_PCI
 
 config SCSI_UFS_DWC_TC_PCI
 	tristate "DesignWare pci support using a G210 Test Chip"
-	depends on SCSI_UFSHCD && PCI
+	depends on SCSI_UFSHCD_PCI
 	---help---
 	  Synopsys Test Chip is a PHY for prototyping purposes.
 
-- 
1.8.1.5

