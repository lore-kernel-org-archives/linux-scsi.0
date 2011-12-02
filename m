From: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Subject: RE: [PATCH] [SCSI] mpt2sas: Remove unused duplicate
 diag_buffer_enable param
Date: Fri, 2 Dec 2011 15:08:40 +0530
Message-ID: <A6888A6805518E4EA4AF7072A28264A6047278D3A8@inbmail02.lsi.com>
References: <1322676350-2018-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:45616 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751680Ab1LBJit convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Dec 2011 04:38:49 -0500
In-Reply-To: <1322676350-2018-1-git-send-email-roland@kernel.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, James Bottomley <jejb@kernel.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

This patch seem to be fine.
Please consider this patch as acked by me.

Regards,
Nagalakshmi


-----Original Message-----
From: Roland Dreier [mailto:roland@purestorage.com] On Behalf Of Roland Dreier
Sent: Wednesday, November 30, 2011 11:36 PM
To: James E.J. Bottomley
Cc: Nandigama, Nagalakshmi; linux-scsi@vger.kernel.org
Subject: [PATCH] [SCSI] mpt2sas: Remove unused duplicate diag_buffer_enable param

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

