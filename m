From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH 02/11] zfcp: Remove unused flag ZFCP_STATUS_FSFREQ_TASK_MANAGEMENT
Date: Tue, 22 Feb 2011 19:54:39 +0100
Message-ID: <20110222185536.124886468@linux.vnet.ibm.com>
References: <20110222185437.385767855@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:59147 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685Ab1BVSzi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2011 13:55:38 -0500
Content-Disposition: inline; filename=702-zfcp-unused-flag.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Remove the now unused flag ZFCP_STATUS_FSFREQ_TASK_MANAGEMENT.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
---


 drivers/s390/scsi/zfcp_def.h |    1 -
 drivers/s390/scsi/zfcp_fsf.c |    1 -
 2 files changed, 2 deletions(-)
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -89,7 +89,6 @@ struct zfcp_reqlist;
 #define ZFCP_STATUS_LUN_READONLY		0x00000008
 
 /* FSF request status (this does not have a common part) */
-#define ZFCP_STATUS_FSFREQ_TASK_MANAGEMENT	0x00000002
 #define ZFCP_STATUS_FSFREQ_ERROR		0x00000008
 #define ZFCP_STATUS_FSFREQ_CLEANUP		0x00000010
 #define ZFCP_STATUS_FSFREQ_ABORTSUCCEEDED	0x00000040
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -2284,7 +2284,6 @@ struct zfcp_fsf_req *zfcp_fsf_fcp_task_m
 		goto out;
 	}
 
-	req->status |= ZFCP_STATUS_FSFREQ_TASK_MANAGEMENT;
 	req->data = scmnd;
 	req->handler = zfcp_fsf_fcp_task_mgmt_handler;
 	req->qtcb->header.lun_handle = zfcp_sdev->lun_handle;

