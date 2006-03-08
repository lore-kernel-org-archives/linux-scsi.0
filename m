From: ravi.anand@qlogic.com
Subject: [PATCH 10/11] Update Driver Version to 5.00.05b5-k
Date: Tue, 7 Mar 2006 16:36:03 -0800
Message-ID: <11417781582555-git-send-email-ravi.anand@qlogic.com>
References: <11417781172980-git-send-email-ravi.anand@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:14835 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S964860AbWCHAgH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2006 19:36:07 -0500
In-Reply-To: <11417781172980-git-send-email-ravi.anand@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, arjan@infradead.org
Cc: ravi.anand@qlogic.com

Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>


---

 drivers/scsi/qla4xxx/ql4_version.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

0cf84f6a4c45b98117ebaac7119d1582328f30a1
diff --git a/drivers/scsi/qla4xxx/ql4_version.h b/drivers/scsi/qla4xxx/ql4_version.h
index 49a81de..c9326b4 100644
--- a/drivers/scsi/qla4xxx/ql4_version.h
+++ b/drivers/scsi/qla4xxx/ql4_version.h
@@ -5,9 +5,9 @@
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
 
-#define QLA4XXX_DRIVER_VERSION      "5.00.05b4-k"
+#define QLA4XXX_DRIVER_VERSION      "5.00.05b5-k"
 
 #define QL4_DRIVER_MAJOR_VER	5
 #define QL4_DRIVER_MINOR_VER	0
 #define QL4_DRIVER_PATCH_VER	5
-#define QL4_DRIVER_BETA_VER	3
+#define QL4_DRIVER_BETA_VER	5
-- 
1.2.4.g9201-dirty


