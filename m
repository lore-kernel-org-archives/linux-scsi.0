From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] SCSI: Update ASC list
Date: Wed, 28 Feb 2007 12:10:47 -0500
Message-ID: <yq14pp65ht4.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:54517 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933196AbXB1RLg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Feb 2007 12:11:36 -0500
Received: from rgmgw2.us.oracle.com (rgmgw2.us.oracle.com [138.1.186.111])
	by agminet01.oracle.com (Switch-3.2.4/Switch-3.1.7) with ESMTP id l1SHBY2B030489
	for <linux-scsi@vger.kernel.org>; Wed, 28 Feb 2007 11:11:35 -0600
Received: from rcsmt250.oracle.com (rcsmt250.oracle.com [148.87.90.195])
	by rgmgw2.us.oracle.com (Switch-3.2.4/Switch-3.1.7) with ESMTP id l1SGHYJd016793
	for <linux-scsi@vger.kernel.org>; Wed, 28 Feb 2007 10:11:34 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Add missing additional sense code and provide pointer to upstream
reference (from Doug Gilbert).

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

--- 

 constants.c |    5 +++++
 1 files changed, 5 insertions(+)


Index: scsi-misc-2.6/drivers/scsi/constants.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/constants.c
+++ scsi-misc-2.6/drivers/scsi/constants.c
@@ -404,6 +404,10 @@ struct error_info {
 	const char * text;
 };
 
+/*
+ * The canonical list of T10 Additional Sense Codes is available at:
+ * http://www.t10.org/lists/asc-num.txt
+ */
 static struct error_info additional[] =
 {
 	{0x0000, "No additional sense information"},
@@ -708,6 +712,7 @@ static struct error_info additional[] =
 
 	{0x2F00, "Commands cleared by another initiator"},
 	{0x2F01, "Commands cleared by power loss notification"},
+	{0x2F02, "Commands cleared by device server"},
 
 	{0x3000, "Incompatible medium installed"},
 	{0x3001, "Cannot read medium - unknown format"},
