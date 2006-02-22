From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 3/9] lpfc 8.1.3 : Remove unused MBhostaddr from lpfc_sli structure
Date: Wed, 22 Feb 2006 12:33:31 -0500
Message-ID: <43FCA06B.4040402@emulex.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:54489 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1030322AbWBVRdj
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Feb 2006 12:33:39 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id k1MHXXrf029899
	for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2006 09:33:34 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>


Remove unused MBhostaddr from lpfc_sli structure

Signed-off-by: James Smart <James.Smart@emulex.com>

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

