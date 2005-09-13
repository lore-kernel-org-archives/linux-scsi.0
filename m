From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 9/9] iscsi: add module version
Date: Mon, 12 Sep 2005 21:02:06 -0500
Message-ID: <1126576926.29245.29.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:21433 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932407AbVIMCCf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Sep 2005 22:02:35 -0400
Received: from max (c-24-118-218-223.hsd1.mn.comcast.net [24.118.218.223])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id j8D22Y3w010049
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 12 Sep 2005 21:02:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

from michaelc@cs.wisc.edu

I have a bad memory. I cannot remember what versions are which,
so add a module version to help.

Signed-off-by: Alex Aizman <itn780@yahoo.com>
Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>


diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -49,7 +49,7 @@ MODULE_AUTHOR("Dmitry Yusupov <dmitry_yu
 	      "Alex Aizman <itn780@yahoo.com>");
 MODULE_DESCRIPTION("iSCSI/TCP data-path");
 MODULE_LICENSE("GPL");
-
+MODULE_VERSION("0:4.409");
 /* #define DEBUG_TCP */
 /* #define DEBUG_SCSI */
 #define DEBUG_ASSERT


