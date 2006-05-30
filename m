From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 5/5] iscsi update: update version
Date: Tue, 30 May 2006 01:04:51 -0500
Message-ID: <1148969091.3652.0.camel@max>
References: <1148967451.3005.17.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:26807 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932144AbWE3GFM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 May 2006 02:05:12 -0400
Received: from [192.168.0.7] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id k4U64ps6027119
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 30 May 2006 01:05:11 -0500
In-Reply-To: <1148967451.3005.17.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Resending the patch with my signed off line.


Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 7fa8593..b4743a9 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -43,7 +43,7 @@
 
 #include "iscsi_tcp.h"
 
-#define ISCSI_TCP_VERSION "1.0-574"
+#define ISCSI_TCP_VERSION "1.0-595"
 
 MODULE_AUTHOR("Dmitry Yusupov <dmitry_yus@yahoo.com>, "
 	      "Alex Aizman <itn780@yahoo.com>");


