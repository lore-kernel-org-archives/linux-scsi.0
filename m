From: james.smart@avagotech.com (James Smart)
Subject: [PATCH 9/9] lpfc: Update version to 10.7.0.0 for upstream patch
 set.
Date: Fri, 22 May 2015 10:42:44 -0400
Message-ID: <555f4064.lj3VEQREEJvgGpYz%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f43.google.com ([209.85.192.43]:34848 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757052AbbEVOmy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2015 10:42:54 -0400
Received: by qgew3 with SMTP id w3so9075753qge.2
        for <linux-scsi@vger.kernel.org>; Fri, 22 May 2015 07:42:53 -0700 (PDT)
Received: from myfc17 (c-75-67-235-135.hsd1.nh.comcast.net. [75.67.235.135])
        by mx.google.com with ESMTPSA id 93sm1408538qkx.38.2015.05.22.07.42.52
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Fri, 22 May 2015 07:42:52 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Update version to 10.7.0.0 for upstream patch set.

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 8b96d10..6258d3d 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "10.6.0.1."
+#define LPFC_DRIVER_VERSION "10.7.0.0."
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
1.7.11.7

