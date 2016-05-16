From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: [PATCH 1/2] ufs: Test Chip pci driver not dependent of Samsung's
Date: Mon, 16 May 2016 19:59:01 +0100
Message-ID: <985f5be4b7984b8c9a50d4b2d5436ef1cd3e69c0.1463424861.git.jpinto@synopsys.com>
References: <cover.1463424861.git.jpinto@synopsys.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.47.9]:46940 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736AbcEPS7N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 May 2016 14:59:13 -0400
In-Reply-To: <cover.1463424861.git.jpinto@synopsys.com>
In-Reply-To: <cover.1463424861.git.jpinto@synopsys.com>
References: <cover.1463424861.git.jpinto@synopsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Joao Pinto <Joao.Pinto@synopsys.com>

This patch breaks the dependency between the two drivers, because they are
completely indenpendent.

Signed-off-by: Joao Pinto <jpinto@synopsys.com>
---
 drivers/scsi/ufs/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index e27b4d4..4796690 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -63,7 +63,7 @@ config SCSI_UFSHCD_PCI
 
 config SCSI_UFS_DWC_TC_PCI
 	tristate "DesignWare pci support using a G210 Test Chip"
-	depends on SCSI_UFSHCD_PCI
+	depends on SCSI_UFSHCD && PCI
 	---help---
 	  Synopsys Test Chip is a PHY for prototyping purposes.
 
-- 
1.8.1.5

