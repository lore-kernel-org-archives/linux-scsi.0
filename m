From: Roland Dreier <roland@kernel.org>
Subject: [PATCH] [SCSI] mpt2sas: Remove unused duplicate diag_buffer_enable param
Date: Wed, 30 Nov 2011 10:05:50 -0800
Message-ID: <1322676350-2018-1-git-send-email-roland@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog105.obsmtp.com ([74.125.245.78]:56239 "HELO
	na3sys010aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752278Ab1K3SLD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2011 13:11:03 -0500
Received: by mail-gy0-f178.google.com with SMTP id f1so940702ghb.9
        for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2011 10:11:02 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>, linux-scsi@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

Commit 921cd8024b90 ("[SCSI] mpt2sas: New feature - Fast Load
Support") moved handling of the diag_buffer_enable module parameter
from mpt2sas_base.c to mpt2sas_scsih.c, but it left an old copy of the
parameter in mpt2sas_base.c.  Remove the unused stub.

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index beda04a..b3ad90e 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -89,19 +89,6 @@ static int disable_discovery = -1;
 module_param(disable_discovery, int, 0);
 MODULE_PARM_DESC(disable_discovery, " disable discovery ");
 
-
-/* diag_buffer_enable is bitwise
- * bit 0 set = TRACE
- * bit 1 set = SNAPSHOT
- * bit 2 set = EXTENDED
- *
- * Either bit can be set, or both
- */
-static int diag_buffer_enable;
-module_param(diag_buffer_enable, int, 0);
-MODULE_PARM_DESC(diag_buffer_enable, " post diag buffers "
-    "(TRACE=1/SNAPSHOT=2/EXTENDED=4/default=0)");
-
 /**
  * _scsih_set_fwfault_debug - global setting of ioc->fwfault_debug.
  *
-- 
1.7.5.4

