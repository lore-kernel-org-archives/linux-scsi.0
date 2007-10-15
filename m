From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 2/3] pluto/fc - Enable compilation for all ARCHs
Date: Mon, 15 Oct 2007 19:26:51 +0200
Message-ID: <4713A2DB.2000302@panasas.com>
References: <4713A175.9020408@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:7286 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756646AbXJOR1I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Oct 2007 13:27:08 -0400
In-Reply-To: <4713A175.9020408@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, "David S. Miller" <davem@davemloft.net>, Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>linux-scsi <linux>
Cc: FUJITA Tomonori <tomof@acm.org>


  - It was suggested on the linux-scsi-ml that:
    "Well if fc4.c compiles OK on non-sparc64 then perhaps we should
     enable compilation on non-sparc64.  It will increase maintainability
     and code quality and stuff."

  - WATCH OUT Distro maintainers:
	"otoh people might end up shipping useless drivers in x86 distros."

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 arch/sparc64/Kconfig |    2 --
 drivers/Kconfig      |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sparc64/Kconfig b/arch/sparc64/Kconfig
index 33dabf5..897afd8 100644
--- a/arch/sparc64/Kconfig
+++ b/arch/sparc64/Kconfig
@@ -456,8 +456,6 @@ source "drivers/Kconfig"
 
 source "drivers/sbus/char/Kconfig"
 
-source "drivers/fc4/Kconfig"
-
 source "fs/Kconfig"
 
 menu "Instrumentation Support"
diff --git a/drivers/Kconfig b/drivers/Kconfig
index 3e1c442..b57232d 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -22,6 +22,8 @@ source "drivers/misc/Kconfig"
 
 source "drivers/ide/Kconfig"
 
+source "drivers/fc4/Kconfig"
+
 source "drivers/scsi/Kconfig"
 
 source "drivers/ata/Kconfig"
-- 
1.5.3.1


