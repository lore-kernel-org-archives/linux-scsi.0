From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH 2/3] scsi_forget_host - scsi_debug usage
Date: Fri, 11 Jun 2004 21:22:32 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040612042232.GC21105@us.ibm.com>
References: <20040612041930.GA21105@us.ibm.com> <20040612042106.GB21105@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:36003 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S264633AbUFLEWS
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Jun 2004 00:22:18 -0400
Received: from westrelay05.boulder.ibm.com (westrelay05.boulder.ibm.com [9.17.193.33])
	by e35.co.us.ibm.com (8.12.10/8.12.2) with ESMTP id i5C4MHqF611158
	for <linux-scsi@vger.kernel.org>; Sat, 12 Jun 2004 00:22:17 -0400
Received: from hmsbounty.us.ibm.com (sig-9-49-143-70.mts.ibm.com [9.49.143.70])
	by westrelay05.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id i5C4MHvM267058
	for <linux-scsi@vger.kernel.org>; Fri, 11 Jun 2004 22:22:17 -0600
Content-Disposition: inline
In-Reply-To: <20040612042106.GB21105@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

DESC
scsi_forget_host - scsi_debug usage

Use the export scsi_forget_host interface to remove child scsi devices
from the scsi_host prior to removal.

Signed-off-by: Mike Anderson <andmike@us.ibm.com>
EDESC


 patched-2.6-andmike/drivers/scsi/scsi_debug.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/scsi/scsi_debug.c~use_scsi_forget_host drivers/scsi/scsi_debug.c
--- patched-2.6/drivers/scsi/scsi_debug.c~use_scsi_forget_host	Sat Jun 12 00:47:43 2004
+++ patched-2.6-andmike/drivers/scsi/scsi_debug.c	Sat Jun 12 00:52:50 2004
@@ -1725,6 +1725,7 @@ static int sdebug_driver_remove(struct d
 		return -ENODEV;
 	}
 
+	scsi_forget_host(sdbg_host->shost);
         scsi_remove_host(sdbg_host->shost);
 
         list_for_each_safe(lh, lh_sf, &sdbg_host->dev_info_list) {

_

