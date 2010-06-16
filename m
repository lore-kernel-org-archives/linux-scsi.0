From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 11/11] qla4xxx: Update driver version to 5.02.00-k2
Date: Thu, 17 Jun 2010 02:28:40 +0530
Message-ID: <20100616205840.GA8229@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:37550
	"HELO sles11sp1b1.site" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1753415Ab0FPVAL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jun 2010 17:00:11 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: ravi.anand@qlogic.com, vikas.chaudhary@qlogic.com

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_version.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_version.h b/drivers/scsi/qla4xxx/ql4_version.h
index 28a6c49..c905dbd 100644
--- a/drivers/scsi/qla4xxx/ql4_version.h
+++ b/drivers/scsi/qla4xxx/ql4_version.h
@@ -5,4 +5,4 @@
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
 
-#define QLA4XXX_DRIVER_VERSION	"5.02.00-k1"
+#define QLA4XXX_DRIVER_VERSION	"5.02.00-k2"
-- 
1.7.0.5

