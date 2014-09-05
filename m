From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH] mpt2sas: remove duplicate disable_discovery MODULE_PARAM
Date: Fri, 5 Sep 2014 12:30:25 -0400
Message-ID: <1409934625-10129-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c11o142.mxlogic.net ([208.65.144.65]:52606 "EHLO
	p01c11o142.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbaIEQan (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Sep 2014 12:30:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Joe Lawrence <joe.lawrence@stratus.com>

The disable_discovery module parameter is declared and only used by
mpt2sas_scsih.c. Remove the extra copy in mpt2sas_base.c.

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index cf51b48..bb8dcb0 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -84,10 +84,6 @@ static int mpt2sas_fwfault_debug;
 MODULE_PARM_DESC(mpt2sas_fwfault_debug, " enable detection of firmware fault "
 	"and halt firmware - (default=0)");
 
-static int disable_discovery = -1;
-module_param(disable_discovery, int, 0);
-MODULE_PARM_DESC(disable_discovery, " disable discovery ");
-
 /**
  * _scsih_set_fwfault_debug - global setting of ioc->fwfault_debug.
  *
-- 
1.7.10.4

