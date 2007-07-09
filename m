From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 4/4] bsg: Kconfig updates
Date: Mon, 9 Jul 2007 22:02:57 +0900
Message-ID: <20070708152714X.fujita.tomonori@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mfo10.iij4u.or.jp ([210.138.174.80]:38776 "EHLO
	mfo10.iij4u.or.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbXGINRd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jul 2007 09:17:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, tomof@acm.org

This updates bsg entry in Kconfig:

- bsg supports sg v4
- bsg depends on SCSI
- it might be better to mark it experimental for a while

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/block/Kconfig b/block/Kconfig
index 4d1cd1b..22dc027 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -53,9 +53,10 @@ endif
 
 config BLK_DEV_BSG
 	bool "Block layer SG support"
+	depends on SCSI && EXPERIMENTAL
 	default y
 	---help---
-	Saying Y here will enable generic SG (SCSI generic) v3
+	Saying Y here will enable generic SG (SCSI generic) v4
 	support for any block device.
 
 source block/Kconfig.iosched
-- 
1.4.4.4

