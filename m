From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: [PATCH v16 1/9] ufs: fixed typo in ufshcd-pltfrm
Date: Wed, 11 May 2016 12:21:25 +0100
Message-ID: <677542fd2a797d5e1c023cd90ca215067400fad5.1462963164.git.jpinto@synopsys.com>
References: <cover.1462963164.git.jpinto@synopsys.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:36282 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbcEKLVm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 May 2016 07:21:42 -0400
In-Reply-To: <cover.1462963164.git.jpinto@synopsys.com>
In-Reply-To: <cover.1462963164.git.jpinto@synopsys.com>
References: <cover.1462963164.git.jpinto@synopsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Joao Pinto <Joao.Pinto@synopsys.com>

Fixed typo in ufshcd-pltfrm.

Signed-off-by: Joao Pinto <jpinto@synopsys.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
Changes v0->v16:
- Nothing changed (just to keep up with patch set version).

 drivers/scsi/ufs/ufshcd-pltfrm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 718f12e..db53f38 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -372,6 +372,6 @@ EXPORT_SYMBOL_GPL(ufshcd_pltfrm_init);
 
 MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>");
 MODULE_AUTHOR("Vinayak Holikatti <h.vinayak@samsung.com>");
-MODULE_DESCRIPTION("UFS host controller Pltform bus based glue driver");
+MODULE_DESCRIPTION("UFS host controller Platform bus based glue driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(UFSHCD_DRIVER_VERSION);
-- 
1.8.1.5

