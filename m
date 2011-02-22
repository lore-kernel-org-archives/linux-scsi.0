From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH 01/11] zfcp: Remove redundant unlikely()
Date: Tue, 22 Feb 2011 19:54:38 +0100
Message-ID: <20110222185535.973071925@linux.vnet.ibm.com>
References: <20110222185437.385767855@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:59152 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788Ab1BVSzn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2011 13:55:43 -0500
Content-Disposition: inline; filename=701-zfcp-remove-unlikely.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Tobias Klauser <tklauser@distanz.ch>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Tobias Klauser <tklauser@distanz.ch>

IS_ERR() already implies unlikely(), so it can be omitted here.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
---


 drivers/s390/scsi/zfcp_fsf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -1552,7 +1552,7 @@ int zfcp_fsf_open_wka_port(struct zfcp_f
 				  SBAL_FLAGS0_TYPE_READ,
 				  qdio->adapter->pool.erp_req);
 
-	if (unlikely(IS_ERR(req))) {
+	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out;
 	}
@@ -1605,7 +1605,7 @@ int zfcp_fsf_close_wka_port(struct zfcp_
 				  SBAL_FLAGS0_TYPE_READ,
 				  qdio->adapter->pool.erp_req);
 
-	if (unlikely(IS_ERR(req))) {
+	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out;
 	}

