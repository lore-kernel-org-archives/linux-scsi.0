From: <adheer.chandravanshi@qlogic.com>
Subject: [PATCH 7/7] qla4xxx: Update driver version to 5.03.00-k11
Date: Mon, 8 Jul 2013 08:33:11 -0400
Message-ID: <1373286791-29659-8-git-send-email-adheer.chandravanshi@qlogic.com>
References: <1373286791-29659-1-git-send-email-adheer.chandravanshi@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:30351
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752213Ab3GHNAt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jul 2013 09:00:49 -0400
Received: from mail128-co9 (localhost [127.0.0.1])	by
 mail128-co9-R.bigfish.com (Postfix) with ESMTP id 9D614C02D2	for
 <linux-scsi@vger.kernel.org>; Mon,  8 Jul 2013 13:00:48 +0000 (UTC)
Received: from CO9EHSMHS001.bigfish.com (unknown [10.236.132.226])	by
 mail128-co9.bigfish.com (Postfix) with ESMTP id 04FFB58005D	for
 <linux-scsi@vger.kernel.org>; Mon,  8 Jul 2013 13:00:46 +0000 (UTC)
In-Reply-To: <1373286791-29659-1-git-send-email-adheer.chandravanshi@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

From: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

Signed-off-by: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_version.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_version.h b/drivers/scsi/qla4xxx/ql4_version.h
index c5edd0d..c085c9a 100644
--- a/drivers/scsi/qla4xxx/ql4_version.h
+++ b/drivers/scsi/qla4xxx/ql4_version.h
@@ -5,4 +5,4 @@
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
 
-#define QLA4XXX_DRIVER_VERSION	"5.03.00-k10"
+#define QLA4XXX_DRIVER_VERSION	"5.03.00-k11"
-- 
1.7.1


