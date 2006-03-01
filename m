From: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
Subject: [PATCH 3/9] lpfc 8.1.3: Remove unused MBhostaddr from lpfc_sli structure
Date: Tue, 28 Feb 2006 22:33:06 -0500
Message-ID: <20060301033306.GA21516@shrimp.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shrimp.ma.emulex.com ([138.239.78.42]:9169 "EHLO
	shrimp.ma.emulex.com") by vger.kernel.org with ESMTP
	id S1750805AbWCADdJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 22:33:09 -0500
Received: from shrimp.ma.emulex.com (localhost.localdomain [127.0.0.1])
	by shrimp.ma.emulex.com (8.13.4/8.13.4) with ESMTP id k213X6bR021523
	for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2006 22:33:06 -0500
Received: (from jamesw@localhost)
	by shrimp.ma.emulex.com (8.13.4/8.13.4/Submit) id k213X64E021521
	for linux-scsi@vger.kernel.org; Tue, 28 Feb 2006 22:33:06 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Remove unused MBhostaddr from lpfc_sli structure

Signed-off-by: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_sli.h
+++ b/drivers/scsi/lpfc/lpfc_sli.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2005 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2006 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  *                                                                 *
@@ -199,8 +199,6 @@ struct lpfc_sli {
 	struct timer_list mbox_tmo;	/* Hold clk to timeout active mbox
 					   cmd */
 
-	uint32_t *MBhostaddr;	/* virtual address for mbox cmds */
-
 #define LPFC_IOCBQ_LOOKUP_INCREMENT  1024
 	struct lpfc_iocbq ** iocbq_lookup; /* array to lookup IOCB by IOTAG */
 	size_t iocbq_lookup_len;           /* current lengs of the array */
