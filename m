From: Brian King <brking@us.ibm.com>
Subject: [PATCH 5/5] ipr driver version 2.0.7
Date: Sat, 22 May 2004 19:52:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40AFF5CE.50400@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030309060400070607030409"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:65477 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262045AbUEWAwc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 May 2004 20:52:32 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------030309060400070607030409
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

--------------030309060400070607030409
Content-Type: text/plain;
 name="ipr_driver_version_2-0-7-5.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipr_driver_version_2-0-7-5.patch"


Bump driver version


---

 linux-2.6.6-bjking1/drivers/scsi/ipr.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_driver_version_2-0-7 drivers/scsi/ipr.h
--- linux-2.6.6/drivers/scsi/ipr.h~ipr_driver_version_2-0-7	2004-05-21 19:54:39.000000000 -0500
+++ linux-2.6.6-bjking1/drivers/scsi/ipr.h	2004-05-21 19:55:12.000000000 -0500
@@ -36,8 +36,8 @@
 /*
  * Literals
  */
-#define IPR_DRIVER_VERSION "2.0.6"
-#define IPR_DRIVER_DATE "(May 3, 2004)"
+#define IPR_DRIVER_VERSION "2.0.7"
+#define IPR_DRIVER_DATE "(May 21, 2004)"
 
 /*
  * IPR_DBG_TRACE: Setting this to 1 will turn on some general function tracing

_

--------------030309060400070607030409--

