From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 10/10] iscsi: update version
Date: Thu, 12 Jan 2006 23:08:50 -0600
Message-ID: <1137128930.9508.44.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:2992 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S964928AbWAMFJf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 00:09:35 -0500
Received: from [192.168.0.6] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id k0D59Ymw016466
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 12 Jan 2006 23:09:35 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

update version

Signed-off-by: Alex Aizman <itn780@yahoo.com>
Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>


diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 8146cf9..cd663f1 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -50,7 +50,7 @@ MODULE_AUTHOR("Dmitry Yusupov <dmitry_yu
 	      "Alex Aizman <itn780@yahoo.com>");
 MODULE_DESCRIPTION("iSCSI/TCP data-path");
 MODULE_LICENSE("GPL");
-MODULE_VERSION("0:4.445");
+MODULE_VERSION("0:5.456");
 /* #define DEBUG_TCP */
 /* #define DEBUG_SCSI */
 #define DEBUG_ASSERT


