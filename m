From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH] scsi tgt: add NET dependence to Kconfig
Date: Thu, 16 Mar 2006 09:07:46 +0900
Message-ID: <20060316090746O.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:53470 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP id S932614AbWCPAHw
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Mar 2006 19:07:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

> From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>:

scsi_tgt_if.c depends on CONFIG_NET for using netlink.
So it would be nice if the Kconfig entry checks it.


Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

---

 drivers/scsi/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

c600d01f632122aa664bdfc89c8cf1796d61484c
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index d09c792..5b5eeb4 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -29,7 +29,7 @@ config SCSI
 
 config SCSI_TGT
 	tristate "SCSI target support"
-	depends on SCSI && EXPERIMENTAL
+	depends on SCSI && NET && EXPERIMENTAL
 	---help---
 	  If you want to use SCSI target mode drivers enable this option.
 	  If you choose M, the module will be called scsi_tgt.
-- 
1.1.5
