From: Brian King <brking@us.ibm.com>
Subject: [PATCH 3/3] ipr bump version to 2.0.10
Date: Fri, 18 Jun 2004 16:17:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40D35C03.20004@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090909020909070003070101"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:53383 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S264518AbUFRVSA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jun 2004 17:18:00 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------090909020909070003070101
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

--------------090909020909070003070101
Content-Type: text/plain;
 name="ipr_driver_version_2_0_10.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipr_driver_version_2_0_10.patch"


Bump driver version



---

 linux-2.6.7-rc2-bjking1/drivers/scsi/ipr.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_driver_version_2_0_10 drivers/scsi/ipr.h
--- linux-2.6.7-rc2/drivers/scsi/ipr.h~ipr_driver_version_2_0_10	2004-06-07 17:11:31.000000000 -0500
+++ linux-2.6.7-rc2-bjking1/drivers/scsi/ipr.h	2004-06-07 17:11:42.000000000 -0500
@@ -36,8 +36,8 @@
 /*
  * Literals
  */
-#define IPR_DRIVER_VERSION "2.0.9"
-#define IPR_DRIVER_DATE "(May 26, 2004)"
+#define IPR_DRIVER_VERSION "2.0.10"
+#define IPR_DRIVER_DATE "(June 7, 2004)"
 
 /*
  * IPR_DBG_TRACE: Setting this to 1 will turn on some general function tracing

_

--------------090909020909070003070101--

