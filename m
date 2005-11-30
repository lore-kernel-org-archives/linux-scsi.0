From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 8/8] iscsi: update version
Date: Tue, 29 Nov 2005 23:13:01 -0600
Message-ID: <1133327581.28356.45.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:50106 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751038AbVK3FNk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 00:13:40 -0500
Received: from [192.168.0.6] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id jAU5DcdP009291
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 29 Nov 2005 23:13:39 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Update driver version

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Alex Aizman <itn780@yahoo.com>
Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>


diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index d9658b0..e6f9542 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -49,7 +49,7 @@ MODULE_AUTHOR("Dmitry Yusupov <dmitry_yu
 	      "Alex Aizman <itn780@yahoo.com>");
 MODULE_DESCRIPTION("iSCSI/TCP data-path");
 MODULE_LICENSE("GPL");
-MODULE_VERSION("0:4.409");
+MODULE_VERSION("0:4.445");
 /* #define DEBUG_TCP */
 /* #define DEBUG_SCSI */
 #define DEBUG_ASSERT


