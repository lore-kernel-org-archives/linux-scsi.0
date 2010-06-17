From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 4/4] ibmvscsi: Driver version 1.5.9
Date: Thu, 17 Jun 2010 13:56:04 -0500
Message-ID: <201006171856.o5HIu42J013144@d03av02.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:59640 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933148Ab0FQS4M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jun 2010 14:56:12 -0400
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e36.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id o5HIqp25007959
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jun 2010 12:52:51 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o5HIu5RC129254
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jun 2010 12:56:06 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o5HIu5MJ013209
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jun 2010 12:56:05 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Bump driver version

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvscsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_version_1_5_9 drivers/scsi/ibmvscsi/ibmvscsi.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_version_1_5_9	2010-06-17 13:21:48.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c	2010-06-17 13:21:48.000000000 -0500
@@ -102,7 +102,7 @@ static int client_reserve = 1;
 
 static struct scsi_transport_template *ibmvscsi_transport_template;
 
-#define IBMVSCSI_VERSION "1.5.8"
+#define IBMVSCSI_VERSION "1.5.9"
 
 static struct ibmvscsi_ops *ibmvscsi_ops;
 
_
