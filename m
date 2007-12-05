From: michaelc@cs.wisc.edu
Subject: [PATCH 12/23] iscsi_tcp: update the website URL
Date: Tue,  4 Dec 2007 18:42:26 -0600
Message-ID: <11968153812001-git-send-email-michaelc@cs.wisc.edu>
References: <11968153574025-git-send-email-michaelc@cs.wisc.edu>
 <119681536472-git-send-email-michaelc@cs.wisc.edu>
 <11968153663560-git-send-email-michaelc@cs.wisc.edu>
 <11968153713324-git-send-email-michaelc@cs.wisc.edu>
 <11968153753743-git-send-email-michaelc@cs.wisc.edu>
 <11968153751098-git-send-email-michaelc@cs.wisc.edu>
 <1196815376111-git-send-email-michaelc@cs.wisc.edu>
 <1196815377131-git-send-email-michaelc@cs.wisc.edu>
 <11968153781126-git-send-email-michaelc@cs.wisc.edu>
 <1196815378769-git-send-email-michaelc@cs.wisc.edu>
 <11968153791438-git-send-email-michaelc@cs.wisc.edu>
 <11968153801823-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297AbXLEAnV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Dec 2007 19:43:21 -0500
In-Reply-To: <11968153801823-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: FUJITA Tomonori <tomof@acm.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>

From: FUJITA Tomonori <tomof@acm.org>

Use open-iscsi.org instead of linux-iscsi.sf.net, which hasn't been
updated for ages.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index a6676be..ab965f5 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -341,7 +341,7 @@ config ISCSI_TCP
 	 The userspace component needed to initialize the driver, documentation,
 	 and sample configuration files can be found here:
 
-	 http://linux-iscsi.sf.net
+	 http://open-iscsi.org
 
 config SGIWD93_SCSI
 	tristate "SGI WD93C93 SCSI Driver"
-- 
1.5.1.2

