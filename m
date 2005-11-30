From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 4/8] iscsi: add rdma extensions
Date: Tue, 29 Nov 2005 23:12:51 -0600
Message-ID: <1133327571.28356.41.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:48058 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751034AbVK3FNM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 00:13:12 -0500
Received: from [192.168.0.6] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id jAU5DATB009278
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 29 Nov 2005 23:13:11 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

>From Alex Nezhinsky:

Add login extensions for RDMA transports.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Alex Aizman <itn780@yahoo.com>
Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>

diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index be1bc79..99468d2 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -160,8 +160,9 @@ enum iscsi_param {
 	ISCSI_PARAM_ERL			= 11,
 	ISCSI_PARAM_IFMARKER_EN		= 12,
 	ISCSI_PARAM_OFMARKER_EN		= 13,
+	ISCSI_PARAM_RDMAEXTENSIONS      = 14,
 };
-#define ISCSI_PARAM_MAX			14
+#define ISCSI_PARAM_MAX			15
 
 typedef uint64_t iscsi_sessionh_t;	/* iSCSI Data-Path session handle */
 typedef uint64_t iscsi_connh_t;		/* iSCSI Data-Path connection handle */


