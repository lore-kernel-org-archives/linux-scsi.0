From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] SCSI: Update ASC list and make it const
Date: Wed, 28 Feb 2007 12:37:06 -0500
Message-ID: <yq1lkii420t.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:14741 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933278AbXB1RiT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Feb 2007 12:38:19 -0500
Received: from rgmgw1.us.oracle.com (rgmgw1.us.oracle.com [138.1.186.110])
	by agminet01.oracle.com (Switch-3.2.4/Switch-3.1.7) with ESMTP id l1SHcGqm009773
	for <linux-scsi@vger.kernel.org>; Wed, 28 Feb 2007 11:38:17 -0600
Received: from rcsmt251.oracle.com (rcsmt251.oracle.com [148.87.90.196])
	by rgmgw1.us.oracle.com (Switch-3.2.4/Switch-3.1.7) with ESMTP id l1SHJgrO015192
	for <linux-scsi@vger.kernel.org>; Wed, 28 Feb 2007 10:38:15 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Add missing additional sense code and provide pointer to upstream
reference (from Doug Gilbert).

Add missing const (from Michael Tokarev).

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

--- 

 constants.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletion(-)


Index: scsi-misc-2.6/drivers/scsi/constants.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/constants.c
+++ scsi-misc-2.6/drivers/scsi/constants.c
@@ -404,7 +404,11 @@ struct error_info {
 	const char * text;
 };
 
-static struct error_info additional[] =
+/*
+ * The canonical list of T10 Additional Sense Codes is available at:
+ * http://www.t10.org/lists/asc-num.txt
+ */
+static const struct error_info additional[] =
 {
 	{0x0000, "No additional sense information"},
 	{0x0001, "Filemark detected"},
@@ -708,6 +712,7 @@ static struct error_info additional[] =
 
 	{0x2F00, "Commands cleared by another initiator"},
 	{0x2F01, "Commands cleared by power loss notification"},
+	{0x2F02, "Commands cleared by device server"},
 
 	{0x3000, "Incompatible medium installed"},
 	{0x3001, "Cannot read medium - unknown format"},
