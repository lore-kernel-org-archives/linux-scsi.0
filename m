From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 01/22] SCSI: Add target reset flag to FCP header file
Date: Tue, 24 Nov 2009 16:53:57 +0100
Message-ID: <20091124160136.055381000@de.ibm.com>
References: <20091124155356.135092000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.17.164]:39598 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933236AbZKXQCQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2009 11:02:16 -0500
Content-Disposition: inline; filename=710-scsi-reset-flag.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

While the target reset task management function has been deprecated in
newer specs, it is still in use by SCSI FC drivers and there is no
real replacement. Add the target reset flag to the FCP header file to
allow usage of this definition in SCSI FC drivers.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 include/scsi/fc/fc_fcp.h |    2 ++
 1 file changed, 2 insertions(+)

diff -urpN linux-2.6/include/scsi/fc/fc_fcp.h linux-2.6-patched/include/scsi/fc/fc_fcp.h
--- linux-2.6/include/scsi/fc/fc_fcp.h	2009-09-10 00:13:59.000000000 +0200
+++ linux-2.6-patched/include/scsi/fc/fc_fcp.h	2009-11-23 09:59:42.000000000 +0100
@@ -83,6 +83,8 @@ struct fcp_cmnd32 {
  * fc_tm_flags - task management flags field.
  */
 #define	FCP_TMF_CLR_ACA		0x40	/* clear ACA condition */
+#define	FCP_TMF_TGT_RESET	0x20	/* target reset task management,
+					   deprecated as of FCP-3 */
 #define	FCP_TMF_LUN_RESET	0x10	/* logical unit reset task management */
 #define	FCP_TMF_CLR_TASK_SET	0x04	/* clear task set */
 #define	FCP_TMF_ABT_TASK_SET	0x02	/* abort task set */

