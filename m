From: james.smart@avagotech.com (James Smart)
Subject: [PATCH 14/14] lpfc: Update version to 11.0.0.0 for upstream patch set
Date: Mon, 31 Aug 2015 16:48:22 -0400
Message-ID: <55e4bd96.ieZitv3jHOr0EOKp%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f46.google.com ([209.85.192.46]:36660 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbbHaUsi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Aug 2015 16:48:38 -0400
Received: by qgeb6 with SMTP id b6so73669723qge.3
        for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2015 13:48:37 -0700 (PDT)
Received: from myfc17 (c-75-67-235-135.hsd1.nh.comcast.net. [75.67.235.135])
        by smtp.gmail.com with ESMTPSA id 95sm6632849qgt.12.2015.08.31.13.48.36
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Mon, 31 Aug 2015 13:48:36 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Update version to 11.0.0.0 for upstream patch set

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 6258d3d..ea53aa6 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "10.7.0.0."
+#define LPFC_DRIVER_VERSION "11.0.0.0."
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
1.7.11.7

