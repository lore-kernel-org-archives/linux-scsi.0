From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 2/9] zfcp: Update message and add description
Date: Fri, 15 May 2009 13:18:15 +0200
Message-ID: <20090515112221.504529000@de.ibm.com>
References: <20090515111813.314177000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.17.162]:41654 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461AbZEOLWV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2009 07:22:21 -0400
Content-Disposition: inline; filename=701-zfcp-update-message.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Update the newly introduced message for the boxed status to conform to
match the style of s390 and zfcp messages.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_ccw.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/s390/scsi/zfcp_ccw.c	2009-05-15 12:56:02.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ccw.c	2009-05-15 12:56:11.000000000 +0200
@@ -176,8 +176,8 @@ static int zfcp_ccw_notify(struct ccw_de
 					"ccnoti4", NULL);
 		break;
 	case CIO_BOXED:
-		dev_warn(&adapter->ccw_device->dev,
-			 "The ccw device did not respond in time.\n");
+		dev_warn(&adapter->ccw_device->dev, "The FCP device "
+			 "did not respond within the specified time\n");
 		zfcp_erp_adapter_shutdown(adapter, 0, "ccnoti5", NULL);
 		break;
 	}

