From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 10/10] scsi tgt: add NET dependence to Kconfig
Date: Mon, 10 Apr 2006 10:49:15 +0900 (JST)
Message-ID: <20060410104636Y.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:21757 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP
	id S1750868AbWDJBtd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Apr 2006 21:49:33 -0400
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

731f4924dd33579ffa5ff45ad03b7b7e933f728b
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
