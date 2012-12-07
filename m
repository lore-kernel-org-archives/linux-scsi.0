From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 6/6] qla2xxx: Correction to the message ids.
Date: Fri,  7 Dec 2012 02:30:54 -0500
Message-ID: <1354865454-29964-7-git-send-email-saurav.kashyap@qlogic.com>
References: <1354865454-29964-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:46119 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755480Ab2LGHtk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Dec 2012 02:49:40 -0500
In-Reply-To: <1354865454-29964-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index f81e938..ba2d7a8 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -25,6 +25,7 @@
  * |                              |                    | 0x5047,0x5052  |
  * | Timer Routines               |       0x6011       |                |
  * | User Space Interactions      |       0x70c3       | 0x7018,0x702e, |
+ * |                              |                    | 0x7020,0x7024, |
  * |                              |                    | 0x7039,0x7045, |
  * |                              |                    | 0x7073-0x7075, |
  * |                              |                    | 0x708c,        |
-- 
1.7.7

