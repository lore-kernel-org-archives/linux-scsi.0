From: Brian King <brking@us.ibm.com>
Subject: [PATCH 3/3] ipr driver version 2.0.8
Date: Mon, 24 May 2004 09:39:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40B20928.3040500@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000905010400050801050408"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.102]:62099 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S264299AbUEXOji (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 May 2004 10:39:38 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------000905010400050801050408
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

--------------000905010400050801050408
Content-Type: text/plain;
 name="ipr_driver_version_2_0_8.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipr_driver_version_2_0_8.patch"


Bump driver version


---

 linux-2.6.6-bjking1/drivers/scsi/ipr.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_driver_version_2_0_8 drivers/scsi/ipr.h
--- linux-2.6.6/drivers/scsi/ipr.h~ipr_driver_version_2_0_8	2004-05-23 21:48:12.000000000 -0500
+++ linux-2.6.6-bjking1/drivers/scsi/ipr.h	2004-05-23 21:48:22.000000000 -0500
@@ -36,8 +36,8 @@
 /*
  * Literals
  */
-#define IPR_DRIVER_VERSION "2.0.7"
-#define IPR_DRIVER_DATE "(May 21, 2004)"
+#define IPR_DRIVER_VERSION "2.0.8"
+#define IPR_DRIVER_DATE "(May 23, 2004)"
 
 /*
  * IPR_DBG_TRACE: Setting this to 1 will turn on some general function tracing

_

--------------000905010400050801050408--

