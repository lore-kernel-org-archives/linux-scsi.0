From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 4/4] bsg: Kconfig updates
Date: Tue, 17 Jul 2007 19:08:51 +0900
Message-ID: <6f59b02bda38dd4d0a35a762d7651fec978909c6.1184666104.git.fujita.tomonori@lab.ntt.co.jp>
References: <40eb9fb0d327856034312127350a427a50eb4222.1184666104.git.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:34338 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349AbXGQKJZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2007 06:09:25 -0400
In-Reply-To: <40eb9fb0d327856034312127350a427a50eb4222.1184666104.git.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, tomof@acm.org

- add the detailed explanation.
- remove 'default y'.
- make 'EXPERIMENTAL' keyword visible to the user in menu.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/Kconfig |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/block/Kconfig b/block/Kconfig
index 6597b60..0768741 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -52,11 +52,16 @@ config LSF
 endif # BLOCK
 
 config BLK_DEV_BSG
-	bool "Block layer SG support"
+	bool "Block layer SG support v4 (EXPERIMENTAL)"
 	depends on (SCSI=y) && EXPERIMENTAL
-	default y
 	---help---
-	Saying Y here will enable generic SG (SCSI generic) v4
-	support for any block device.
+	Saying Y here will enable generic SG (SCSI generic) v4 support
+	for any block device.
+
+	Unlike SG v3 (aka block/scsi_ioctl.c drivers/scsi/sg.c), SG v4
+	can handle complicated SCSI commands: tagged variable length cdbs
+	with bidirectional data transfers and generic request/response
+	protocols (e.g. Task Management Functions and SMP in Serial
+	Attached SCSI).
 
 source block/Kconfig.iosched
-- 
1.4.3.2

