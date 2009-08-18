From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 05/27] zfcp: Remove useless assignment
Date: Tue, 18 Aug 2009 15:43:10 +0200
Message-ID: <20090818135029.402833000@de.ibm.com>
References: <20090818134305.841868000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8.de.ibm.com ([195.212.29.157]:49779 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759006AbZHRNuj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2009 09:50:39 -0400
Content-Disposition: inline; filename=706-zfcp--useless-assignment.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Using a bitwise OR to not set anything at all is pointless so remove
the useless statement.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c |    1 -
 1 file changed, 1 deletion(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fsf.c linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6/drivers/s390/scsi/zfcp_fsf.c	2009-08-12 10:05:28.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c	2009-08-12 10:05:30.000000000 +0200
@@ -832,7 +832,6 @@ int zfcp_fsf_status_read(struct zfcp_ada
 	}
 
 	sbale = zfcp_qdio_sbale_req(req);
-	sbale[0].flags |= SBAL_FLAGS0_TYPE_STATUS;
 	sbale[2].flags |= SBAL_FLAGS_LAST_ENTRY;
 	req->sbale_curr = 2;
 

