From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 6/6] iscsi update: update version
Date: Thu, 18 May 2006 20:31:43 -0500
Message-ID: <1148002303.3248.27.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:62084 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932211AbWESBek (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 May 2006 21:34:40 -0400
Received: from [192.168.0.4] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id k4J1YJtj007225
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 18 May 2006 20:34:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

update version

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>


diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 08357a6..c66faee 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -43,11 +43,13 @@
 
 #include "iscsi_tcp.h"
 
+#define ISCSI_TCP_VERSION "1.0-574"
+
 MODULE_AUTHOR("Dmitry Yusupov <dmitry_yus@yahoo.com>, "
 	      "Alex Aizman <itn780@yahoo.com>");
 MODULE_DESCRIPTION("iSCSI/TCP data-path");
 MODULE_LICENSE("GPL");
-MODULE_VERSION("0:4.445");
+MODULE_VERSION(ISCSI_TCP_VERSION);
 /* #define DEBUG_TCP */
 #define DEBUG_ASSERT
 
@@ -2448,8 +2450,8 @@ static void iscsi_tcp_session_destroy(st
 }
 
 static struct scsi_host_template iscsi_sht = {
-	.name			= "iSCSI Initiator over TCP/IP, v."
-				  ISCSI_VERSION_STR,
+	.name			= "iSCSI Initiator over TCP/IP, v"
+				  ISCSI_TCP_VERSION,
 	.queuecommand           = iscsi_queuecommand,
 	.change_queue_depth	= iscsi_change_queue_depth,
 	.can_queue		= ISCSI_XMIT_CMDS_MAX - 1,
diff --git a/include/scsi/iscsi_proto.h b/include/scsi/iscsi_proto.h
index 4feda05..02f6e4b 100644
--- a/include/scsi/iscsi_proto.h
+++ b/include/scsi/iscsi_proto.h
@@ -21,8 +21,6 @@
 #ifndef ISCSI_PROTO_H
 #define ISCSI_PROTO_H
 
-#define ISCSI_VERSION_STR	"0.3"
-#define ISCSI_DATE_STR		"22-Apr-2005"
 #define ISCSI_DRAFT20_VERSION	0x00
 
 /* default iSCSI listen port for incoming connections */


